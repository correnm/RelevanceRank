/*
uniqueness constraints implicitly create indexes

Modification History:

Date                 Author             Change
03.20.2022          corren.mccoy       created
*/

CREATE CONSTRAINT cons_aetactics_nk  IF NOT EXISTS ON (node:attackEnterpriseTactics) 
ASSERT (node.tactic_id) IS NODE KEY;
//
CREATE CONSTRAINT cons_aetechniques_nk  IF NOT EXISTS ON (node:attackEnterpriseTechniques) 
ASSERT (node.technique_id) IS NODE KEY;
//
CREATE CONSTRAINT cons_attackGroups_nk  IF NOT EXISTS ON (node:attackGroups) 
ASSERT (node.group_id) IS NODE KEY;
//
CREATE CONSTRAINT cons_capec_nk  IF NOT EXISTS ON (node:capec) 
ASSERT (node.capec_id) IS NODE KEY;
//
CREATE CONSTRAINT cons_cwe_nk  IF NOT EXISTS ON (node:cwe) 
ASSERT (node.cwe_id) IS NODE KEY;
//
CREATE CONSTRAINT cons_cpe_nk  IF NOT EXISTS ON (node:cpe) 
ASSERT (node.cpe_id) IS NODE KEY;
/
CREATE CONSTRAINT cons_cisaExploitCatalog_nk  IF NOT EXISTS ON (node:cisaExploitCatalog) 
ASSERT (node.cve_id) IS NODE KEY;
//
CREATE CONSTRAINT cons_dhsSector_nk  IF NOT EXISTS ON (node:dhsSectors) 
ASSERT (node.sector_id) IS NODE KEY;
//
CREATE CONSTRAINT cons_exploitDb_nk  IF NOT EXISTS ON (node:exploitDb) 
ASSERT (node.edb_id, node.cve_id) IS NODE KEY;
//
CREATE CONSTRAINT cons_nvdCve_nk  IF NOT EXISTS ON (node:nvdCve) 
ASSERT (node.cve_id) IS NODE KEY;
//
CREATE CONSTRAINT cons_nvdCwe_nk  IF NOT EXISTS ON (node:nvdCwe) 
ASSERT (node.cve_id, node.cwe_id) IS NODE KEY;
//
CREATE CONSTRAINT cons_nvdReferences_nk  IF NOT EXISTS ON (node:nvdReferences) 
ASSERT (node.cve_id, node.url, node.name, node.tag) IS NODE KEY;
//