//create relationships from organizations to country (origin)
MATCH (n)-[r:OPERATES_IN]->() DELETE r

MATCH (x:organizations),(n:countries)
WHERE x.country= n.country
CREATE (x)-[r:OPERATES_IN]->(n)
RETURN COUNT(r);