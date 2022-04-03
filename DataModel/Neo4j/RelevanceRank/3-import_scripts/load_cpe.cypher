// clear existing data
MATCH (n:cpe) DELETE n;

// Oracle table has 780K records
// jdbc driver must be loaded in the plugins folder for THIS neo4j database installation
call apoc.load.driver('oracle.jdbc.driver.OracleDriver')
CALL apoc.periodic.iterate(
'CALL apoc.load.jdbc("jdbc:oracle:thin:@localhost:1521/XE","select * from cpe",[],{credentials:{user:"research",password:"research"}}) YIELD row',
'CREATE (nc:cpe {cpe_id:row.CPE_ID, title:row.TITLE, part:row.PART, vendor:row.VENDOR, product:row.PRODUCT,version:row.VERSION})',
{batchSize:1000, parallel:true}
)
YIELD batches, total
RETURN batches, total