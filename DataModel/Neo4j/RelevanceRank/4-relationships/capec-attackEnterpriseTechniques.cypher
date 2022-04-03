//create relationships from CVE to weaknessess
MATCH (n)-[r:EMPLOYS]->() DELETE r

MATCH (x:capec),(n:attackEnterpriseTechniques), (c:capecTaxonomy)
WHERE x.capec_id = c.capec_id
and n.technique_id = c.technique_id
MERGE (n)-[:EMPLOYS]->(x)
RETURN COUNT(c);