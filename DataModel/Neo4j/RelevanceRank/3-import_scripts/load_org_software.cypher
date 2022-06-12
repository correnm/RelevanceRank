// clear existing data
CALL apoc.periodic.iterate('MATCH (n:orgSoftware) RETURN n', 'DETACH DELETE n', {batchSize:1000})

// load data to create nodes
LOAD CSV WITH HEADERS from 'file:///RelevanceRank/2-data_files/org_software.csv' as line
CREATE (
	n:orgSoftware
	{
	software_id:				line.SOFTWARE_ID,
	org_id:						line.ORG_ID,
	org_software_name:			line.ORG_SOFTWARE_NAME
	}
)
RETURN count(n);

LOAD CSV WITH HEADERS from 'file:///RelevanceRank/2-data_files/gov-org-software.csv' as line
CREATE (
	n:orgSoftware
	{
	software_id:				line.SOFTWARE_ID,
	org_id:						line.ORG_ID,
	org_software_name:			line.ORG_SOFTWARE_NAME
	}
)
RETURN count(n);