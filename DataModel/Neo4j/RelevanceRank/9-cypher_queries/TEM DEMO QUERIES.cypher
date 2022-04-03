//Cyber Info Graph
// [Done] = done


//-----Queries/Questions to test new architecture layout in Neo4j



//show a visual of full CI cyber data
MATCH x=(:platform)-[*5]-(b:cve)-[*3]-(a:capec)
WHERE (a.capec_name = "Privilege Abuse" OR a.capec_name = "Privilege Escalation" OR a.capec_name = "Restful Privilege Elevation" OR a.capec_name = "Port Scanning" OR a.capec_name = "TCP Window Scan" OR a.capec_name = "File Discovery") AND (b.cve_id <> "CVE-2020-16900" AND b.cve_id <> "CVE-2020-1437" AND b.cve_id <> "CVE-2020-17036") 
RETURN x;

//show a table of CI cyber data with columns being... ConfigurationItem (String) | Vulnerability Count (int) | Vulnerability Names (String[]) | CAPEC Count (int)
MATCH x=(:platform)-[*3]-(a:configurationItem)-[*2]-(b:cve)-[*3]-(c:capec)
RETURN a.element_name as Configuration_Items, COUNT(DISTINCT c) AS Count_of_CAPECs, COUNT(DISTINCT b) AS Count_of_Vulnerabilities, COLLECT(DISTINCT b.cve_id) AS Vulnerabilities;

//show a visual of an isolated CI mapped toa  control that mitigates a capec
MATCH x=(:platform)-[*3]-(:configurationItem {element_name: "CI 7"})-[*2]-(:cve)-[*3]-(:capec_taxonomyMap {capec_name: "Reusing Session IDs (aka Session Replay)"})
MATCH y=(:subsystem {subsystem_name: "Radar System"})-[*2]-(:attackFramework)-[]-(:capec_taxonomyMap)
RETURN x, y;


//show a table of isolated CI cyber data with columns being... ConfigurationIem (String) | Vulnerability Count (int) | Vulnerability Names (String[]) | CAPEC Count
MATCH x=(:platform)-[*3]-(a:configurationItem {element_name: "CI 7"})-[*2]-(b:cve)-[*3]-(c:capec_taxonomyMap {capec_name: "Reusing Session IDs (aka Session Replay)"})
MATCH y=(:subsystem {subsystem_name: "Radar System"})-[*2]-(:attackFramework)-[]-(:capec_taxonomyMap)
RETURN a.element_name as Configuration_Item, c.capec_name AS CAPEC, COUNT(DISTINCT b) AS Count_of_Vulnerabilities, COLLECT(DISTINCT b.cve_id) AS Vulnerabilities;




//show a visual of full coverage data
MATCH p=(a:subsystem)-[:HAS_REQUIREMENT]->(b:securityRequirement)
MATCH q=(c:securityRequirement)<-[:DERIVED_FROM]-(d:nist53r4)<-[:FAMILY_OF]-(e:scFamily)
MATCH r=(f:nist53r4)-[:SATISFIES]->(g:cci)
RETURN p,q,r;

//show a table of full cyber data with columns being... SecurityControlFamily (String) | Subsystems (String[])
MATCH p=(a:subsystem)-[:HAS_REQUIREMENT]->(b:securityRequirement)
MATCH q=(c:securityRequirement)<-[:DERIVED_FROM]-(d:nist53r4)<-[:FAMILY_OF]-(e:scFamily)
MATCH r=(f:nist53r4)-[:SATISFIES]->(g:cci)
RETURN e.family_name AS Security_Control_Family, COUNT(DISTINCT a) AS Count_of_Subsystems, COLLECT(DISTINCT a.subsystem_name) AS Subsystems;

//show a visual of an isolated security control family
MATCH x=(e:scFamily {family_name: "Access Control"})-[*3]-(a:subsystem)
RETURN x;

//show a table of an isolated security control family data with columns being... SecurityControlFamily (String) | Subsystem (String[])
MATCH x=(e:scFamily {family_name: "Access Control"})-[*3]-(a:subsystem)
RETURN e.family_name AS Security_Control_Family, COUNT(DISTINCT a) AS Count_of_Subsystems, COLLECT(DISTINCT a.subsystem_name) AS Subsystems;