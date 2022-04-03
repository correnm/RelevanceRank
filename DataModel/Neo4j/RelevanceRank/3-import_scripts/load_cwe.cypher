// clear existing data
MATCH (n:cwe) DELETE n;

// load data to create nodes
//:AUTO USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS from 'file:///RelevanceRank/2-data_files/cwe.csv' as line
CREATE (
	cwe:cwe 
	{
		cwe_id: 				line.CWE_ID,
		cwe_name:				line.NAME,
		decription:				line.DESCRIPTION,
		likelihood_ef_exploit:	line.LIKELIHOOD_OF_EXPLOIT
	}
)
RETURN count(cwe);