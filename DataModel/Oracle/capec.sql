DROP TABLE research.capec;

CREATE TABLE research.capec (
capec_id 				VARCHAR2(20 char) NOT NULL,
cwe_id 					VARCHAR2(20 char) NOT NULL,
consequence_scope 		VARCHAR2(50 char) NOT NULL,
consequence_impact 		VARCHAR2(100 char) NOT NULL,
capec_description 		VARCHAR2(4000 char),
capec_name 				VARCHAR2(500 char),
likelihood_of_attack 	VARCHAR2(20 char),
mitigations 			VARCHAR2(2000 char),
severity 				VARCHAR2(20 char),
skill_level_high 		VARCHAR2(1000 char),
skill_level_low 		VARCHAR2(1000 char),
skill_level_medium 		VARCHAR2(1000 char)
);