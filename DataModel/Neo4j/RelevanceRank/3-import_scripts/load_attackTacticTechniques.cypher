// clear existing data
MATCH (n:attackTacticTechniques) DELETE n;

// load data to create nodes
//:AUTO USING PERIODIC COMMIT 500

LOAD CSV WITH HEADERS from 'file:///RelevanceRank/2-data_files/attackTacticTechniques.csv' as line
CREATE (
	n:attackTacticTechniques
	{
		technique_id:		line.TECHNIQUE_ID,
		tactic_id:			line.TACTIC_ID
	}
)
RETURN count(n);