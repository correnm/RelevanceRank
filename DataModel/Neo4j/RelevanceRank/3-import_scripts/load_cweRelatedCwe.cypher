// clear existing data
MATCH (n:cweRelatedCwe) DELETE n;

// load data to create nodes
//:AUTO USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS from 'file:///RelevanceRank/2-data_files/cweRelatedCwe.csv' as line
CREATE (
	cwe:cweRelatedCwe 
	{
		cwe_id: 				line.CWE_ID,
		nature:					line.NATURE,
		related_cwe_id:			line.RELATED_CWE_ID
	}
)
RETURN count(cwe);