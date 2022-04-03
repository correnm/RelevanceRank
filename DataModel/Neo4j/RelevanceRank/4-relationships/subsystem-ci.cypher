//create relationships
MATCH (a:subsystem )//{subsystem_name: "Radar System"})
MATCH (b:configurationItem) //{ip_address: "10.106.252.23"})
WHERE a.subsystem_name = b.subsystem
 CREATE (a)-[:COMPOSED_OF]->(b)
 return a,b;
 
 





