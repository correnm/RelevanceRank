//create relationships
//from KISR->ACF

MATCH (a:securityRequirement),(b:attackFramework)
 WHERE a.number = '2' AND b.control_id = 'AC-2'
 CREATE (a)-[:RELATED_CONTROL]->(b)
 return b,a;




