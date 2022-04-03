// clear existing data
MATCH (n:capec) DELETE n;

// load data to create nodes
//:AUTO USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS from 'file:///Relevancerank/2-data_files/capec.csv' as line
CREATE (
	n:capec
	{
		capec_id:				line.CAPEC_ID,
		capec_name: 			line.CAPEC_NAME,
		consequence_scope:		line.CONSEQUENCE_SCOPE,
		consequence_impact:		line.CONSEQUENCE_IMPACT,
		likelihood_of_attack:	line.LIKELIHOOD_OF_ATTACK,
		severity:				line.LIKELIHOOD_OF_ATTACK,
		skill_level_high:		line.SKILL_LEVEL_HIGH,
		skill_level_low:		line.SKILL_LEVEL_LOW,
		skill_level_medium:		line.SKILL_LEVEL_MEDIUM
	}
)
RETURN count(n);