//create relationships
MATCH (a:platform),(b:system)
 WHERE a.platform_name = b.platform_name
 CREATE (a)-[:COMPOSED_OF]->(b)
 return a,b;

MERGE (s:system) WITH s.system_name as name, collect(s) as nodes CALL apoc.refactor.mergeNodes(nodes) yield node RETURN*;



