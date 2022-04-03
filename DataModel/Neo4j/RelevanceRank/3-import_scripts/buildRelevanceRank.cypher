//script to run each load script necessary to create the full graph for the demo on 9/24

CALL apoc.cypher.runFiles(['3-import_scripts/load_platform.cypher', 
			   '3-import_scripts/load_system.cypher',
			   '3-import_scripts/load_subsystem.cypher',
			   '3-import_scripts/load_baselineArchitectureByCi_DEMO.cypher', 
			   '3-import_scripts/load_cpe.cypher', 
		  	   '3-import_scripts/load_cve.cypher', 
			   '3-import_scripts/load_relatedCWEs.cypher', 
			   '3-import_scripts/load_cwe.cypher', 
			   '3-import_scripts/load_capec.cypher', 
			   '3-import_scripts/load_kisr.cypher', 
			   '3-import_scripts/load_attackFramework.cypher', 
			   '3-import_scripts/load_cci.cypher',
			   '3-import_scripts/load_capec_withTaxonomyMap.cypher']);





