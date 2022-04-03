// clear existing data
MATCH (n:attackEnterpriseTactics) DELETE n;

// load data to create nodes
//:AUTO USING PERIODIC COMMIT 500

LOAD CSV WITH HEADERS from 'file:///RelevanceRank/2-data_files/attackEnterpriseTactics.csv' as line
CREATE (
	n:attackEnterpriseTactics
	{
		tactic_id:				line.TACTIC_ID,
		tactic_name:			line.TACTIC_NAME,
		tactic_description:		line.TACTIC_DESCRIPTION,
		tactic_url:				line.tactic_URL
	}
)
RETURN count(n);