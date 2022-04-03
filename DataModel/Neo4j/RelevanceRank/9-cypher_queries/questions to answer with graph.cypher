//-----Queries that I came up with to test mission data-----
//shows the number of missions attached to each subsystems in a table format
MATCH q=(s:subsystem)-[*1]-(m:mission)
RETURN s.subsystem_name as Subsystem, count(DISTINCT m) AS Missions
ORDER BY Missions DESC

//show any subsystem that is connected to a mission visually
MATCH q=(s:subsystem)-[*1]-(m:mission) RETURN q;

//shows the number of subsystems attached to a mission in a table format
MATCH q=(s:subsystem)-[*1]-(m:mission)
RETURN m.mission_name as Mission, count(DISTINCT s) AS Subsystems
ORDER BY Subsystems DESC


//-----Queries/Questions to test new architecture layout in Neo4j
//show a visual of full CI cyber data
//show a table of CI cyber data with columns being... ConfigurationItem (String) | Vulnerability Count (int) | Vulnerability Names (String[]) | CAPEC Count (int)
//show a visual of an isolated CI or two 
//show a table of isolated CI cyber data with columns being... ConfigurationIem (String)


//Charles's Queries he wanted me to test

//-----Level 1 cyphers-----

//---What missions are impacted if a certain subsystem were to fail?
MATCH(s:subsystem)-[*1]-(m:mission)
RETURN s.subsystem_name as Subsystem, collect(m.mission_name) as Mission;

//---What subsystems are shared accross missions?
MATCH(s:subsystem)-[*1]-(m:mission)
RETURN collect(DISTINCT m.mission_name) as Mission, s.subsystem_name as Subsystem;

//---What security control families are shared accross subsystems
MATCH(s:subsystem)-[*3]-(f:nistFams)
RETURN collect(DISTINCT s.subsystem_name) as Subsystem, f.family_name as Family;


//-----Level 2 Queries-----

//---page rank on most important/connected node
CALL gds.graph.create('Missions', ['mission','subsystem'], {
ACCOMPLISHED_BY_SUBSYSTEM: { orientation: 'UNDIRECTED'}
})

CALL gds.pageRank.stream('Missions') YIELD nodeId, score
WHERE gds.util.asNode(nodeId).mission_name IS NOT NULL
RETURN gds.util.asNode(nodeId).mission_name AS mission_name, score
ORDER BY score DESC LIMIT 10

//---page rank on mission/subsystem nodes accounting for relationship weights
CALL gds.graph.create('Missions',['mission','subsystem'],{ACCOMPLISHED_BY_SUBSYSTEM: { orientation: 'UNDIRECTED'}},{relationshipProperties: 'weight'});


CALL gds.pageRank.stream('Missions',{relationshipWeightProperty: 'weight'}) YIELD nodeId, score
WHERE gds.util.asNode(nodeId).mission_name IS NOT NULL
RETURN gds.util.asNode(nodeId).mission_name AS mission_name, score
ORDER BY score DESC LIMIT 10;




