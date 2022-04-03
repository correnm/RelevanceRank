// jdbc driver must be loaded in the plugins folder for THIS neo4j database installation
call apoc.load.driver('oracle.jdbc.driver.OracleDriver')

CALL apoc.periodic.iterate(
'MATCH (x:nvdCve),(e:epss) WHERE x.cve_id = e.cve_id RETURN x,e',
'SET x.epss_score = apoc.number.parseFloat(e.epss_score), x.epss_percentile= apoc.number.parseFloat(e.epss_percentile)',
{batchSize:1000, parallel:true}
)
YIELD batches, total
RETURN batches, total