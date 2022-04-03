//create relationship from subsystem to securityControl:nist53r4

MATCH (a:subsystem {subsystem_name: "Command and Control"}),(b:securityControl:nist53r4 {id_number: "AC-2"})
CREATE (a)-[r:HAS_CONTROL]->(b)
return a,b;

MATCH (a:subsystem {subsystem_name: "Communications"}),(b:securityControl:nist53r4 {id_number: "AC-2"})
CREATE (a)-[r:HAS_CONTROL]->(b)
return a,b;

MATCH (a:subsystem {subsystem_name: "Radar System"}),(b:securityControl:nist53r4 {id_number: "AC-6"})
CREATE (a)-[r:HAS_CONTROL]->(b)
return a,b;

MATCH (a:subsystem {subsystem_name: "Display System"}),(b:securityControl:nist53r4 {id_number: "AC-2"})
CREATE (a)-[r:HAS_CONTROL]->(b)
return a,b;

MATCH (a:subsystem {subsystem_name: "Display System"}),(b:securityControl:nist53r4 {id_number: "AC-6"})
CREATE (a)-[r:HAS_CONTROL]->(b)
return a,b;

MATCH (a:subsystem {subsystem_name: "Command and Control"}),(b:securityControl:nist53r4 {id_number: "AC-3"})
CREATE (a)-[r:HAS_CONTROL]->(b)
return a,b;



