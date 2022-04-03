   
//from platform to system to subsystem to ci
MATCH p=(a:platform {platform_name: "USS Electra"})-[:COMPOSED_OF]->(b:system)-[:COMPOSED_OF]->(c:subsystem)
MATCH q=(d:subsystem {subsystem_name: "Radar System"})-[:COMPOSED_OF]->(e:configurationItem {ip_address: "10.106.252.23"})
RETURN p,q;