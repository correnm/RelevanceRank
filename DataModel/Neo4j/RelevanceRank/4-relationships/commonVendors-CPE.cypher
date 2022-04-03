//create relationships with a unique type name (e.g., :REFERENCES)

MATCH (a:commonVendors),(b:commonPlatforms)
 WHERE a.vendor = b.vendor
 create (b)-[:MANUFACTURES]->(a)
 return a,b	
