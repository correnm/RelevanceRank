DROP table RESEARCH.attack_groups

CREATE TABLE RESEARCH.attack_groups
(
GROUP_ID 				VARCHAR2(20 CHAR),
GROUP_NAME				VARCHAR2(500 CHAR),
GROUP_DESCRIPTION		VARCHAR2(4000 CHAR),
GROUP_COUNTRY			VARCHAR2(100 CHAR),
YEAR_OF_ORIGIN			NUMBER(4),
created_string			VARCHAR2(20 CHAR),
last_modified_string	VARCHAR2(20 char),
created					DATE,
last_modified			DATE
);

COMMENT ON TABLE RESEARCH.attack_groups is
'Groups are sets of related intrusion activity that are tracked by a common name in the security community.';

ALTER TABLE RESEARCH.attack_groups  
ADD CONSTRAINT attack_groups_pk  PRIMARY KEY (group_id);  

-- 	Load data using the Excel spreadsheet converted to CSV for import into DBeaver
--	https://attack.mitre.org/docs/enterprise-attack-v10.1/enterprise-attack-v10.1-tactics.xlsx


-- Convert the string entries to DATE data types
UPDATE research.attack_groups
SET created = to_date(created_string, 'dd Month yyyy'),
LAST_MODIFIED = to_date(LAST_MODIFIED_STRING, 'dd Month yyyy');