##PAGE RANK

##Create graph projection

CALL gds.graph.create('Columbia2', 'configurationItems', {
  ASSOCIATION: {
    orientation: 'UNDIRECTED'
  }
})

##Run Page Rank on nodes
##measures the transitive influence and connectivity of nodes to find the most influential nodes in a graph.
##It computes an influence value for each node, called a score. As a result, the score of a node is a certain weighted average of the scores of its direct neighbors.

CALL gds.pageRank.stream('Columbia2') YIELD nodeId, score
RETURN gds.util.asNode(nodeId).name AS name, score
ORDER BY score DESC LIMIT 10


##Compare each node with the number of interactions for that node
##
CALL gds.pageRank.stream('Columbia2') YIELD nodeId, score AS pageRank
WITH gds.util.asNode(nodeId) AS n, pageRank
MATCH (n)-[i:ASSOCIATION]-()
RETURN n.element_id AS name, pageRank, count(i) AS interactions
ORDER BY pageRank DESC LIMIT 10

## Write property to file

CALL gds.pageRank.write('Columbia', {writeProperty: 'pageRank'})


##2) Label Propogation

CALL gds.graph.create(
  'Columbia2-LGA',
  'configurationItems',
  {
    ASSOCIATION: {
      orientation: 'UNDIRECTED'
    }
  }
)


CALL gds.labelPropagation.stream(
  'Columbia2-LGA',
  {
    maxIterations: 1
  }
) YIELD nodeId, communityId
RETURN communityId, count(nodeId) AS size
ORDER BY size DESC
LIMIT 5


##Betweeness Centrality
##Betweenness Centrality is a way of detecting the amount of influence a node has over the flow of information in a graph. It is often used to find nodes that serve as a bridge from one part of a graph to another.g

##How Betweenness Centrality works

##The algorithm calculates unweighted shortest paths between all pairs of nodes in a graph. Each node receives a score, based on the number of shortest paths that pass through the node. Nodes that more frequently lie on shortest paths between other nodes will have higher betweenness centrality scores.

CALL gds.betweenness.stream('Columbia2') YIELD nodeId, score
RETURN gds.util.asNode(nodeId).element_id AS ID, score
ORDER BY score DESC LIMIT 10

CALL gds.betweenness.stats('Columbia2')
YIELD centralityDistribution