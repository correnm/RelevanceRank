//create relationship from subsystem to securityRequirement

//----------------------NEW STUFF---------------------------//

MATCH (a:subsystem {subsystem_name: "Communications"}),(b:securityRequirement {number: "2"})
CREATE (a)-[r:HAS_REQUIREMENT]->(b)
return a,b;

MATCH (a:subsystem {subsystem_name: "Communications"}),(b:securityRequirement {number: "17"})
CREATE (a)-[r:HAS_REQUIREMENT]->(b)
return a,b;

MATCH (a:subsystem {subsystem_name: "Communications"}),(b:securityRequirement {number: "45"})
CREATE (a)-[r:HAS_REQUIREMENT]->(b)
return a,b;

MATCH (a:subsystem {subsystem_name: "Communications"}),(b:securityRequirement {number: "46"})
CREATE (a)-[r:HAS_REQUIREMENT]->(b)
return a,b;


MATCH (a:subsystem {subsystem_name: "Command and Control"}),(b:securityRequirement {number: "2"})
CREATE (a)-[r:HAS_REQUIREMENT]->(b)
return a,b;

MATCH (a:subsystem {subsystem_name: "Command and Control"}),(b:securityRequirement {number: "13"})
CREATE (a)-[r:HAS_REQUIREMENT]->(b)
return a,b;

MATCH (a:subsystem {subsystem_name: "Command and Control"}),(b:securityRequirement {number: "17"})
CREATE (a)-[r:HAS_REQUIREMENT]->(b)
return a,b;

MATCH (a:subsystem {subsystem_name: "Command and Control"}),(b:securityRequirement {number: "45"})
CREATE (a)-[r:HAS_REQUIREMENT]->(b)
return a,b;

MATCH (a:subsystem {subsystem_name: "Command and Control"}),(b:securityRequirement {number: "46"})
CREATE (a)-[r:HAS_REQUIREMENT]->(b)
return a,b;


MATCH (a:subsystem {subsystem_name: "Radar System"}),(b:securityRequirement {number: "44"})
CREATE (a)-[r:HAS_REQUIREMENT]->(b)
return a,b;

MATCH (a:subsystem {subsystem_name: "Radar System"}),(b:securityRequirement {number: "45"})
CREATE (a)-[r:HAS_REQUIREMENT]->(b)
return a,b;

MATCH (a:subsystem {subsystem_name: "Radar System"}),(b:securityRequirement {number: "46"})
CREATE (a)-[r:HAS_REQUIREMENT]->(b)
return a,b;


MATCH (a:subsystem {subsystem_name: "Display System"}),(b:securityRequirement {number: "246"})
CREATE (a)-[r:HAS_REQUIREMENT]->(b)
return a,b;

MATCH (a:subsystem {subsystem_name: "Display System"}),(b:securityRequirement {number: "259"})
CREATE (a)-[r:HAS_REQUIREMENT]->(b)
return a,b;

//------------This is just here so that the previous demo still works--------------
MATCH (a:subsystem {subsystem_name: "Radar System"}),(b:securityRequirement {number: "2"})
CREATE (a)-[r:HAS_REQUIREMENT]->(b)
return a,b;







