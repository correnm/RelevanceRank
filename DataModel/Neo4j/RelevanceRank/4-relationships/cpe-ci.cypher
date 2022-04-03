//create relationships

MATCH (a:cpe),(b:configurationItem)
 WHERE b.sw_cpe_id CONTAINS a.cpe_id
 create (b)-[:COMPRISED_OF]->(a)
 return a,b