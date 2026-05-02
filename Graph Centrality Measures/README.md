# Graph Centrality Measures

This repository contains a mathematical and computational study of centrality
measures in graphs. The main focus is not software engineering, but the use of
linear algebra, matrix functions, shortest-path structure, and random graph
models to identify important vertices in a network.

The project was prepared as part of the course Matrix and Tensor Methods in Data
Analysis. The full write-up is available in
[`Final paper/GraphCentralityMeasures.pdf`](Final%20paper/GraphCentralityMeasures.pdf).

## Mathematical Motivation

A graph can be represented by its adjacency matrix

$$A \in \mathbb{R}^{n \times n},$$

where `A(i, j)` records whether there is an edge from vertex `i` to vertex `j`.
Once the graph is represented as a matrix, centrality can be studied through
matrix-vector products, eigenvectors, matrix inverses, matrix exponentials, and
shortest-path distances.

The central question is how to rank vertices by importance. Different centrality
measures encode different notions of importance:

1. **Local connectivity**, measured by degree.
2. **Geometric proximity**, measured by closeness.
3. **Influence through important neighbors**, measured by eigenvector and Katz
   centrality.
4. **Participation in walks**, measured by exponential, resolvent, and total
   communicability centralities.
5. **Control of shortest paths**, measured by betweenness centrality.

The code implements these centrality measures and compares them on generated
graphs and graph data.

## Degree Centrality

Degree centrality is the simplest centrality measure. For an undirected graph,
the degree of vertex `i` is

$$c_D(i) = \sum_{j=1}^n A_{ij}.$$

For directed graphs, one can distinguish out-degree and in-degree:

$$c_D^{out}(i) = \sum_{j=1}^n A_{ij}, \qquad
c_D^{in}(i) = \sum_{j=1}^n A_{ji}.$$

This measure is purely local: it counts the number of immediate neighbors of a
vertex, but does not account for the importance of those neighbors or the
position of the vertex in the whole graph.

## Closeness Centrality

Closeness centrality measures how near a vertex is to all other vertices in the
graph. If `d(i, j)` is the shortest-path distance between vertices `i` and `j`,
then

$$c_C(i) = \frac{n - 1}{\sum_{j=1}^n d(i, j)}.$$

A vertex has high closeness centrality if it can reach the rest of the graph
through short paths. In the implementation, unreachable vertices are assigned a
large finite distance so that disconnected graphs can still be ranked.

## Eigenvector Centrality

Degree centrality treats every neighbor equally. Eigenvector centrality instead
gives a vertex a high score when it is connected to other high-scoring vertices.
It is defined by the eigenvalue equation

$$A x = \lambda x,$$

where the centrality score of vertex `i` is the `i`-th component of the dominant
eigenvector:

$$c_E(i) = |x_i|.$$

This creates a recursive notion of importance: a vertex is important if it is
connected to important vertices.

## Katz Centrality

Katz centrality extends eigenvector centrality by counting walks of all lengths,
while damping longer walks by a factor `alpha`. It can be written as

$$c_K = \sum_{k=0}^{\infty} \alpha^k A^k \mathbf{1}.$$

When the series converges, this is equivalent to

$$c_K = (I - \alpha A)^{-1}\mathbf{1}.$$

The convergence condition is

$$0 < \alpha < \frac{1}{\rho(A)},$$

where `rho(A)` is the spectral radius of `A`. The repository contains both a
direct linear-system version, `KatzCent.m`, and an iterative version,
`KatzCent_2.m`.

## Subgraph Centrality

Subgraph centrality measures how strongly a vertex participates in closed walks.
The exponential version uses the matrix exponential

$$e^{\beta A} =
\sum_{k=0}^{\infty} \frac{\beta^k A^k}{k!}.$$

The exponential subgraph centrality of vertex `i` is the diagonal entry

$$c_{ES}(i) = \left(e^{\beta A}\right)_{ii}.$$

The parameter `beta > 0` controls the weight assigned to longer walks. The file
`ExpSubgraphCent.m` uses MATLAB's `expm`, while `ExpSubgraphCent_2.m` uses the
included `fastExpm.m` helper.

The resolvent version uses

$$c_{RS}(i) =
\left((I - \alpha A)^{-1}\right)_{ii}
= \sum_{k=0}^{\infty} \alpha^k (A^k)_{ii},$$

again with

$$0 < \alpha < \frac{1}{\rho(A)}.$$

## Total Communicability

Total communicability centrality measures how much a vertex communicates with
all vertices through walks of every length:

$$c_{TC} = e^{\beta A}\mathbf{1}.$$

Thus the score of vertex `i` is

$$c_{TC}(i) = \sum_{j=1}^n \left(e^{\beta A}\right)_{ij}.$$

Unlike exponential subgraph centrality, which uses only diagonal entries, total
communicability uses full row sums of the matrix exponential.

## Betweenness Centrality

Betweenness centrality measures how often a vertex lies on shortest paths
between other pairs of vertices. If `sigma_st` is the number of shortest paths
from vertex `s` to vertex `t`, and `sigma_st(v)` is the number of such paths that
pass through vertex `v`, then

$$c_B(v) =
\sum_{\substack{s \neq v \neq t \\ s \neq t}}
\frac{\sigma_{st}(v)}{\sigma_{st}}.$$

A vertex with high betweenness can be interpreted as a bridge between different
parts of the graph.

## Random Graph Models

The repository also includes three graph generation models.

**Erdos-Renyi model.** In `G(n, p)`, each possible edge appears independently
with probability `p`.

$$P((i, j) \in E) = p.$$

**Watts-Strogatz model.** The graph begins as a ring lattice where every vertex
is connected to `k` nearby vertices. Edges are then rewired with probability `p`,
which introduces shortcuts and produces small-world behavior.

**Barabasi-Albert model.** The graph grows one vertex at a time. Each new vertex
connects to `m` existing vertices with probability proportional to their current
degree:

$$P(i) = \frac{d_i}{\sum_j d_j}.$$

This preferential attachment mechanism tends to produce graphs with a few highly
connected hubs.

## Repository Structure

```text
.
+-- Code/
|   +-- Centralities/
|   |   +-- main.m                         # example script comparing measures
|   |   +-- DegreeCent.m                   # degree centrality
|   |   +-- ClosenessCent.m                # closeness centrality
|   |   +-- EigenValueCent.m               # eigenvector centrality
|   |   +-- KatzCent.m                     # Katz centrality by linear solve
|   |   +-- KatzCent_2.m                   # iterative Katz centrality
|   |   +-- ExpSubgraphCent.m              # exponential subgraph centrality
|   |   +-- ExpSubgraphCent_2.m            # fast exponential version
|   |   +-- ResSubgraphCent.m              # resolvent subgraph centrality
|   |   +-- TotalCommunicabilityCent.m     # total communicability centrality
|   |   +-- BetweennessCent.m              # betweenness centrality
|   |   +-- fastExpm.m                     # sparse-friendly matrix exponential
|   +-- Generation of models/
|       +-- ErdosRenyi.m                   # Erdos-Renyi graph generator
|       +-- WattsStrogatz.m                # Watts-Strogatz graph generator
|       +-- BarabasiAlbert.m               # Barabasi-Albert graph generator
+-- Data/
|   +-- podaci_bridovi.txt                 # two-column edge list
+-- Final paper/
    +-- GraphCentralityMeasures.pdf        # full mathematical report
```

## Working With the Code

The code is written in MATLAB. To use the functions, add both code directories to
the MATLAB path:

```matlab
addpath("Code/Centralities")
addpath("Code/Generation of models")
```

A typical experiment generates a graph, computes several rankings, and compares
the most central vertices:

```matlab
n = 100;
k = 8;
p = 0.1;
alpha = 0.05;
beta = 0.1;

A = WattsStrogatz(n, k, p);

degreeCenters = DegreeCent(A, false);
closenessCenters = ClosenessCent(A, false);
eigenCenters = EigenValueCent(A, false);
katzCenters = KatzCent(A, alpha);
expCenters = ExpSubgraphCent(A, beta);
resolventCenters = ResSubgraphCent(A, alpha);
totalCommCenters = TotalCommunicabilityCent(A, beta);
betweennessCenters = BetweennessCent(A);
```

Each centrality function returns vertex indices sorted from most central to least
central. For example, `degreeCenters(1)` is the vertex with the highest degree
centrality according to the implemented ranking.

The file `Code/Centralities/main.m` shows the intended comparison workflow using
a Watts-Strogatz graph.

## Working With the Data

The file `Data/podaci_bridovi.txt` is a two-column edge list. The node labels are
zero-based, so they should be shifted by one before constructing a MATLAB
adjacency matrix.

```matlab
edges = readmatrix("Data/podaci_bridovi.txt");
edges = edges + 1;

n = max(edges, [], "all");
A = sparse(edges(:, 1), edges(:, 2), 1, n, n);
```

If the data should be treated as an undirected simple graph, the adjacency matrix
can be symmetrized and self-loops can be removed:

```matlab
A = double((A + A.') > 0);
A(1:n+1:end) = 0;
```

## Implemented Functions

| Function | Centrality or model | Main parameters |
| --- | --- | --- |
| `DegreeCent` | degree centrality | `A`, `directed`, optional direction |
| `ClosenessCent` | closeness centrality | `A`, `directed` |
| `EigenValueCent` | eigenvector centrality | `A`, `directed`, optional direction |
| `KatzCent` | Katz centrality | `A`, `alpha` |
| `KatzCent_2` | iterative Katz centrality | `A`, `alpha` |
| `ExpSubgraphCent` | exponential subgraph centrality | `A`, `beta` |
| `ExpSubgraphCent_2` | fast exponential subgraph centrality | `A`, `beta` |
| `ResSubgraphCent` | resolvent subgraph centrality | `A`, `alpha` |
| `TotalCommunicabilityCent` | total communicability centrality | `A`, `beta` |
| `BetweennessCent` | betweenness centrality | `A` |
| `ErdosRenyi` | random graph generator | `n`, `p`, `directed` |
| `WattsStrogatz` | small-world graph generator | `n`, `k`, `p` |
| `BarabasiAlbert` | preferential attachment generator | `n`, `m` |

## Possible Directions for Further Research

- Comparing how stable the centrality rankings are across different random graph
  models.
- Studying the runtime of shortest-path centralities versus matrix-function
  centralities on larger sparse graphs.
- Normalizing centrality scores so that rankings can be compared across graphs
  of different sizes.
- Extending the implementations for weighted graphs.
- Comparing exact matrix exponential methods with Krylov or low-rank
  approximations for large networks.
- Studying how directed graph conventions affect in-centrality and
  out-centrality rankings.

## References

- M. E. J. Newman, *Networks: An Introduction*, Oxford University Press, 2010.
- P. Bonacich, *Power and centrality: A family of measures*, American Journal of
  Sociology, 1987.
- L. Katz, *A new status index derived from sociometric analysis*, Psychometrika,
  1953.
- E. Estrada and J. A. Rodriguez-Velazquez, *Subgraph centrality in complex
  networks*, Physical Review E, 2005.
- D. J. Watts and S. H. Strogatz, *Collective dynamics of small-world networks*,
  Nature, 1998.
- A.-L. Barabasi and R. Albert, *Emergence of scaling in random networks*,
  Science, 1999.
