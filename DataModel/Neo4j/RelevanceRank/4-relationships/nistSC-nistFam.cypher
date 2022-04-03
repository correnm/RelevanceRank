//create relationships


MATCH (a:securityControl),(b:scFamily)
 WHERE a.family = b.family_name AND a.revision = b.revision
 create (a)-[:FAMILY_OF]->(b)
 return a,b