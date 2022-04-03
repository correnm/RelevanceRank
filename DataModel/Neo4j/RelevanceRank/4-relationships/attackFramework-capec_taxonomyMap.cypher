//create relationships
//from ACF->CAP

MATCH (a:attackFramework),(b:capec_taxonomyMap) 
 WHERE substring(a.technique_id, 1) = apoc.map.get(apoc.convert.fromJsonMap(b.taxonomy_mapping), 'technique_id') 
 CREATE (a)-[:MITIGATES]->(b)
 return a,b;



