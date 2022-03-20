DROP TABLE research.capec_taxonomy;

CREATE TABLE research.capec_taxonomy (
capec_id 				VARCHAR2(20 char) NOT NULL,
technique_id			VARCHAR2(20 char) NOT NULL,
technique_name			VARCHAR2(200 char) NOT NULL
);

-- standardize technique naming to match Attack Enterprise techniques
UPDATE research.capec_taxonomy
set technique_id = 'T' || technique_id;


COMMENT ON TABLE RESEARCH.cwe_capec is
'Mapping of CAPEC to ATT&CK techniques.';

-- Primary Key
ALTER TABLE RESEARCH.capec_taxonomy 
ADD CONSTRAINT capec_taxonomy_pk  PRIMARY KEY (capec_id, technique_id); 

-- foreign keys
ALTER TABLE RESEARCH.capec_taxonomy
ADD CONSTRAINT capec_taxonomy_fk1
  FOREIGN KEY (technique_id)
  REFERENCES attack_enterprise_techniques (technique_id);
  
ALTER TABLE RESEARCH.cwe_capec
ADD CONSTRAINT cwe_capec_fk2
  FOREIGN KEY (capec_id)
  REFERENCES capec (capec_id);