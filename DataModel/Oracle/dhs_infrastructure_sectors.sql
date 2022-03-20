DROP TABLE research.dhs_infrastructure_sectors;

CREATE TABLE research.dhs_infrastructure_sectors (
sector_id 				VARCHAR2(5 char) NOT NULL,
sector_name				VARCHAR2(100 char) NOT NULL,
sector_overview			VARCHAR2(4000 char) NOT NULL
);

COMMENT ON TABLE RESEARCH.dhs_infrastructure_sectors is
'There are 16 critical infrastructure sectors whose assets, systems, and networks, whether physical or virtual, are considered so vital to the United States that their incapacitation or destruction would have a debilitating effect on security, national economic security, national public health or safety, or any combination thereof.';

-- Primary Key
ALTER TABLE RESEARCH.dhs_infrastructure_sectors
ADD CONSTRAINT dhs_infrastructure_sectors_pk  PRIMARY KEY (sector_id); 