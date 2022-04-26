//create relationships from CVE to CPE
MATCH (n)-[r:HAS_VERSION]->() DELETE r

// jdbc driver must be loaded in the plugins folder for THIS neo4j database installation
call apoc.load.driver('oracle.jdbc.driver.OracleDriver')

CALL apoc.periodic.iterate(
'MATCH (x:cpe),(n:software) WHERE x.part = n.part and x.product = n.product and x.vendor=n.vendor RETURN x,n',
'MERGE (n)-[:HAS_VERSION]->(x)',
{batchSize:1000, parallel:true}
)
YIELD batches, total
RETURN batches, total