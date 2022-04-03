// change directory and file name relative to the import directory
CALL apoc.cypher.runFile('///3-import_scripts/load_xxx.cypher', {statistics: true})