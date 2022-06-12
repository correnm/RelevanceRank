// clear existing data
CALL apoc.periodic.iterate('MATCH (n:organizations) RETURN n', 'DETACH DELETE n', {batchSize:1000})

// load data to create nodes
LOAD CSV WITH HEADERS from 'file:///RelevanceRank/2-data_files/organizations.csv' as line
MERGE (
	n:organizations:academia
	{
	org_id:							line.ORG_ID,
	organization_name:				line.ORGANIZATION_NAME,
	organization_short_name:		line.ORGANIZATION_SHORT_NAME,
	sector_id:						line.SECTOR_ID,
	enrollment:						toInteger(line.ENROLLMENT),
	web_link:						line.WEB_LINK,
	country:						line.COUNTRY_SHORT_NAME
	}
)
RETURN count(n);	

LOAD CSV WITH HEADERS from 'file:///RelevanceRank/2-data_files/gov-organizations.csv' as line
CREATE (
	n:organizations:government
	{
	org_id:							line.ORG_ID,
	organization_name:				line.ORGANIZATION_NAME,
	organization_short_name:		line.ORGANIZATION_SHORT_NAME,
	sector_id:						line.SECTOR_ID,
	country:						line.COUNTRY_SHORT_NAME
	}
)
RETURN count(n);