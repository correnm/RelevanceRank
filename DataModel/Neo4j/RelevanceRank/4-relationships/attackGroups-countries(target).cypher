//create relationships from groups to trgeted countries
MATCH (n)-[r:TARGETS]->() DELETE r

MATCH (g:attackGroups),(n:targetCountry), (t:countries)
WHERE g.group_id = n.group_id
and n.country = t.country
MERGE (g)-[r:TARGETS]->(t)
RETURN COUNT(r);