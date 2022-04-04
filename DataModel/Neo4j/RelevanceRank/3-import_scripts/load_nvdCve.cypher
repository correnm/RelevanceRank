// clear existing data
CALL apoc.periodic.iterate('MATCH (n:nvdCve) RETURN n', 'DETACH DELETE n', {batchSize:1000})

// load data to create nodes
LOAD CSV WITH HEADERS from 'file:///RelevanceRank/2-data_files/nvdCve.csv' as line
CREATE (
	n:nvdCve
	{
	cve_year:						toInteger(line.CVE_YEAR),
	cve_id:							line.CVE_ID,
	assigner:						line.ASSIGNER,
	cvss_base_score:				toFloat(line.CVSS_BASE_SCORE),
	cvss_vector:					line.CVSS_VECTOR,
	cvss_temporal_score:			line.CVSS_TEMPORAL_SCORE,
	cvss_temporal_vector:			line.CVSS_TEMPORAL_VECTOR,
	exploitability:					toFloat(line.EXPLOITABILITY),
	impact:							toFloat(line.IMPACT),
	attack_vector:					line.ATTACKVECTOR,
	attack_complexity:				line.ATTACKCOMPLEXITY,
	privileges_required:			line.PRIVILEGESREQUIRED,
	user_interaction:				line.USERINTERACTION,
	scope:							line.SCOPE,
	confidentiality_impact:			line.CONFIDENTIALITYIMPACT,
	integrity_impact:				line.INTEGRITYIMPACT,
	availability_impact:			line.AVAILABILITYIMPACT,
	published_date:					datetime(line.PUBLISHED_DATE),
	modified_date:					datetime(line.MODIFIED_DATE),
	tier:							line.TIER,
	age_in_days:					toInteger(line.AGE_IN_DAYS),
	severity:						line.SEVERITY
	}
)
RETURN count(n);													

// date format from string to Neo4j default yyyy-MM-dd
with apoc.date.parse('2021-11-23 10:27:00', "ms", "yyyy-MM-dd HH:mm:ss") AS ms
RETURN date(datetime({epochmillis: ms})) AS date

match (n:nvdCVE)
set cve_year=toInteger(cve_year),
cvss_base_score = toFloat(cvss_base_score),
exploitability = toFloat(exploitability),
impact = toFloat(impact),
published_date =