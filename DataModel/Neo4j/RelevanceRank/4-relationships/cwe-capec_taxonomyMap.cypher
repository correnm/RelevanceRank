//create relationships

MATCH (a:cwe),(b:capec_taxonomyMap)
 WHERE a.cwe_id = b.cwe_id
 CREATE (a)-[:KNOWN_ATTACK]->(b);	
