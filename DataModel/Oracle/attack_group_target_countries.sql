DROP table RESEARCH.attack_group_target_countries;

CREATE TABLE RESEARCH.attack_group_target_countries
(
GROUP_ID 			VARCHAR2(20 CHAR)	NOT NULL,
SHORT_FORM_NAME		VARCHAR2(100 char)	NOT NULL
);

COMMENT ON TABLE RESEARCH.attack_group_target_countries is
'Countries primarily targeted by an attack group';

ALTER TABLE RESEARCH.attack_group_target_countries
ADD CONSTRAINT attack_group_targ_cntry_pk  PRIMARY KEY (group_id, short_form_name);  

-- insert data from load
INSERT INTO research.attack_group_target_countries (group_id, short_form_name)
SELECT group_id, country1
FROM ATTACK_GROUP_TARG_CNTRY_LOAD
WHERE country1 IS NOT NULL;

INSERT INTO research.attack_group_target_countries (group_id, short_form_name)
SELECT group_id, country2
FROM ATTACK_GROUP_TARG_CNTRY_LOAD
WHERE country2 IS NOT NULL;

INSERT INTO research.attack_group_target_countries (group_id, short_form_name)
SELECT group_id, country3
FROM ATTACK_GROUP_TARG_CNTRY_LOAD
WHERE country3 IS NOT NULL;

INSERT INTO research.attack_group_target_countries (group_id, short_form_name)
SELECT group_id, country4
FROM ATTACK_GROUP_TARG_CNTRY_LOAD
WHERE country4 IS NOT NULL;

INSERT INTO research.attack_group_target_countries (group_id, short_form_name)
SELECT group_id, country5
FROM ATTACK_GROUP_TARG_CNTRY_LOAD
WHERE country5 IS NOT NULL;

INSERT INTO research.attack_group_target_countries (group_id, short_form_name)
SELECT group_id, country6
FROM ATTACK_GROUP_TARG_CNTRY_LOAD
WHERE country6 IS NOT NULL;

INSERT INTO research.attack_group_target_countries (group_id, short_form_name)
SELECT group_id, country7
FROM ATTACK_GROUP_TARG_CNTRY_LOAD
WHERE country7 IS NOT NULL;

INSERT INTO research.attack_group_target_countries (group_id, short_form_name)
SELECT group_id, country8
FROM ATTACK_GROUP_TARG_CNTRY_LOAD
WHERE country8 IS NOT NULL;

INSERT INTO research.attack_group_target_countries (group_id, short_form_name)
SELECT group_id, country9
FROM ATTACK_GROUP_TARG_CNTRY_LOAD
WHERE country9 IS NOT NULL;


-- Foreign key
ALTER TABLE RESEARCH.attack_group_target_countries 
ADD CONSTRAINT attack_group_targ_cntry_fk1
  FOREIGN KEY (group_id)
  REFERENCES attack_groups (group_id);
  
  -- Foreign key
ALTER TABLE RESEARCH.attack_group_target_countries
ADD CONSTRAINT attack_group_targ_cntry_fk2
  FOREIGN KEY (short_form_name)
  REFERENCES independent_states (short_form_name);