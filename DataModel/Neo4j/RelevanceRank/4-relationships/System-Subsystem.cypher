//create relationships
MATCH (c:system),(d:subsystem)
 WHERE c.platform_name = d.platform_name AND c.system_name = d.system_name
 create (c)-[:COMPOSED_OF]->(d)
 return c,d;	






