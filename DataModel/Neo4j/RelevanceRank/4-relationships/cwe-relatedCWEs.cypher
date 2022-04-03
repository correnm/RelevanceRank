//create relationships

MATCH (a:cwe),(b:relatedCWEs)
 WHERE a.cwe_id = b.cwe_id
 create (b)-[:REFERENCES]->(a)
 return a,b	
