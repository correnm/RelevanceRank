//query to show the full demo for the November TEM

MATCH p=(a:subsystem)-[:HAS_REQUIREMENT]->(b:securityRequirement)
MATCH q=(c:securityRequirement)<-[:DERIVED_FROM]-(d:nist53r4)<-[:FAMILY_OF]-(e:scFamily)
MATCH r=(f:nist53r4)-[:SATISFIES]->(g:cci)
return p,q,r;
