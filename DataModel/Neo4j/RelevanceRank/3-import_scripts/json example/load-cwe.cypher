// https://cwe.mitre.org/data/downloads.html
// https://cwe.mitre.org/data/csv/1000.csv.zip
LOAD CSV FROM "file:///1000.csv" as  list

MERGE(cwe:CWE {name: 'CWE-' + apoc.convert.toString(list[0])})
SET cwe.title = list[1],
    cwe.abstraction = list[2],
    cwe.status = list[3],
    cwe.description = list[4],
    cwe.functional_areas = list[18],
    cwe.affected_resources = list[19]

;
