//create relationships from groups to techniques
MATCH (n)-[r:ACHIEVES_GOAL]->() DELETE r

MATCH (g:attackGroups),(n:attackGroupTechniques), (t:attackEnterpriseTechniques)
WHERE g.group_id = n.group_id
and n.technique_id = t.technique_id
MERGE (g)-[r:ACHIEVES_GOAL]->(t)
RETURN COUNT(r);