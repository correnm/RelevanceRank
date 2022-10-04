CREATE OR REPLACE PROCEDURE RESEARCH.calcRelevanceScore(
	p_org_id 		IN VARCHAR2 DEFAULT 'ODU',
	p_org_sector	IN VARCHAR2 DEFAULT 'Government Facilities',
	p_org_country	IN VARCHAR2 DEFAULT 'United States',
	p_group_country	IN VARCHAR2 DEFAULT 'Russia',
	p_risk_appetite	IN NUMBER   DEFAULT 0.90,
	p_cve_year		IN NUMBER	DEFAULT 2021
	) AS
	
	CURSOR get_cves (c_cve_year IN NUMBER) IS
	SELECT 
	n.assigner,
	n.cve_id,
	n.cvss_base_score,
	n.cvss_vector,
	e.epss_score,
	e.percentile
	FROM research.nvd_cve n,
	research.epss e
	WHERE e.cve_id = n.cve_id
	AND n.cve_year = c_cve_year
	--AND published_date BETWEEN '01-JAN-2021' AND '05-JAN-2021'
	ORDER BY published_date, n.cvss_base_Score DESC;
	

	cur_cve_id			research.nvd_cve.cve_id%TYPE;
	cisa				BOOLEAN;
	exploitdb			BOOLEAN;
	disputed			BOOLEAN;
	patchTag			VARCHAR2(256);
	rel_score			NUMBER(2,1);
	score				NUMBER(6,3);
	sector_country		research.attack_groups.group_country%TYPE;
	sector_threat		BOOLEAN;
	software			BOOLEAN;
	threat				BOOLEAN;
	group_country		research.attack_groups.group_country%TYPE;
	vector				research.nvd_cve.cvss_temporal_vector%TYPE;
		
	
	FUNCTION cisa_exists (p_cve_id IN varchar2) RETURN BOOLEAN IS
	
		CURSOR cisa_cve (c_cve_id IN varchar2) IS
		SELECT 'x'
		FROM research.cisa_exploit_catalog
		WHERE cve_id = c_cve_id;
		
		cisa_exists	BOOLEAN	:= FALSE;
	BEGIN
			FOR x in cisa_cve (p_cve_id) LOOP
				cisa_exists := TRUE;
			END LOOP;
	
			RETURN cisa_exists;
	END; -- function	

	FUNCTION exploitdb_exists (p_cve_id IN varchar2) RETURN BOOLEAN IS
	
		CURSOR exploitdb_cve (c_cve_id IN varchar2) IS
		SELECT 'x'
		FROM research.exploit_db
		WHERE cve_id = c_cve_id;
		
		exploitdb_exists	BOOLEAN	:= FALSE;
	BEGIN
			FOR x in exploitdb_cve (p_cve_id) LOOP
				exploitdb_exists := TRUE;
			END LOOP;
	
			RETURN exploitdb_exists;
	END; -- function	


	FUNCTION my_software (p_cve_id IN varchar2, p_org_id IN VARCHAR2) return boolean IS
	
		CURSOR get_software (c_cve_id IN VARCHAR2, c_org_id IN VARCHAR2) IS
		SELECT 'x'
		FROM 
		nvd_cve cve,
		nvd_cpe cpe,
		organizations org,
		org_software orgs,
		software sw
		WHERE cve.cve_id 			= cpe.cve_id
		AND cve.cve_id 				= c_cve_id
		AND lower(organization_short_name)	= lower(c_org_id)
		AND org.org_id 				= orgs.org_id
		AND orgs.software_id 		= sw.software_id
		AND cpe.part 				= sw.sw_part
		AND cpe.vendor 				= sw.sw_vendor
		AND cpe.product 			= sw.sw_product;
	

		software_exists BOOLEAN;
		
	BEGIN
		software_exists := FALSE;
		FOR x in get_software (p_cve_id, p_org_id) loop
			software_exists := true;
		END LOOP;
		
		return software_exists;
	END;
	
	FUNCTION known_threat (p_cve_id IN varchar2, p_group_country IN varchar2) return boolean IS
	
		CURSOR get_apt (c_cve_id IN VARCHAR2) IS
		SELECT DISTINCT
		ag.group_name,
		ag.group_country
		FROM nvd_cve cve,
		nvd_cwe cwe,
		cwe cwem,
		cwe_capec cwec,
		capec cpc,
		capec_taxonomy cpct,
		attack_enterprise_techniques aet,
		attack_group_techniques agt,
		attack_groups ag
		WHERE cve.cve_id	= c_cve_id
		-- vulns TO cwe
		AND cve.cve_id = cwe.cve_id
		AND cwe.cwe_id = cwem.cwe_id
		-- cwe TO capec
		AND cwe.cwe_id = cwec.cwe_id
		AND cwec.capec_id = cpc.capec_id
		-- capec to attack techniques
		AND cpc.capec_id = cpct.capec_id
		AND cpct.technique_id = aet.technique_id
		-- technique to group
		AND aet.technique_id = agt.technique_id
		AND agt.group_id = ag.group_id;

		threat_exists BOOLEAN;
		
	BEGIN
		threat_exists := FALSE;
		group_country := NULL;
		FOR x in get_apt (p_cve_id) loop
			threat_exists := true;
			
			IF x.group_country = p_group_country THEN
				group_country := x.group_country;
			END IF;
		END LOOP;
		
		return threat_exists;
	END;
	
	FUNCTION sector_threat_exists (p_cve_id IN varchar2, p_org_country IN varchar2, p_org_sector IN varchar2) return boolean IS
	
		CURSOR get_apt (c_cve_id IN VARCHAR2, c_org_country IN varchar2, c_org_sector IN varchar2) IS
		SELECT DISTINCT
		ag.group_name,
		ag.group_country,
		dhs.sector_name,
		agtc.short_form_name as sector_country
		FROM nvd_cve cve,
		nvd_cwe cwe,
		cwe cwem,
		cwe_capec cwec,
		capec cpc,
		capec_taxonomy cpct,
		attack_enterprise_techniques aet,
		attack_group_techniques agt,
		attack_groups ag,
		attack_group_sectors ags,
		dhs_infrastructure_sectors dhs,
		attack_group_target_countries agtc
		WHERE cve.cve_id				= c_cve_id
		--AND lower(short_form_name)	= lower(c_org_country)
		--AND lower(sector_name)		= lower(c_org_sector)
		-- vulns TO cwe
		AND cve.cve_id 					= cwe.cve_id
		AND cwe.cwe_id 					= cwem.cwe_id
		-- cwe TO capec
		AND cwe.cwe_id 					= cwec.cwe_id
		AND cwec.capec_id 				= cpc.capec_id
		-- capec to attack techniques
		AND cpc.capec_id 				= cpct.capec_id
		AND cpct.technique_id 			= aet.technique_id
		-- technique to group
		AND aet.technique_id 			= agt.technique_id
		AND agt.group_id 				= ag.group_id
		AND ags.group_id 				= ag.group_id
		AND ags.sector_id 				= dhs.sector_id
		AND agtc.group_id 				= ag.group_id;


		sector_threat_exists BOOLEAN;
		
	BEGIN
		sector_threat_exists := FALSE;
		sector_country := NULL;

		FOR x in get_apt (p_cve_id, p_org_country, p_org_sector) loop
			sector_threat_exists := true;
			
			IF x.sector_country = p_org_country THEN
				sector_country := x.sector_country;
			END IF;
		END LOOP;
		
		return sector_threat_exists;
	END;
	
/***************************************************/
begin

	-- clear old data
	DELETE FROM RESEARCH.RELEVANCE_RANK;
	
	FOR x in get_cves (p_cve_year) LOOP
		rel_score := 0;
		cur_cve_id := x.cve_id;
		
		
		IF instr(x.cvss_vector, 'CVSS:3') > 0 THEN
		
			--  Does CVE_ID affect the organization's installed software?
			software := my_software (x.cve_id, p_org_id);

			IF software THEN
				rel_score := rel_score + 1;
		
				-- Is there a known CISA exploit?
				cisa := cisa_exists(x.cve_id);
				exploitdb := exploitdb_exists(x.cve_id);			
				IF cisa OR exploitdb THEN
					rel_score := rel_score + 2;
				END IF;	
				
				-- percentile between 0 and 1
				IF x.percentile >= p_risk_appetite THEN
					rel_score := rel_score + 1;
				END IF;
		
	
				-- known threats
				threat := known_threat (x.cve_id, p_group_country);
			
				IF threat THEN
					rel_score := rel_score + 1;
					
					-- country of interest
					IF group_country = p_group_country THEN
						rel_score := rel_score + 0.5;
					END IF;
				
					-- targets my sector
					sector_threat := sector_threat_exists (x.cve_id, p_org_country, p_org_sector);
					IF sector_threat THEN
						rel_score := rel_score + 1;
						
						-- specifically, my country
						IF sector_country = p_org_country THEN
							rel_score := rel_score + 0.5;
						END IF;						
					END IF;
				END IF;
				
			ELSE
				-- not relevant
				rel_score := 0;
			END IF;
	
			dbms_output.put_line (x.cve_id || ' ' || to_char(x.cvss_base_score) ||' ' || to_char(rel_score));
			-- just the CVEs that impact the organization's infrastructure
			IF software THEN
				BEGIN
					INSERT INTO RESEARCH.RELEVANCE_RANK
					(cve_id, cvss_base_score, rel_score)
					VALUES
					(cur_cve_id, x.cvss_base_score, rel_score);
					COMMIT;
				
					EXCEPTION
						WHEN others THEN
						dbms_output.put_line (x.cve_id || ' ' || SQLERRM);
						RAISE;
				END;
			END IF;
			/***
			BEGIN	
				UPDATE RESEARCH.NVD_CVE
				SET relevance_score = rel_score
				WHERE CVE_ID = cur_cve_id;

				COMMIT; 
				EXCEPTION
					WHEN others THEN
					dbms_output.put_line (x.cve_id || ' ' || SQLERRM);
					RAISE;
			END;
			***/
		END IF;
	
	END LOOP;
	-- All done. save changes when all processing completes
	COMMIT;
	
	EXCEPTION
		WHEN others THEN
		dbms_output.put_line (SQLERRM);
		RAISE;
end;