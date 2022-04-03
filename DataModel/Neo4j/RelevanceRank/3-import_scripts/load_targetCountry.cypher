//template for the targetCountry node that will be implemented eventually
// clear existing data
MATCH (n:targetCountry) DETACH DELETE n;

LOAD CSV WITH HEADERS from 'file:///RelevanceRank/2-data_files/attackGroupTargetCountries.csv' as line
CREATE (
	n:targetCountry
	{
		group_id:			line.GROUP_ID,
		country:			line.SHORT_FORM_NAME
	}
) RETURN COUNT(n);
	
