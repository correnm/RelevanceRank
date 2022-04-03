// clear existing data
MATCH (n:attackEnterpriseTechniques) DELETE n;

// load data to create nodes
//:AUTO USING PERIODIC COMMIT 500

LOAD CSV WITH HEADERS from 'file:///RelevanceRank/2-data_files/attackEnterpriseTechniques.csv' as line
CREATE (
	n:attackEnterpriseTechniques
	{
		technique_id:			line.TECHNIQUE_ID,
		technique_name:			line.TECHNIQUE_NAME,
		technique_description:	line.TECHNIQUE_DESCRIPTION,
		technique_url:			line.TECHNIQUE_URL,
		technique_version:		line.TECHNIQUE_VERSION,
		tactics:				line.TACTICS,
		detection:				line.DETECTION,
		platforms:				line.PLATFORMS,
		data_sources:			line.DATA_SOURCES,
		is_sub_technique:		line.IS_SUB_TECHNIQUE,
		sub_technique_of:		line.SUB_TECHNIQUE_OF,
		system_requirements:	line.SYSTEM_REQUIREMENTS,
		permissions_required:	line.PERMISSIONS_REQUIRED,
		effective_permissions:	line.EFFECTIVE_PERMISSIONS,
		defenses_bypassed:		line.DEFENSES_BYPASSED,
		impact_type:			line.IMPACT_TYPE,
		supports_remote:		line.SUPPORTS_REMOTE
	}
)
RETURN count(n);

												



