//script to run each load script necessary to create the full graph for the demo on 9/24

CALL apoc.cypher.runFiles(['4-relationships/subsystem-kisr.cypher',
			   '4-relationships/nistSCr4-kisr.cypher',
			   '4-relationships/nistSCr4-nistFam.cypher',
			   '4-relationships/nistSCr4-cci.cypher']);

