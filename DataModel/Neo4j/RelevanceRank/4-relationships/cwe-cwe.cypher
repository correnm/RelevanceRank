//create relationships 
MATCH (n)-[r:RELATES_TO]->() DELETE r

// create a UNARY relationship
// NATURE of the relationship can be Requires, ChildOf, CanAlsoBe, PeerOf, CanPrecede, or null
// add nature as a key:value pair on the relationship
MATCH (a:cwe)
MATCH (rc:cwe), (b:cweRelatedCwe) 
WHERE rc.cwe_id = b.related_cwe_id 
AND a.cwe_id = b.cwe_id
CREATE (a)-[r:RELATES_TO {nature:b.nature}]->(rc)
return r;