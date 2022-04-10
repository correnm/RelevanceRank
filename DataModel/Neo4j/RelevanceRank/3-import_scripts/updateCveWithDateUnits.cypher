// jdbc driver must be loaded in the plugins folder for THIS neo4j database installation
call apoc.load.driver('oracle.jdbc.driver.OracleDriver')

CALL apoc.periodic.iterate(
'MATCH (x:nvdCve) RETURN x',
'SET x.cve_month=apoc.date.fields(toString(x.modified_date),"YYYY-MM-dd\'T\'HH:mm:ssz").months, x.cve_day=apoc.date.fields(toString(x.modified_date),"YYYY-MM-dd\'T\'HH:mm:ssz").days',
{batchSize:1000, parallel:true}
)
YIELD batches, total, errorMessages
RETURN batches, total, errorMessages