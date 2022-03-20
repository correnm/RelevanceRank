DROP TABLE research.cwraf_domains;

CREATE TABLE research.cwraf_domains (
domain_id 				VARCHAR2(5 char) NOT NULL,
domain_name				VARCHAR2(100 char) NOT NULL,
description				VARCHAR2(1000 char) NOT NULL,
vignettes				VARCHAR2(2000 char)
);

COMMENT ON TABLE RESEARCH.cwraf_domains is
'CWRAF provides a means for software developers and consumers to prioritize software weaknesses that are relevant for their business, mission, and deployed technologies.';

-- Primary Key
ALTER TABLE RESEARCH.cwraf_domains
ADD CONSTRAINT cwraf_domains_pk  PRIMARY KEY (domain_id); 