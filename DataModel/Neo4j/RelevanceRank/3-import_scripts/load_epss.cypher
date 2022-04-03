// clear existing data
MATCH (n:epss) DELETE n;

// Oracle table has 80K records
// jdbc driver must be loaded in the plugins folder for THIS neo4j database installation
call apoc.load.driver('oracle.jdbc.driver.OracleDriver')
CALL apoc.periodic.iterate(
'CALL apoc.load.jdbc("jdbc:oracle:thin:@localhost:1521/XE","select * from epss",[],{credentials:{user:"research",password:"research"}}) YIELD row',
'CREATE (e:epss {cve_id:row.CVE_ID, epss_score:row.EPSS_SCORE, epss_percentile:row.PERCENTILE})',
{batchSize:1000, parallel:true}
)
YIELD batches, total
RETURN batches, total