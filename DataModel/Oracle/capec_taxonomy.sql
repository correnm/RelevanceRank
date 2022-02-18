DROP TABLE research.capec_taxonomy;

CREATE TABLE research.capec_taxonomy (
capec_id 				VARCHAR2(20 char) NOT NULL,
technique_id			VARCHAR2(20 char) NOT NULL,
technique_name			VARCHAR2(200 char) NOT NULL
);