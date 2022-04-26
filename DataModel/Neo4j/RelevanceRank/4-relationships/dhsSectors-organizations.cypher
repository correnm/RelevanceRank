//create relationships from groups to techniques
MATCH (n)-[r:AFFILIATED_WITH]->() DELETE r

MATCH (o:organizations), (t:dhsSectors)
WHERE o.sector_id = t.sector_id
MERGE (o)-[r:AFFILIATED_WITH]->(t)
RETURN COUNT(r);