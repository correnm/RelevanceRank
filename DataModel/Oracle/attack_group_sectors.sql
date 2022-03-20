DROP table RESEARCH.attack_group_sectors

CREATE TABLE RESEARCH.attack_group_sectors
(
GROUP_ID 			VARCHAR2(20 CHAR),
sector_id			VARCHAR2(20 char)
);

COMMENT ON TABLE RESEARCH.attack_group_sectors is
'Groups are mapped to DHS critical infrastructure sectors';

ALTER TABLE RESEARCH.attack_group_sectors 
ADD CONSTRAINT attack_group_sectors_pk  PRIMARY KEY (group_id, sector_id);  

-- 	Load data using the Excel spreadsheet converted to CSV for import into DBeaver
--	attack_group_sectors.csv

INSERT INTO research.attack_group_sectors (group_id, sector_id)
SELECT group_id, sector_id1
FROM attack_group_sector_load
WHERE sector_id1 IS NOT NULL;

INSERT INTO research.attack_group_sectors (group_id, sector_id)
SELECT group_id, sector_id2
FROM attack_group_sector_load
WHERE sector_id2 IS NOT NULL;

INSERT INTO research.attack_group_sectors (group_id, sector_id)
SELECT group_id, sector_id3
FROM attack_group_sector_load
WHERE sector_id3 IS NOT NULL;

INSERT INTO research.attack_group_sectors (group_id, sector_id)
SELECT group_id, sector_id4
FROM attack_group_sector_load
WHERE sector_id4 IS NOT NULL;

INSERT INTO research.attack_group_sectors (group_id, sector_id)
SELECT group_id, sector_id5
FROM attack_group_sector_load
WHERE sector_id5 IS NOT NULL;

INSERT INTO research.attack_group_sectors (group_id, sector_id)
SELECT group_id, sector_id6
FROM attack_group_sector_load
WHERE sector_id6 IS NOT NULL;


-- Foreign key
ALTER TABLE RESEARCH.attack_group_sectors 
ADD CONSTRAINT attack_group_sectors_fk1
  FOREIGN KEY (group_id)
  REFERENCES attack_groups (group_id);
  
  -- Foreign key
ALTER TABLE RESEARCH.attack_group_sectors 
ADD CONSTRAINT attack_group_sectors_fk2
  FOREIGN KEY (sector_id)
  REFERENCES dhs_infrastructure_sectors (sector_id);