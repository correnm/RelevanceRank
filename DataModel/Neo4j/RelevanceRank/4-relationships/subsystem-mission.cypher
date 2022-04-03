//creating the mission to subsystem relationship

MATCH (a:subsystem), (b:mission)
WHERE a.subsystem_name = b.subsystem AND a.system_name = b.system AND a.platform_name = b.platform
CREATE (a)<-[:ACCOMPLISHED_BY_SUBSYSTEM {weight: b.node_weight}]-(b)
return a,b;


MERGE (m:mission) WITH m.mission_name as name, collect(m) as nodes CALL apoc.refactor.mergeNodes(nodes) yield node RETURN*;

