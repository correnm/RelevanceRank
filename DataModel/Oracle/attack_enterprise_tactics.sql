DROP table RESEARCH.attack_enterprise_tactics;

CREATE TABLE RESEARCH.attack_enterprise_tactics
(
tactic_id 				VARCHAR2(20 CHAR)	NOT NULL,
tactic_name				VARCHAR2(50 CHAR)	NOT NULL,
tactic_description		VARCHAR2(4000 CHAR),
tactic_url				VARCHAR2(1000 CHAR),
created_string			VARCHAR2(20 CHAR),	-- 17 October 2018
last_modified_string	VARCHAR2(20 char),	-- 17 October 2018
created					DATE,
last_modified			DATE
);

COMMENT ON TABLE RESEARCH.attack_enterprise_tactics is
'Tactics represent the "why" of an ATT&CK technique or sub-technique. It is the adversary''s tactical goal: the reason for performing an action. For example, an adversary may want to achieve credential access.';

ALTER TABLE RESEARCH.attack_enterprise_tactics  
ADD CONSTRAINT attack_enterprise_tactics_pk  PRIMARY KEY (tactic_id);  

-- 	Load data using the Excel spreadsheet converted to CSV for import into DBeaver
--	https://attack.mitre.org/docs/enterprise-attack-v10.1/enterprise-attack-v10.1-tactics.xlsx


-- Convert the string entries to DATE data types
UPDATE research.ATTACK_ENTERPRISE_TACTICS 
SET created = to_date(created_string, 'dd Month yyyy'),
LAST_MODIFIED = to_date(LAST_MODIFIED_STRING, 'dd Month yyyy');