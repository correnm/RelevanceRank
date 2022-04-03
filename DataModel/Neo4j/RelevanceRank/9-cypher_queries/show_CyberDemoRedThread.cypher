//shows the red thread only
MATCH p=(x:subsystem {subsystem_name: "Radar System"})-[:HAS_REQUIREMENT]->(a:securityRequirement {number: "2"})-[:RELATED_CONTROL]->(b:attackFramework)-[:MAPS_TO|:MITIGATES]->()
RETURN p;


