//create relationships 
MATCH (n)-[r:WEAKENED_BY]->() DELETE r

MATCH (a:cwe),(b:nvdCwe)
 WHERE a.cwe_id = b.cwe_id
 create (a)-[:WEAKENED_BY]->(b)
 return a,b	
