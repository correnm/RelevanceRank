DROP table RESEARCH.attack_enterprise_techniques;

CREATE TABLE RESEARCH.attack_enterprise_techniques
(
technique_id 				VARCHAR2(20 CHAR)	NOT NULL,
technique_name				VARCHAR2(200 CHAR)	NOT NULL,
technique_description		VARCHAR2(4000 CHAR),
technique_url				VARCHAR2(1000 CHAR),
created_string				VARCHAR2(20 CHAR),	-- 17 October 2018
last_modified_string		VARCHAR2(20 char),	-- 17 October 2018
created						DATE,
last_modified				DATE,
technique_version			VARCHAR2(5 char),
tactics						VARCHAR2(1000 char),
detection					VARCHAR2(4000 char),
platforms					VARCHAR2(1000 char),
data_sources				VARCHAR2(1000 char),
is_sub_technique			VARCHAR2(5 char),
sub_technique_of			VARCHAR2(20 char),
system_requirements			VARCHAR2(1000 char),
permissions_required		VARCHAR2(1000 char),
effective_permissions		VARCHAR2(1000 char),
defenses_bypassed			VARCHAR2(1000 char),
impact_type					VARCHAR2(1000 char),
supports_remote				VARCHAR2(5 char)
);

COMMENT ON TABLE RESEARCH.attack_enterprise_techniques is
'Techniques represent ''how'' an adversary achieves a tactical goal by performing an action. For example, an adversary may dump credentials to achieve credential access.';

-- Primary Key
ALTER TABLE RESEARCH.attack_enterprise_techniques  
ADD CONSTRAINT attack_enterprise_tech_pk  PRIMARY KEY (technique_id);  

-- Foreign key
ALTER TABLE RESEARCH.attack_enterprise_techniques  
ADD CONSTRAINT attack_enterprise_tech_fk
  FOREIGN KEY (sub_technique_of)
  REFERENCES attack_enterprise_techniques (technique_id);

-- 	Load data using the Excel spreadsheet converted to CSV for import into DBeaver
--	https://attack.mitre.org/docs/enterprise-attack-v10.1/enterprise-attack-v10.1-techniques.xlsx

-- Convert the string entries to DATE data types
UPDATE research.ATTACK_ENTERPRISE_TECHNIQUES
SET 
created = to_date(created_string, 'dd Month yyyy'),
last_modified = to_date(LAST_MODIFIED_STRING, 'dd Month yyyy');