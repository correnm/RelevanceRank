//create relationships from groups to techniques
MATCH (n)-[r:FOCUS_ON]->() DELETE r

MATCH (g:attackGroups),(n:attackGroupSectors), (t:dhsSectors)
WHERE g.group_id = n.group_id
and n.sector_id = t.sector_id
MERGE (g)-[r:FOCUS_ON]->(t)
RETURN COUNT(r);