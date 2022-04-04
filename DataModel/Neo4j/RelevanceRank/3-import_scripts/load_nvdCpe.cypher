// clear existing data
CALL apoc.periodic.iterate('MATCH (n:nvdCpe) RETURN n', 'DETACH DELETE n', {batchSize:1000})

// Oracle table has 630K records
// jdbc driver must be loaded in the plugins folder for THIS neo4j database installation
call apoc.load.driver('oracle.jdbc.driver.OracleDriver')
CALL apoc.periodic.iterate(
'CALL apoc.load.jdbc("jdbc:oracle:thin:@localhost:1521/XE","select * from nvd_cpe",[],{credentials:{user:"research",password:"research"}}) YIELD row',
'CREATE (nc:nvdCpe {cve_id:row.CVE_ID, cpe_id:row.CPE23URI, vulnerable:row.VULNERABLE, part:row.PART, vendor:row.VENDOR, product:row.PRODUCT,version:row.VERSION})',
{batchSize:1000, parallel:true}
)
YIELD batches, total
RETURN batches, total