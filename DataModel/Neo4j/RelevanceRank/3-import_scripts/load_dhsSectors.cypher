// clear existing data
MATCH (n:dhsSectors) DETACH DELETE n;

LOAD CSV WITH HEADERS from 'file:///RelevanceRank/2-data_files/dhsSectors.csv' as line
CREATE (
	n:dhsSectors
	{
		sector_id:			line.SECTOR_ID,
		sector_name:		line.SECTOR_NAME,
		sector_overview:	line.SECTOR_OVERVIEW
	}
)
RETURN count(n);