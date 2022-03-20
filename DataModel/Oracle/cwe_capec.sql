DROP table RESEARCH.cwe_capec;

CREATE TABLE RESEARCH.CWE_CAPEC
(
CWE_ID 					VARCHAR2(20 CHAR),
CAPEC_ID				VARCHAR2(20 CHAR)
);

-- standardize CWE naming.
UPDATE research.cwe_capec
set cwe_id = 'CWE-' || cwe_id;

-- standardize CAPEC naming
UPDATE research.cwe_capec
set capec_id = 'CAPEC-' || capec_id;


COMMENT ON TABLE RESEARCH.cwe_capec is
'Mapping of CWE to attack patterns.';

-- Primary Key
ALTER TABLE RESEARCH.cwe_capec 
ADD CONSTRAINT cwe_capec_pk  PRIMARY KEY (cwe_id, capec_id); 

-- foreign keys
ALTER TABLE RESEARCH.cwe_capec
ADD CONSTRAINT cwe_capec_fk1
  FOREIGN KEY (cwe_id)
  REFERENCES cwe (cwe_id);
  
ALTER TABLE RESEARCH.cwe_capec
ADD CONSTRAINT cwe_capec_fk2
  FOREIGN KEY (capec_id)
  REFERENCES capec (capec_id);