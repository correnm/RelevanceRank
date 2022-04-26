//create relationships from CVE to CPE
MATCH (n)-[r:INSTALLS]->() DELETE r

// jdbc driver must be loaded in the plugins folder for THIS neo4j database installation
call apoc.load.driver('oracle.jdbc.driver.OracleDriver')

CALL apoc.periodic.iterate(
'MATCH (x:organizations),(n:orgSoftware), (c:software) WHERE x.org_id = n.org_id and n.software_id = c.software_id RETURN x,c',
'MERGE (x)-[:INSTALLS]->(c)',
{batchSize:1000, parallel:true}
)
YIELD batches, total
RETURN batches, total