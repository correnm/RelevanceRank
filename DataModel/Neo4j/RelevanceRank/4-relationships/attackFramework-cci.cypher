//create relationships
//from ACF(security control)->CCI

MATCH (a:attackFramework),(b:cci)
 WHERE b.cci_references CONTAINS a.control_id
 CREATE (a)-[:MAPS_TO]->(b)
 return b,a;




