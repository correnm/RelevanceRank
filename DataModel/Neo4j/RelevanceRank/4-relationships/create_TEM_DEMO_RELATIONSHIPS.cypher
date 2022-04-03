//script to run each load script necessary to create the full graph for the demo on 9/24

CALL apoc.cypher.runFiles(['4-relationships/platform-system.cypher',
			   '4-relationships/system-subsystem.cypher',
			   '4-relationships/subsystem-ci.cypher',
			   '4-relationships/cpe-ci.cypher',
			   '4-relationships/cve-cpe.cypher',
			   '4-relationships/cve-relatedCWEs.cypher',
			   '4-relationships/cwe-relatedCWEs.cypher',
			   '4-relationships/cwe-capec.cypher',
			   '4-relationships/subsystem-kisr.cypher',
			   '4-relationships/kisr-attackFramework.cypher',
			   '4-relationships/attackFramework-cci.cypher',
			   '4-relationships/attackFramework-capec_taxonomyMap.cypher',
			   '4-relationships/cwe-capec_taxonomyMap.cypher',
			   '4-relationships/nistSCr4-kisr.cypher',
			   '4-relationships/nistSCr4-nistFam.cypher',
			   '4-relationships/nistSCr4-cci.cypher']);



