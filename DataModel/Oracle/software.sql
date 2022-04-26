DROP table RESEARCH.software

CREATE TABLE RESEARCH.software
(
software_id				VARCHAR2(10 char),
cpe_id					VARCHAR2(100 char),
sw_part					VARCHAR2(1 char),
sw_product				VARCHAR2(50 char),
sw_vendor				VARCHAR2(50 char),
sw_version				VARCHAR2(20 char)
);

COMMENT ON TABLE RESEARCH.software is
'Master list of software supported by multiple organizations.';

ALTER TABLE RESEARCH.software  
ADD CONSTRAINT software_pk  PRIMARY KEY (software_id);  

UPDATE research.software
SET sw_product = lower(sw_product),
sw_vendor = lower(sw_vendor);

