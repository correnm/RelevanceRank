//create relationships from tactics to techniques
MATCH (n)-[r:ACHIEVED_THROUGH]->() DELETE r

MATCH (g:attackEnterpriseTactics),(n:attackTacticTechniques), (t:attackEnterpriseTechniques)
WHERE g.tactic_id = n.tactic_id
and n.technique_id = t.technique_id
MERGE (g)-[r:ACHIEVED_THROUGH]->(t)
RETURN COUNT(r);