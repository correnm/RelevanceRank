//script to run each load script necessary to create the full graph for the demo on 9/24

CALL apoc.cypher.runFiles(['4-relationships/system-subsystem.cypher',
			   '4-relationships/subsystem-mission.cypher']);

MERGE (m:mission) WITH m.mission_name as name, collect(m) as nodes CALL apoc.refactor.mergeNodes(nodes) yield node RETURN*;



