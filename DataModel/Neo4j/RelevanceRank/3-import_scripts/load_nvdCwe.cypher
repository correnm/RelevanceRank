// clear existing data
MATCH (n:nvdCwe) DETACH DELETE n;

// load data to create nodes
//:AUTO USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS from 'file:///RelevanceRank/2-data_files/nvdCwe.csv' as line
CREATE (
	n:nvdCwe 
	{
		cwe_id: 			line.CWE_ID,
		cve_id:				line.CVE_ID
	}
)
RETURN count(n);