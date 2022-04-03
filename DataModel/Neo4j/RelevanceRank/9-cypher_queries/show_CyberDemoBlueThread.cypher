//shows the blue thread only
MATCH p=(j:configurationItem {ip_address: "10.106.252.23"})-[:COMPRISED_OF]->(k:cpe)-[:SUBSET_OF]->(l:cve)-[:EXPOSES]->(m:relatedCWEs)-[:REFERENCES]->(n:cwe {cwe_id: 'CWE-200', cwe_name: 'Exposure of Sensitive Information to an Unauthorized Actor'})-[:KNOWN_ATTACK]->()
RETURN p;



