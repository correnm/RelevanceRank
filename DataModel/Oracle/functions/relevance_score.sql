CREATE OR REPLACE PROCEDURE RESEARCH.calcRelevanceScore(
	p_org_id 				IN VARCHAR2,
	p_group_country			IN VARCHAR2 DEFAULT 'Russia',
	p_risk_appetite			IN NUMBER   DEFAULT 0.876,
	p_cve_year				IN NUMBER	DEFAULT 2019,
	p_cve_end_year			IN NUMBER	DEFAULT 2021,
	p_delete_old_entries	IN VARCHAR2 DEFAULT 'N',
	p_scenario				IN NUMBER   DEFAULT 1,
	p_likelihood_of_attack	IN VARCHAR2 DEFAULT 'High',
	p_severity				IN VARCHAR2 DEFAULT 'High',
	p_skill_level			IN VARCHAR2 DEFAULT 'High'
	) AS

	CURSOR get_organizations (c_org_id IN VARCHAR2) IS
	SELECT
	org_id,
	sector_id 			as org_sector_id,
	country_short_name 	as org_country
	FROM research.organizations
	-- specific or all if not passed as a parameter
	where org_id = NVL(c_org_id, org_id)
	ORDER BY org_id;
		
	CURSOR get_week_start(c_start_date IN varchar2) IS
	select week_day as week_start
	from   (
	select to_date(c_start_date, 'DD-MON-YYYY') + level week_day
	from   dual
	connect by level <= 366
	)  
	where to_char ( 
		week_day, 
		'fmday', 
		'nls_date_language = English' 
	) = 'tuesday'
	-- must be in the same year
	AND TRUNC(to_date(week_day), 'YYYY') = TRUNC(to_date(c_start_date), 'YYYY');
	
	-- Weekly vulnerabilities for this organization	
	CURSOR get_cves (c_week_start IN DATE, c_org_id IN VARCHAR2) IS
	SELECT 
	n.assigner,
	n.cve_id,
	n.cvss_base_score,
	n.cvss_temporal_score,
	n.cvss_vector,
	n.attackvector,
	e.epss_score,
	e.percentile
	FROM research.nvd_cve n,
	research.epss e
	WHERE e.cve_id = n.cve_id
	AND
	( -- new or updated CVE-ID
	published_date BETWEEN c_week_start AND c_week_start + 6 
	OR
	modified_date BETWEEN c_week_start and c_week_start + 6
	)
	AND n.CVE_ID IN
		(
		SELECT 
		cve.CVE_ID
		FROM nvd_cve cve,
		nvd_cpe cpe,
		organizations org,
		org_software orgs,
		software sw
		WHERE cve.cve_id 				= cpe.cve_id
		AND org.org_id					= c_org_id
		AND org.org_id 					= orgs.org_id
		AND orgs.software_id 			= sw.software_id
		AND cpe.part 					= sw.sw_part
		AND cpe.vendor 					= sw.sw_vendor
		AND cpe.product 				= sw.sw_product
		)
	ORDER BY n.cvss_base_score DESC, n.cve_id ASC;

	cur_cve_id				research.nvd_cve.cve_id%TYPE;
	cisa					BOOLEAN;
	cost					NUMBER(5,2);
	end_year				NUMBER(4);
	exploitdb				BOOLEAN;
	disputed				BOOLEAN;
	patchTag				VARCHAR2(256);
	rel_score				NUMBER(3);
	ideal_score				NUMBER(3);
	scenario				VARCHAR2(256);
	score					NUMBER(6,3);
	sector_country			research.attack_groups.group_country%TYPE;
	sector_threat			BOOLEAN;
	software				BOOLEAN;
	start_date				VARCHAR2(15); -- dd-MON-yyyy
	start_year				NUMBER(4);
	threat					BOOLEAN;
	group_country			research.attack_groups.group_country%TYPE;
	vector					research.nvd_cve.cvss_temporal_vector%TYPE;
	-- feature vector for graded relevance
	t_software				NUMBER(1);
	t_remote_exploitable	NUMBER(1);
	t_known_exploit			NUMBER(1);
	t_risk_appetite_met		NUMBER(1);
	t_known_threat			NUMBER(1);
	t_known_threat_country 	NUMBER(1);
	t_sector_threat			NUMBER(1);
	t_sector_threat_country	NUMBER(1);
	t_likelihood			NUMBER(1);
	t_severity				NUMBER(1);
	t_skill_level			NUMBER(1);
		
	
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
	
	FUNCTION sector_threat_exists (p_cve_id IN varchar2, p_org_country IN varchar2, p_org_sector_id IN varchar2) return boolean IS
	
		CURSOR get_apt (c_cve_id IN VARCHAR2, c_org_country IN varchar2, c_org_sector_id IN varchar2) IS
		SELECT DISTINCT
		ag.group_name,
		ag.group_country,
		dhs.sector_id,
		agtc.short_form_name as sector_country
		FROM nvd_cve 					cve,
		nvd_cwe 						cwe,
		cwe 							cwem,
		cwe_capec 						cwec,
		capec 							cpc,
		capec_taxonomy 					cpct,
		attack_enterprise_techniques 	aet,
		attack_group_techniques 		agt,
		attack_groups 					ag,
		attack_group_sectors 			ags,
		dhs_infrastructure_sectors 		dhs,
		attack_group_target_countries 	agtc
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

		FOR x in get_apt (p_cve_id, p_org_country, p_org_sector_id) loop
		
			IF x.sector_id = p_org_sector_id THEN
				sector_threat_exists := true;
			END IF;
			
			IF x.sector_country = p_org_country THEN
				sector_country := x.sector_country;
			END IF;
		END LOOP;
		
		return sector_threat_exists;
	END;
	
	-- calculate relevance score for this scenario based on MITRE ATT&CK
	FUNCTION scenario_attack (
		p_cve_id IN VARCHAR2, p_cvss_vector IN VARCHAR2, p_attackvector IN VARCHAR2, p_percentile IN NUMBER,
		p_org_id IN VARCHAR2, p_org_country IN VARCHAR2, p_org_sector_id IN VARCHAR2, p_ideal_score OUT NUMBER) return NUMBER IS
		
		t_rel_score		NUMBER(3);
		t_ideal_score	NUMBER(3);
	BEGIN
		cur_cve_id 				:= p_cve_id;
		t_rel_score 			:= 0;
		t_ideal_score			:= 0;
					
			
				
		IF instr(p_cvss_vector, 'CVSS:3') > 0 THEN
		
			--  Does CVE_ID affect the organization's installed software?
			software := my_software (p_cve_id, p_org_id);

			IF software THEN
				t_rel_score := t_rel_score + 1;
				t_ideal_score := t_ideal_score + 1;
				t_software	:= 1;
				
				-- remotely exploitable
				IF upper(p_attackvector) = 'NETWORK' THEN
					t_rel_score := t_rel_score + 1;
					t_ideal_score := t_ideal_score + 1;
					t_remote_exploitable		:= 1;
				END IF;
		
				-- Is there a known CISA exploit?
				cisa 		:= cisa_exists(p_cve_id);
				exploitdb 	:= exploitdb_exists(p_cve_id);			
				IF (cisa OR exploitdb) THEN
					-- only the ideal rank has foreknowledge of exploit
					t_ideal_score := t_ideal_score + 1;
					t_known_exploit	:= 1;
					
				END IF;
				
				-- percentile between 0 and 1
				IF (p_percentile >= p_risk_appetite) AND t_known_exploit = 0 THEN
					t_rel_score   := t_rel_score + 1;
					t_risk_appetite_met	:= 1;
				END IF;
	
				-- known threats
				threat := known_threat (p_cve_id, p_group_country);
			
				IF threat THEN
					t_rel_score 	:= t_rel_score + 1;
					t_known_threat	:= 1;
					t_ideal_score    := t_ideal_score + 1;
					-- country of interest
					IF group_country = p_group_country THEN
						t_rel_score   := t_rel_score + 1;
						t_ideal_score := t_ideal_score + 1;
						t_known_threat_country 	:= 1;
					END IF;
				
					-- targets my sector
					sector_threat := sector_threat_exists (p_cve_id, p_org_country, p_org_sector_id);
					IF sector_threat THEN
						t_rel_score 	:= t_rel_score + 1;
						t_ideal_score := t_ideal_score + 1;
						t_sector_threat	:= 1;

						-- specifically, my country
						IF sector_country = p_org_country THEN
							t_rel_score := t_rel_score + 1;
							t_ideal_score := t_ideal_score + 1;
							t_sector_threat_country	:= 1;
						END IF;						
					END IF; -- sector_threat
				END IF; -- threat
				
			ELSE 
				-- not relevant
				t_rel_score := 0;
			END IF; -- software
		END IF; -- CVSSV3
		
		p_ideal_score := t_ideal_score;
		return t_rel_score;
	
	END; -- scenario_attack

	-- calculate relevance score for this scenario based on CAPEC
	FUNCTION scenario_capec (
		p_cve_id IN VARCHAR2, p_cvss_vector IN VARCHAR2, p_likelihood_of_attack IN VARCHAR2, p_severity IN VARCHAR2,
		p_skill_level IN VARCHAR2, p_org_id IN VARCHAR2, p_percentile IN NUMBER, p_ideal_score OUT NUMBER) return NUMBER IS

		CURSOR get_capec (c_cve_id IN varchar2) IS
		SELECT DISTINCT
		capec.likelihood_of_attack,
		capec.severity,
		DECODE(capec.skill_level_high, NULL, NULL, 'HIGH') AS skill_level_high,
		DECODE(capec.skill_level_low, NULL, NULL, 'LOW') AS skill_level_low,
		DECODE(capec.skill_level_medium, NULL, NULL, 'MEDIUM') AS skill_level_medium
		FROM capec
		WHERE capec_id IN
		( 
		SELECT capec.capec_id
		FROM nvd_cve 	ncve,
		nvd_cwe			ncwe,
		cwe_capec       ccwe
		WHERE ncve.cve_id			= c_cve_id
		and ncve.cve_id				= ncwe.cve_id
		and ncwe.cwe_id				= ccwe.cwe_id
		);
		
		
		t_rel_score		NUMBER(3);
		t_ideal_score	NUMBER(3);
		c_likelihood	BOOLEAN;
		c_severity		BOOLEAN;
		c_skill_level	BOOLEAN;
	BEGIN
		cur_cve_id 				:= p_cve_id;
		t_rel_score 			:= 0;
		t_ideal_score			:= 0;
		c_likelihood			:= false;
		c_severity				:= false;
		c_skill_level			:= false;
				
		IF instr(p_cvss_vector, 'CVSS:3') > 0 THEN
		
			--  Does CVE_ID affect the organization's installed software?
			software := my_software (p_cve_id, p_org_id);

			IF software THEN
				t_rel_score := t_rel_score + 1;
				t_ideal_score := t_ideal_score + 1;
				t_software	:= 1;
				
				-- likelihood of attack, severity, skill_level_high
				FOR x in get_capec(p_cve_id) LOOP
					IF UPPER(x.likelihood_of_attack) = upper(p_likelihood_of_attack) THEN
						c_likelihood := true;					
					END IF;
					
					IF upper(x.severity) = upper(p_severity) THEN
						c_severity := true;
						
					END IF;
					
					-- only one will be true (match parameter)
					CASE
						WHEN x.skill_level_high = upper(p_skill_level) THEN c_skill_level := true;
						WHEN x.skill_level_low = upper(p_skill_level) THEN c_skill_level := true;
						WHEN x.skill_level_medium = upper(p_skill_level) THEN c_skill_level := true;
						else null;
					END CASE;
					
				END LOOP;
				
				-- Is there a known CISA exploit?
				cisa 		:= cisa_exists(p_cve_id);
				exploitdb 	:= exploitdb_exists(p_cve_id);			
				IF (cisa OR exploitdb) THEN
					-- only the ideal rank has foreknowledge of exploit
					t_ideal_score := t_ideal_score + 1;
					t_known_exploit	:= 1;
					
				END IF;
				
				-- percentile between 0 and 1
				IF (p_percentile >= p_risk_appetite) AND t_known_exploit = 0 THEN
					t_rel_score   := t_rel_score + 1;
					t_risk_appetite_met	:= 1;
				END IF;
		
				IF c_likelihood THEN
					t_rel_score 	:= t_rel_score + 1;
					t_ideal_score 	:= t_ideal_score + 1;
					t_likelihood 	:= 1;
				END IF;

				IF c_severity THEN
					t_rel_score 	:= t_rel_score + 1;
					t_ideal_score 	:= t_ideal_score + 1;
					t_severity 		:= 1;
				END IF;
				
				IF c_skill_level THEN
					t_rel_score 	:= t_rel_score + 1;
					t_ideal_score 	:= t_ideal_score + 1;
					t_skill_level 	:= 1;
				END IF;			
				
			ELSE 
				-- not relevant
				t_rel_score 	:= 0;
				t_ideal_score 	:= 0;
			END IF; -- software
		END IF; -- CVSSV3
		
		p_ideal_score := t_ideal_score; --OUT
		return t_rel_score;
	
	END; -- scenario_capec

/************ DRIVER ***************************************/
BEGIN
	-- clear old data
	IF upper(p_delete_old_entries) = 'Y' THEN
		DELETE FROM RESEARCH.RELEVANCE_RANK;
	END IF;
	
	start_year 	:= p_cve_year;
	end_year 	:= p_cve_end_year;
	WHILE (start_year <= end_year) LOOP
		-- calculate relevance score for each organization
		FOR org in get_organizations (p_org_id) LOOP
			-- Search for vulnerabilities in this year by week starting on Sunday
			start_date := '01-Jan-' || to_char(start_year);
			FOR week in get_week_start(start_date) LOOP
				
				-- get weekly vulns for this organization
				FOR x in get_cves (week.week_start, org.org_id) LOOP
					-- initial setting for relevance
					rel_score 				:= 0;
					ideal_score				:= 0;
					cost	  				:= 0;
					cur_cve_id 				:= x.cve_id;
					t_software				:= null;
					t_remote_exploitable	:= null;
					t_known_exploit			:= null;
					t_risk_appetite_met		:= null;
					t_known_threat			:= null;
					t_known_threat_country 	:= null;
					t_sector_threat			:= null;
					t_sector_threat_country	:= null;
		
					-- calculate relevance score for scenario_attack
					CASE 
						WHEN p_scenario = 1 THEN
							scenario := 'ATTACK';	
							rel_score := scenario_attack (x.cve_id, x.cvss_vector, x.attackvector, x.percentile, org.org_id, org.org_country, org.org_sector_id, ideal_score);
						WHEN p_scenario = 2 THEN
							scenario := 'CAPEC';
							rel_score := scenario_capec (x.cve_id, x.cvss_vector, p_likelihood_of_attack, p_severity, p_skill_level, org.org_id, x.percentile,ideal_score);
						ELSE
							scenario := 'UNKNOWN';
							rel_score := 0;
							ideal_score := 0;
					END CASE;
					
					CASE
						WHEN x.cvss_base_score between 0 and 3.9 THEN
							cost := 0.25;
						WHEN x.cvss_base_score between 4 and 6.9 THEN
							cost := 1;
						WHEN x.cvss_base_score between 7 and 8.9 THEN
							cost := 1.5;							
						WHEN x.cvss_base_score between 9 and 10 THEN
							cost := 3;
					END CASE;
/*
					dbms_output.put_line (
					org.org_id || ' ' || week.week_start || ' ' || cur_cve_id || ' ' || 
					to_char(x.cvss_base_score) || ' ' || to_char(rel_score)
					);
*/					
					BEGIN					
						INSERT INTO RESEARCH.RELEVANCE_RANK
						(organization_short_name, 
						apt_country,	
						scenario,
						risk_appetite,
						cve_year,
						p_likelihood,
						p_severity,
						p_skill_level,
						week_start,
						cve_id, 
						cvss_base_score, 
						cvss_temporal_score,
						cvss_base_rank,
						rel_score,
						rel_rank,
						ideal_score,
						ideal_rank,
						cost,
						software,
						remote_exploitable,
						known_exploit,
						risk_appetite_met,
						known_threat,
						known_threat_country,
						sector_threat,
						sector_threat_country,
						likelihood,
						severity, 
						skill_level
						)
						VALUES
						(org.org_id, 
						p_group_country, 
						scenario,
						p_risk_appetite,
						start_year,
						p_likelihood_of_attack,
						p_severity,
						p_skill_level,
						week.week_start, 
						cur_cve_id, 
						x.cvss_base_score,
						x.cvss_temporal_score,
						null,
						rel_score,
						null,
						ideal_score,
						null,
						cost,
						t_software,
						t_remote_exploitable,
						t_known_exploit,
						t_risk_appetite_met,
						t_known_threat,
						t_known_threat_country,
						t_sector_threat,
						t_sector_threat_country,
						t_likelihood,
						t_severity,
						t_skill_level
						);
						COMMIT;
				
						EXCEPTION
						WHEN others THEN
							dbms_output.put_line (
							org.org_id || ' ' || week.week_start || ' ' || cur_cve_id || ' ' || 
							to_char(x.cvss_base_score) || ' ' || to_char(rel_score) || ' ' || SQLERRM
							);
							RAISE;
					END; -- insert

				END LOOP; -- get_cves
				
			END LOOP; -- get_week_start
		END LOOP; -- get_organization
		start_year := start_year + 1;
	END LOOP;
	-- All done. save changes when all processing completes
	COMMIT;
	
	EXCEPTION
		WHEN others THEN
		dbms_output.put_line (SQLERRM);
		RAISE;
END;