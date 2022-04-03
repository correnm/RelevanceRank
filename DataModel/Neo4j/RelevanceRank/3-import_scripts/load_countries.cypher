// clear existing data
MATCH (n:countries) DETACH DELETE n;

LOAD CSV WITH HEADERS from 'file:///RelevanceRank/2-data_files/countries.csv' as line
CREATE (
	n:countries
	{
		country:			line.SHORT_FORM_NAME,
		country_full_name:	line.LONG_FORM_NAME
	}
)
RETURN count(n);
	
