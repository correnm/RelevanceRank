//creating the mission to system relationship

MATCH (a:system), (b:mission)
WHERE a.system_name = b.system AND a.platform_name = b.platform
CREATE (a)<-[:ACCOMPLISHED_BY_SYSTEM]-(b)
return a,b;