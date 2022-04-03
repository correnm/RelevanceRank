//create relationships with a unique type name (e.g., :REFERENCES)
// 08.22.2021   corren.mccoy    corrected directionality - a Vendor manufactures a Product

MATCH (a:vendors),(b:cpe)
 WHERE a.vendor_name = b.vendor
 create (a)-[:MANUFACTURES]->(b)
 return a,b	
