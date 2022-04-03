//create relationships

MATCH (a:commonWeaknesses),(b:commonAttackPatterns)
 WHERE a.cwe_id = b.cwe_id
 create (a)-[:KNOWN_ATTACK]->(b)
 return a,b	
