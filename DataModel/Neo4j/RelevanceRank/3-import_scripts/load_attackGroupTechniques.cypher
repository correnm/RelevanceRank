// clear existing data
MATCH (n:attackGroupTechniques) DELETE n;

// load data to create nodes
//:AUTO USING PERIODIC COMMIT 500

LOAD CSV WITH HEADERS from 'file:///RelevanceRank/2-data_files/attackGroupTechniques.csv' as line
CREATE (
	n:attackGroupTechniques
	{
		group_id:			line.GROUP_ID,
		technique_id:		line.TECHNIQUE_ID
	}
)
RETURN count(n);