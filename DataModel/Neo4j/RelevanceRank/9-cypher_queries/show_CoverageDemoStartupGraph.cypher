//query to show the full demo for the November TEM

MATCH p=(a:scFamily)-[:FAMILY_OF]->(b:nist53r4 {id_number: "AC-6"})
MATCH q=(c:scFamily)-[:FAMILY_OF]->(d:nist53r4 {id_number: "AC-3"})
MATCH r=(e:scFamily)-[:FAMILY_OF]->(f:nist53r4 {id_number: "AC-2"})
MATCH s=(g:scFamily)-[:FAMILY_OF]->(h:nist53r4 {id_number: "AU-3"})
MATCH t=(i:scFamily)-[:FAMILY_OF]->(j:nist53r4 {id_number: "AU-2"})
MATCH u=(k:scFamily)-[:FAMILY_OF]->(l:nist53r4 {id_number: "SI-5"})
MATCH v=(m:scFamily)-[:FAMILY_OF]->(n:nist53r4 {id_number: "SI-11"})
return p,q,r,s,t,u,v;
