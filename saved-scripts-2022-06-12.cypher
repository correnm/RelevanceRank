// Map Threat Groups Network Attack to Vulns and Exploits and Sectors
MATCH (n:nvdCve {attack_vector:"NETWORK"} )-[w:WEAKENED_BY]-(c:cwe)-[k:KNOWN_ATTACK]-(ca:capec)-[e:EMPLOYS]-(a:attackEnterpriseTechniques)-[r:ACHIEVES_GOAL]-(ag:attackGroups)-[o:ORIGINATES]-(co:countries {country:"China"})
WHERE n.cve_year=2021
OPTIONAL MATCH (ag:attackGroups)-[t:TARGETS]-(co2:countries) 
OPTIONAL MATCH (n:nvdCve)-[re:REFERENCE_EXPLOITS]-(edb:exploitDb)
OPTIONAL MATCH (n:nvdCve)-[ex:EXPLOITS_KNOWN]-(cec:cisaExploitCatalog)
OPTIONAL MATCH (ag:attackGroups)-[fo:FOCUS_ON]-(dhs:dhsSectors)
RETURN * 
LIMIT 10000