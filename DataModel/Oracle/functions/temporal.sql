CREATE OR REPLACE PROCEDURE RESEARCH.temporalScore (p_cve_year IN NUMBER) AS
	
	CURSOR get_cves (c_cve_year IN NUMBER) IS
	SELECT 
	assigner,
	cve_id,
	cvss_base_score,
	cvss_vector
	FROM research.nvd_cve
	WHERE cve_year = c_cve_year;

	
	temporalScore		research.nvd_cve.cvss_temporal_score%TYPE;
	cur_cve_id			research.nvd_cve.cve_id%TYPE;
	cisa				BOOLEAN;
	exploitdb			BOOLEAN;
	disputed			BOOLEAN;
	patchTag			VARCHAR2(256);
	remediation_tag		research.nvd_references.tag%TYPE := NULL;
	score				NUMBER(6,3);
	vector				research.nvd_cve.cvss_temporal_vector%TYPE;
	iMaturity			NUMBER(6,3);
	vMaturity			VARCHAR2(2);
	iRemediation		NUMBER(6,3);
	vRemediation		VARCHAR2(2);
	iConfidence			NUMBER(6,3);
	vConfidence			VARCHAR2(2);
	
	
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

	FUNCTION remediation (p_cve_id IN varchar2) RETURN varchar2 IS
	
		CURSOR get_remediation (c_cve_id IN varchar2) IS
		SELECT tag
		FROM research.nvd_references
		WHERE cve_id = c_cve_id
		AND tag IN ('Vendor Advisory', 'Patch','Third Party Advisory')
		ORDER by decode(tag, 'Third Party Advisory',1 , 'Vendor Advisory', 2, 'Patch',3 , 4) ASC;
		
	
	BEGIN
		remediation_tag := null;
		FOR x in get_remediation (p_cve_id)LOOP
			-- the highest value patch tag will be retrieved last
			remediation_tag := x.tag;		
		END LOOP;
		
		return remediation_tag;
	
	END; -- function
	
begin
	-- each cve_id
	FOR x in get_cves (p_cve_year) LOOP
		cur_cve_id := x.cve_id;
		
		-- only score CVSS V3.x
		IF instr(x.cvss_vector, 'CVSS:3') > 0 THEN
			-- Is there a known CISA exploit?
			cisa := cisa_exists(x.cve_id);
			
			-- Is there a POC in ExploitDB
			exploitdb := exploitdb_exists(x.cve_id);
			
			remediation_tag := remediation (x.cve_id);
/*			
			dbms_output.put_line( x.cve_id || ' '  
			|| 
			CASE
				  WHEN  cisa		THEN 'TRUE'
				  WHEN  NOT cisa	THEN 'FALSE'
				  ELSE 'UNKNOWN'
			END || ' = CISA '
			||
			CASE
				  WHEN  exploitdb		THEN 'TRUE'
				  WHEN  NOT exploitdb	THEN 'FALSE'
				  ELSE 'UNKNOWN'
			END || ' = EXPLOITDB '
			||
			remediation_tag ||'= REMEDIATION '
			);
*/
		
			--Determine Exploit Code Maturity
			if (cisa) THEN
				iMaturity := 0.97;
				vMaturity := 'F';
			elsif (exploitdb) THEN
				iMaturity := 0.94;
				vMaturity := 'P';
			else 
				iMaturity := 1;
				vMaturity := 'X';
			END IF;
	
			--Determine Remediation Level
			CASE (patchTag) 
				WHEN 'Third Party Advisory' THEN
					iRemediation := 0.97;
					vRemediation := 'W';
				WHEN 'Vendor Advisory' THEN
					iRemediation := 0.96;
					vRemediation := 'T';
				WHEN 'Patch' THEN
					iRemediation := 0.95;
					vRemediation := 'O';
				ELSE
					iRemediation := 1;
					vRemediation := 'U';
			END CASE;
		
			-- Determine Report Confidence
			IF (x.assigner is null) THEN 
				iConfidence := 1;
				vConfidence := 'X';
			ELSIF (instr(x.assigner,'mitre.org')) = 0 THEN
				iConfidence := 0.96;
				vConfidence := 'R';
			ELSE
				iConfidence := 1;
				vConfidence := 'C';
			END IF;
	
			vector := x.cvss_vector || '/E:' || vMaturity || '/RL:' || vRemediation || '/RC:' || vConfidence;
			score := (x.cvss_base_score * iRemediation * iConfidence * iMaturity);
			--Round up to highest tenth decimal. 
			--See https://stackoverflow.com/questions/44699418/modified-round-up-function-in-oracle
			temporalScore := ROUND((ceil(score * 100.50) /100),1);
			-- temporal score cannot exceed the base score
			IF temporalScore >= x.cvss_base_score THEN
				temporalScore := x.cvss_base_score;
			END IF;

			BEGIN	
/*			
				dbms_output.put_line( 
				x.cve_id || '  '  
				|| x.cvss_base_score || '  '
				|| vector || '  '
				|| score || '->'
				|| temporalScore
				);
*/		
				UPDATE RESEARCH.NVD_CVE
				SET CVSS_TEMPORAL_SCORE = temporalScore,
				CVSS_TEMPORAL_VECTOR = vector
				WHERE CVE_ID = cur_cve_id;

				COMMIT; 
				EXCEPTION
					WHEN others THEN
					dbms_output.put_line (x.cve_id || ' ' || SQLERRM);
					RAISE;
			END;
		END IF;
		
	END LOOP;
	-- All done. save changes when all processing completes
	COMMIT;
	
	EXCEPTION
		WHEN others THEN
		dbms_output.put_line (SQLERRM);
		RAISE;
end;
