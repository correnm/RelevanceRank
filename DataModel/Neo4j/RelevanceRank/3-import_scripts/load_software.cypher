// clear existing data
CALL apoc.periodic.iterate('MATCH (n:software) RETURN n', 'DETACH DELETE n', {batchSize:1000})

// load data to create nodes
LOAD CSV WITH HEADERS from 'file:///RelevanceRank/2-data_files/software.csv' as line
CREATE (
	n:software
	{
	software_id:				line.SOFTWARE_ID,
	cpe_id:						line.CPE_ID,
	part:						line.SW_PART,
	product:					line.SW_PRODUCT,
	vendor:						line.SW_VENDOR,
	version:					line.SW_VERSION
	}
)
RETURN count(n);