// clear existing data
MATCH (n:attackGroups) DELETE n;

// load data to create nodes
//:AUTO USING PERIODIC COMMIT 500

LOAD CSV WITH HEADERS from 'file:///RelevanceRank/2-data_files/attackGroups.csv' as line
CREATE (
	n:attackGroups
	{
		group_id:			line.GROUP_ID,
		group_name:			line.GROUP_NAME,
		group_description:	line.GROUP_DESCRIPTION,
		group_country:		line.GROUP_COUNTRY,
		year_of_origin:		line.YEAR_OF_ORIGIN
	}
)
RETURN count(n);