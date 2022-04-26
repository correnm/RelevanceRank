DROP table RESEARCH.org_software

CREATE TABLE RESEARCH.org_software
(
ORG_ID					VARCHAR2(10 char) NOT NULL,
software_id				VARCHAR2(10 char),
org_software_name		VARCHAR2(100 char) NOT NULL
);

COMMENT ON TABLE RESEARCH.org_software is
'Software from the organizations software list.';

ALTER TABLE RESEARCH.org_software 
ADD CONSTRAINT org_software_pk  PRIMARY KEY (org_id, org_software_name);  

-- Foreign key
ALTER TABLE RESEARCH.org_software
ADD CONSTRAINT org_software_fk1
  FOREIGN KEY (org_id)
  REFERENCES organizations (org_id);
  
ALTER TABLE RESEARCH.org_software
ADD CONSTRAINT org_software_fk2
  FOREIGN KEY (software_id)
  REFERENCES software (software_id);

