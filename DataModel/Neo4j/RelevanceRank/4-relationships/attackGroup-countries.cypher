//create relationships from attack groups to country (origin)
MATCH (n)-[r:ORIGINATES]->() DELETE r

MATCH (x:attackGroups),(n:countries)
WHERE x.group_country = n.country
MERGE (x)-[r:ORIGINATES]->(n)
RETURN COUNT(r);