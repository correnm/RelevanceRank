// clear existing data
MATCH (n:attackGroupSectors) DELETE n;

// load data to create nodes
//:AUTO USING PERIODIC COMMIT 500

LOAD CSV WITH HEADERS from 'file:///RelevanceRank/2-data_files/attackGroupSectors.csv' as line
CREATE (
	n:attackGroupSectors
	{
		group_id:		line.GROUP_ID,
		sector_id:		line.SECTOR_ID
	}
)
RETURN count(n);