// clear existing data
MATCH (n:nvdReferences) DELETE n;

// load data to create nodes
//:AUTO USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS from 'file:///RelevanceRank/2-data_files/nvdReferences.csv' as line
CREATE (
	n:nvdReferences
	{
	cve_id:					line.CVE_ID,
	url:					line.URL,
	name:					line.NAME,
	refsource:				line.REFSOURCE,
	tag:					line.TAG
	}
)
RETURN count(n);
				
