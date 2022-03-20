DROP table RESEARCH.attack_group_techniques

CREATE TABLE RESEARCH.attack_group_techniques
(
GROUP_ID 				VARCHAR2(20 CHAR),
technique_id			VARCHAR2(20 char)
);

COMMENT ON TABLE RESEARCH.attack_group_techniques is
'Groups are mapped to publicly reported technique use and original references are included. The information provided does not represent all possible technique use by Groups, but rather a subset that is available solely through open source reporting';

ALTER TABLE RESEARCH.attack_group_techniques 
ADD CONSTRAINT attack_group_techniques_pk  PRIMARY KEY (group_id, technique_id);  

-- 	Load data using the Excel spreadsheet converted to CSV for import into DBeaver
--	https://attack.mitre.org/docs/enterprise-attack-v10.1/enterprise-attack-v10.1-tactics.xlsx


-- Foreign key
ALTER TABLE RESEARCH.attack_group_techniques  
ADD CONSTRAINT attack_group_tech_fk1
  FOREIGN KEY (group_id)
  REFERENCES attack_groups (group_id);
  
  -- Foreign key
ALTER TABLE RESEARCH.attack_group_techniques  
ADD CONSTRAINT attack_group_tech_fk2
  FOREIGN KEY (technique_id)
  REFERENCES attack_enterprise_techniques (technique_id);