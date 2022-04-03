//creating the mission to platform relationship

MATCH (a:platform), (b:mission)
WHERE a.platform_name = b.platform
CREATE (a)<-[:ACCOMPLISHED_BY_PLATFORM]-(b)
return a,b;