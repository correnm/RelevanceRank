//create relationships


MATCH (a:securityControl:nist53r4),(b:cci)
WHERE b.cci_references CONTAINS a.id_number
CREATE (a)-[:SATISFIES]->(b)
return a,b;