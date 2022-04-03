//create relationships	
MATCH (n)-[r:KNOWN_ATTACK]->() DELETE r

MATCH (c:cweCapec),(d:capec), (e:cwe)
WHERE c.capec_id = d.capec_id
AND c.cwe_id = e.cwe_id
MERGE (e)-[r:KNOWN_ATTACK]->(d)
RETURN r;