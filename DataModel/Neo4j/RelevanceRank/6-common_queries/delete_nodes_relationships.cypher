//delete all nodes and relationships
//Reference: https://aura.support.neo4j.com/hc/en-us/articles/360059882854-Using-APOC-periodic-iterate-to-delete-large-numbers-of-nodes
//SOLUTION: Build lists of IDs (nodes and/or relationships)

call apoc.periodic.iterate(
"MATCH (p) return id(p) AS id", 
"MATCH (n) WHERE id(n) = id DETACH DELETE n", 
{batchSize:1000})