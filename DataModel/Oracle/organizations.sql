DROP table RESEARCH.organizations

CREATE TABLE RESEARCH.organizations
(
ORG_ID					VARCHAR2(10 char) NOT NULL,
organization_name		VARCHAR2(100 char) NOT NULL,
organization_short_name	VARCHAR2(10 char) NOT NULL,
sector_id				VARCHAR2(5 char),
web_link				VARCHAR2(200 char),
enrollment				NUMBER(5),
country_short_name		VARCHAR2(100 char)
);

COMMENT ON TABLE RESEARCH.organizations is
'Individual organization associated with a DHS sector.';

ALTER TABLE RESEARCH.organizations  
ADD CONSTRAINT organizations_pk  PRIMARY KEY (org_id);  

-- Foreign key
ALTER TABLE RESEARCH.organizations
ADD CONSTRAINT organizations_fk1
  FOREIGN KEY (sector_id)
  REFERENCES dhs_infrastructure_sectors (sector_id);

