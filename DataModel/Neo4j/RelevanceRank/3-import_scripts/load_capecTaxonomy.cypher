// clear existing data
MATCH (n:capecTaxonomy) DELETE n;

// load data to create nodes
//:AUTO USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS from 'file:///Relevancerank/2-data_files/capecTaxonomy.csv' as line
CREATE (
	n:capecTaxonomy
	{
		capec_id:				line.CAPEC_ID,
		technique_id: 			line.TECHNIQUE_ID,
		technique_name:			line.TECHNIQUE_NAME
	}
)
RETURN count(n);