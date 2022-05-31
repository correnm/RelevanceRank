DROP TABLE research.independent_states;

CREATE TABLE research.independent_states (
short_form_name				VARCHAR2(100 char) NOT NULL,
long_form_name				VARCHAR2(500 char) ,
capital						VARCHAR2(200 char),
latitude					VARCHAR2(20 char),
longitude					VARCHAR2(20 char)
);

COMMENT ON TABLE RESEARCH.independent_states is
'Independent States in the World as recognized by the US State Department';

-- Primary Key
ALTER TABLE RESEARCH.independent_states
ADD CONSTRAINT independent_states_pk  PRIMARY KEY (short_form_name); 