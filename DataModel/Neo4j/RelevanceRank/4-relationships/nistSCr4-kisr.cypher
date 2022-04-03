//create relationships


MATCH (a:securityControl:nist53r4 {id_number: "AC-3"}),(b:securityRequirement {number: "13"})
CREATE (a)-[r:DERIVED_FROM]->(b)
return a,b;

MATCH (a:securityControl:nist53r4 {id_number: "AC-2"}),(b:securityRequirement {number: "2"})
CREATE (a)-[r:DERIVED_FROM]->(b)
return a,b;

MATCH (a:securityControl:nist53r4 {id_number: "AC-6"}),(b:securityRequirement {number: "17"})
CREATE (a)-[r:DERIVED_FROM]->(b)
return a,b;

MATCH (a:securityControl:nist53r4 {id_number: "AU-2"}),(b:securityRequirement {number: "44"})
CREATE (a)-[r:DERIVED_FROM]->(b)
return a,b;

MATCH (a:securityControl:nist53r4 {id_number: "AU-3"}),(b:securityRequirement {number: "45"})
CREATE (a)-[r:DERIVED_FROM]->(b)
return a,b;

MATCH (a:securityControl:nist53r4 {id_number: "AU-3"}),(b:securityRequirement {number: "46"})
CREATE (a)-[r:DERIVED_FROM]->(b)
return a,b;

MATCH (a:securityControl:nist53r4 {id_number: "SI-11"}),(b:securityRequirement {number: "259"})
CREATE (a)-[r:DERIVED_FROM]->(b)
return a,b;

MATCH (a:securityControl:nist53r4 {id_number: "SI-5"}),(b:securityRequirement {number: "246"})
CREATE (a)-[r:DERIVED_FROM]->(b)
return a,b;

