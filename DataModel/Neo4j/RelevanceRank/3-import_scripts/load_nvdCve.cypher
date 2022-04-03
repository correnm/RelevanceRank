// clear existing data
MATCH (n:nvdCve) DELETE n;

// load data to create nodes
LOAD CSV WITH HEADERS from 'file:///RelevanceRank/2-data_files/nvdCve.csv' as line
CREATE (
	n:nvdCve
	{
	cve_year:						line.CVE_YEAR,
	cve_id:							line.CVE_ID,
	assigner:						line.ASSIGNER,
	cvss_base_score:				line.CVSS_BASE_SCORE,
	cvss_vector:					line.CVSS_VECTOR,
	cvss_temporal_score:			line.CVSS_TEMPORAL_SCORE,
	cvss_temporal_vector:			line.CVSS_TEMPORAL_VECTOR,
	exploitability:					line.EXPLOITABILITY,
	impact:							line.IMPACT,
	attack_vector:					line.ATTACKVECTOR,
	attack_complexity:				line.ATTACKCOMPLEXITY,
	privileges_required:			line.PRIVILEGESREQUIRED,
	user_interaction:				line.USERINTERACTION,
	scope:							line.SCOPE,
	confidentiality_impact:			line.CONFIDENTIALITYIMPACT,
	integrity_impact:				line.INTEGRITYIMPACT,
	availability_impact:			line.AVAILABILITYIMPACT,
	published_date:					line.PUBLISHED_DATE,
	modified_date:					line.MODIFIED_DATE,
	tier:							line.TIER,
	age_in_days:					line.AGE_IN_DAYS,
	severity:						line.SEVERITY
	}
)
RETURN count(n);													

// date format from string to Neo4j default yyyy-MM-dd
with apoc.date.parse('2021-11-23 10:27:00', "ms", "yyyy-MM-dd HH:mm:ss") AS ms
RETURN date(datetime({epochmillis: ms})) AS date