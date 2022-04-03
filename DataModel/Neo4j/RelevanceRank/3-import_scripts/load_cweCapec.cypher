// clear existing data
MATCH (n:cweCapec) DELETE n;

// load data to create nodes
//:AUTO USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS from 'file:///Relevancerank/2-data_files/cweCapec.csv' as line
CREATE (
	n:cweCapec
	{
		capec_id:				line.CAPEC_ID,
		cwe_id:					line.CWE_ID
	}
)
RETURN count(n);