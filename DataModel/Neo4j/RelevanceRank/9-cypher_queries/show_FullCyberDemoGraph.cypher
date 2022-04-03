   
//from platform to system to subsystem to ci
MATCH p=(a:platform {platform_name: "USS Electra"})-[:COMPOSED_OF]->(b:system)-[:COMPOSED_OF]->(c:subsystem)
MATCH q=(d:subsystem {subsystem_name: "Radar System"})-[:COMPOSED_OF]->(e:configurationItem {ip_address: "10.106.252.23", platform: 'USS Electra'})
MATCH r=(f:configurationItem {ip_address: "10.106.252.23"})-[:COMPRISED_OF]->(g:cpe)-[:SUBSET_OF]->(h:cve)-[:EXPOSES]->(i:relatedCWEs)-[:REFERENCES]->(j:cwe {cwe_id: 'CWE-200'})-[:KNOWN_ATTACK]->()
MATCH s=(k:subsystem {subsystem_name: "Radar System"})-[:HAS_REQUIREMENT]->(l:securityRequirement {number: "2"})-[:RELATED_CONTROL]->(m:attackFramework)-[:MAPS_TO|:MITIGATES]->()

RETURN p,q,r,s;