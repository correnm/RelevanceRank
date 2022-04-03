// NOTE: 'missions' was intentionally left out to avoid  <K,V> complexity

// load data to create nodes
//:AUTO USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS from 'file:///2-data_files/relations.csv' as row
MATCH (p1:configurationItems {element_id:row.source}), (p2:configurationItems {element_id:row.target})
CREATE (p1)-[:ASSOCIATION]->(p2);


