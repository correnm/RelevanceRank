DROP table RESEARCH.nvd_cwe;

CREATE TABLE RESEARCH.NVD_CWE 
(
CWE_ID	 				VARCHAR2(20 CHAR),
CVE_ID 					VARCHAR2(20 CHAR)
);

COMMENT ON TABLE RESEARCH.nvd_cwe is
'Links CVE_ID to its associated weaknesses.';

ALTER TABLE RESEARCH.nvd_cwe
ADD CONSTRAINT nvd_cwe_pk  PRIMARY KEY (cwe_id, cve_id);  

-- Foreign key
ALTER TABLE RESEARCH.nvd_cwe
ADD CONSTRAINT nvd_cwe_fk1
  FOREIGN KEY (cve_id)
  REFERENCES nvd_cve (cve_id);
  
ALTER TABLE RESEARCH.nvd_cwe
ADD CONSTRAINT nvd_cwe_fk2
  FOREIGN KEY (cwe_id)
  REFERENCES cwe (cwe_id);