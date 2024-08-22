#import "@preview/fletcher:0.5.1": diagram, node, edge
#import "@preview/gentle-clues:0.9.0": example, code
#import "@preview/lovelace:0.3.0": pseudocode-list

== Algorithms
This section provides an overview of the implemented diff algorithms.
While some algorithms where only implemented much later into development, it is beneficial to discuss these algorithms now, in order to better compare them to each other and to reason about later implementation choices.

Initially, research was done to determine suitable algorithms for the task.
A variety of algorithms was found, but only a limited representative set was chosen for implementation due to their similarity and the given time constraints.
The chosen algorithms are: Djikstra's algorithm (for its simplicity), Myers' algorithm (for its ubiquity) and the patience algorithm (for its relative novelty).

=== Djikstra's Algorithm
Djikstra's algorithm is an @sssp algorithm.
This means that it solves the problem of finding the shortest distance from a node of a graph to any other node @djikstra1959shortest.
It can thus be trivially applied as a diff algorithm by finding the shortest path accross an edit graph.
@djikstras_algorithm_abstract presents a slightly modified form of the original algorithm that more closely matches modern programming languages.

#figure(
  block(
    pseudocode-list[
      + *def* $"djiksta"(G, s, e)$
        + create a list of remaining nodes $N$ containing all nodes in $G$
        + set the distance for all nodes in $N$ to infinity
        + set the parent for all nodes in $N$ to none
        + set the distance for the starting node $s$ in $N$ to $0$
        + *while* there are nodes left ($N$ is not empty)
          + take node $c$ with the lowest distance from $N$
          + *if* $c$ is the end node $e$
            + *break*
          + *end*
          + *for* each child node $n$ of of the current node $c$
            + *if* the current distance is shorter than the stored distance in $n$
              + set the current distance as the distance of $n$
              + set the current node $c$ as the parent of $n$
            + *end*
          + *end*
        + *end*
        + *return* a path through the graph found by traversing the parent nodes of the end node $e$
      + *end*
    ],
    width: 100%
  ),
  caption: [Djikstra's algorithm.]
) <djikstras_algorithm_abstract>

In this pseudocode implementation, the inner loop corresponds to Step 1 and the outer loop to Step 2 from the original description @djikstra1959shortest.
The list $N$ corresponds to sets $B$ and $C$ and the nodes removed from $N$ correspond to the set $A$.

Given the constraints of the edit graph, it is possible to simplify the algorithm.
Firstly, the edges have no assigned weight and are therefore assumed to uniformly have a weight of $1$ for this algorithm.
Secondly, the graph is always a @dag.
Djikstra's algorithm hereby essentially reduces to a breadth-first search over the graph.
The implementation is thus as follows:

#figure(
  block(
    pseudocode-list[
      + *def* $"djiksta"(v)$
        + create a list of remaining nodes containing only $v$
        + *while* the list of remaining nodes is not empty
          + take the lowest element from the list of remaining nodes
          + *if* the current element is the last node
            + *break*
          + *end*
          + *for* each child node $c$ of of the current element
            + *if* $c$ has no parent
              + set the current element as the parent of $c$
              + add $c$ to the list of remaining nodes
            + *end*
          + *end*
        + *end*
        + find a path through the edit graph by traversing the parent nodes of the final node
        + *return* the edit script found by taking the reverse of the path
      + *end*
    ],
    width: 100%
  ),
  caption: [Modified Djikstra's algorithm.]
) <mod_djikstras_algorithm_abstract>

#example[
  @example_djikstra shows an example instance of the modified Djikstra's algorithm shown in @mod_djikstras_algorithm_abstract. The edge labels specify the order in which the nodes are visited (child nodes are iterated over from top right to bottom left). The red edges highlight the final path found by the algorithm after traversing the parent nodes from the final node in reverse order.

  #figure(
    diagram(
      spacing: 1cm,
      node-stroke: .1em,
      for y in range(0, 5) {
        for x in range(0, 5) {
          node((x, y), radius: 1em)
        }
      },

      edge((3, 0), (4, 1), [12], "->", stroke: 1.5pt),
      edge((0, 1), (1, 2), [4], "->", stroke: 1.5pt + red),
      edge((2, 1), (3, 2), [14], "->", stroke: 1.5pt),
      edge((0, 2), (1, 3), "->"),
      edge((2, 2), (3, 3), [15], "->", stroke: 1.5pt + red),
      edge((1, 3), (2, 4), [17], "->", stroke: 1.5pt),

      edge((0, 0), (1, 0), [0], "->", stroke: 1.5pt),
      edge((1, 0), (2, 0), [2], "->", stroke: 1.5pt),
      edge((2, 0), (3, 0), [6], "->", stroke: 1.5pt),
      edge((3, 0), (4, 0), [11], "->", stroke: 1.5pt),
      edge((0, 1), (1, 1), "->"),
      edge((1, 1), (2, 1), "->"),
      edge((2, 1), (3, 1), "->"),
      edge((3, 1), (4, 1), "->"),
      edge((0, 2), (1, 2), "->"),
      edge((1, 2), (2, 2), [8], "->", stroke: 1.5pt + red),
      edge((2, 2), (3, 2), "->"),
      edge((3, 2), (4, 2), "->"),
      edge((0, 3), (1, 3), "->"),
      edge((1, 3), (2, 3), "->"),
      edge((2, 3), (3, 3), "->"),
      edge((3, 3), (4, 3), [21], "->", stroke: 1.5pt + red),
      edge((0, 4), (1, 4), "->"),
      edge((1, 4), (2, 4), "->"),
      edge((2, 4), (3, 4), "->"),
      edge((3, 4), (4, 4), "->"),

      edge((0, 0), (0, 1), [1], "->", stroke: 1.5pt + red),
      edge((0, 1), (0, 2), [5], "->", stroke: 1.5pt),
      edge((0, 2), (0, 3), [10], "->", stroke: 1.5pt),
      edge((0, 3), (0, 4), [19], "->", stroke: 1.5pt),
      edge((1, 0), (1, 1), [3], "->", stroke: 1.5pt),
      edge((1, 1), (1, 2), "->"),
      edge((1, 2), (1, 3), [9], "->", stroke: 1.5pt),
      edge((1, 3), (1, 4), [18], "->", stroke: 1.5pt),
      edge((2, 0), (2, 1), [7], "->", stroke: 1.5pt),
      edge((2, 1), (2, 2), "->"),
      edge((2, 2), (2, 3), [16], "->", stroke: 1.5pt),
      edge((2, 3), (2, 4), "->"),
      edge((3, 0), (3, 1), [13], "->", stroke: 1.5pt),
      edge((3, 1), (3, 2), "->"),
      edge((3, 2), (3, 3), "->"),
      edge((3, 3), (3, 4), [22], "->", stroke: 1.5pt),
      edge((4, 0), (4, 1), "->"),
      edge((4, 1), (4, 2), [20], "->", stroke: 1.5pt),
      edge((4, 2), (4, 3), "->"),
      edge((4, 3), (4, 4), [23], "->", stroke: 1.5pt + red),
    ),
    caption: [Modified Djikstra's algorithm on an example edit graph.]
  ) <example_djikstra>
]


At this point, it was considered wether to implement another @spsp algorithm such as A\*.
This was, however, deemed unnecessary, as there exist better solutions tailored specifically to edit graphs.


=== Myers' Algorithm
#figure(
  block(
    pseudocode-list[
      + *def* $"myers"()$
        + find a central connecting snake between the top left and bottom right of the edit graph
        + *if* the edit graph is trivial
          + *return* the trivial solution
        + *else*
          + run $"myers"()$ on the top left subgraph recursively
          + run $"myers"()$ on the bottom right subgraph recursively
          + *return* the combined edit scripts from the recursive calls and the central snake
        + *end*
      + *end*
    ],
    width: 100%
  ),
  caption: [Myers' algorithm.]
) <myers_algorithm_abstract>


#example[
  Applying the first step of the abstract Myers' algorithm to the sample edit graph from @example_edit_graph yields the connecting snake marked in red in @example_snake. The algorithm then saves this snake as part of the edit script and continues working on the resulting subgraphs, as shown in @example_recursion. It will then combine the edit scripts from these with the connecting snake to form a final edit script.

  #figure(
    diagram(
      spacing: 1cm,
      node-stroke: .1em,
      for y in range(0, 5) {
        for x in range(0, 5) {
          node((x, y), radius: 1em)
        }
      },

      edge((3, 0), (4, 1), "->"),
      edge((0, 1), (1, 2), "->", stroke: 2pt),
      edge((2, 1), (3, 2), "->"),
      edge((0, 2), (1, 3), "->"),
      edge((2, 2), (3, 3), "->"),
      edge((1, 3), (2, 4), "->", stroke: 2pt + red),

      edge((0, 0), (1, 0), "->"),
      edge((1, 0), (2, 0), "->"),
      edge((2, 0), (3, 0), "->"),
      edge((3, 0), (4, 0), "->"),
      edge((0, 1), (1, 1), "->"),
      edge((1, 1), (2, 1), "->"),
      edge((2, 1), (3, 1), "->"),
      edge((3, 1), (4, 1), "->"),
      edge((0, 2), (1, 2), "->"),
      edge((1, 2), (2, 2), "->"),
      edge((2, 2), (3, 2), "->"),
      edge((3, 2), (4, 2), "->"),
      edge((0, 3), (1, 3), "->"),
      edge((1, 3), (2, 3), "->"),
      edge((2, 3), (3, 3), "->"),
      edge((3, 3), (4, 3), "->"),
      edge((0, 4), (1, 4), "->"),
      edge((1, 4), (2, 4), "->"),
      edge((2, 4), (3, 4), "<-", stroke: 2pt),
      edge((3, 4), (4, 4), "<-", stroke: 2pt),

      edge((0, 0), (0, 1), "->", stroke: 2pt),
      edge((0, 1), (0, 2), "->"),
      edge((0, 2), (0, 3), "->"),
      edge((0, 3), (0, 4), "->"),
      edge((1, 0), (1, 1), "->"),
      edge((1, 1), (1, 2), "->"),
      edge((1, 2), (1, 3), "->", stroke: 2pt),
      edge((1, 3), (1, 4), "->"),
      edge((2, 0), (2, 1), "->"),
      edge((2, 1), (2, 2), "->"),
      edge((2, 2), (2, 3), "->"),
      edge((2, 3), (2, 4), "->"),
      edge((3, 0), (3, 1), "->"),
      edge((3, 1), (3, 2), "->"),
      edge((3, 2), (3, 3), "->"),
      edge((3, 3), (3, 4), "->"),
      edge((4, 0), (4, 1), "->"),
      edge((4, 1), (4, 2), "->"),
      edge((4, 2), (4, 3), "->"),
      edge((4, 3), (4, 4), "->"),
    ),
    caption: [Snake found by the algorithm after the first iteration.]
  ) <example_snake>

  #figure(
    diagram(
      spacing: 1cm,
      node-stroke: .1em,
      for y in range(0, 5) {
        for x in range(0, 5) {
          node((x, y), radius: 1em)
        }
      },

      edge((0, 1), (1, 2), "->"),
      edge((0, 2), (1, 3), "->"),

      edge((0, 0), (1, 0), "->"),
      edge((0, 1), (1, 1), "->"),
      edge((0, 2), (1, 2), "->"),
      edge((0, 3), (1, 3), "->"),
      edge((2, 4), (3, 4), "->"),
      edge((3, 4), (4, 4), "->"),

      edge((0, 0), (0, 1), "->"),
      edge((0, 1), (0, 2), "->"),
      edge((0, 2), (0, 3), "->"),
      edge((1, 0), (1, 1), "->"),
      edge((1, 1), (1, 2), "->"),
      edge((1, 2), (1, 3), "->"),
    ),
    caption: [Remaining subgraphs to recursively apply the algorithm to.]
  ) <example_recursion>
]

#code(breakable: true)[
  The actual implementation of Myers' algorithm uses a slightly different procedure, where the subgraphs are checked for triviality instead of the input graph.
  This would be slower when the entire edit graph is trivial, however, this edge case will almost never occur when applying this algorithm to equivalence checking of quantum circuits. 

  #figure(
    block(
      pseudocode-list[
        + *def* $"myers"(x, y, m, n)$
          + $("snake_start_x", "snake_start_y", "snake_end_x", "snake_end_y") = "find_snake"(x, y, m, n)$
          + $"result" = {}$
          + $"result" = "result" + "process_subgraph"(x, y, "snake_start_x", "snake_start_y", m, n)$
          + $"result" = "result" + ("snake_end_x" - "snake_start_x", "snake_end_x" - "snake_start_x")$
          + $"result" = "result" + "process_subgraph"(x + "snake_end_x", y + "snake_end_y", m - "snake_end_x", n - "snake_end_y", m, n)$
          + *return* $"result"$
        + *end*
      ],
      width: 100%
    ),
    caption: [Myers' algorithm.]
  ) <myers_algorithm>

  #figure(
    block(
      pseudocode-list[
        + *def* $"process_subgraph"(x, y, w, h, m, n)$
          + *if* $(w = 0 and h != 0) or (w != 0 and h = 0)$
            + *return* $(w, h)$
          + *else if* $w = m and h = n$
            + *if* $w > h$
              + *return* ${(h, h), (w - h, 0)}$
            + *else*
              + *return* ${(w, w), (0, h - w)}$
            + *end*
          + *else*
            + *return* $"myers"(x, y, w, h)$
          + *end*
        + *end*
      ],
      width: 100%
    ),
    caption: [Myers' algorithm ($"process_subgraph"$ function).]
  ) <myers_algorithm_process_subgraph>

  #figure(
    block(
      pseudocode-list[
        + *def* $"find_snake"(x, y, m, n)$
          + $"best_x_forward"$ *is* $"array"((m + n) * 2 + 1)$
          + $"best_x_backward"$ *is* $"array"((m + n) * 2 + 1)$
          + *for* operations *in* $0$ *to* $m + n$
            + *for* diagonal *in* $-("operations" - 2 * max(0, "operations" - m))$ *to* $"operations" - 2 * max(0, "operations" - m)$
              + $"calculate_best_x_forward"("best_x_forward", "diagonal", m, n)$
              + $"snake_start" = "follow_snake_forward"("best_x_forward", "diagonal", x, y, m, n)$
              + *if* $"overlap_forward"()$
                + $"snake_start_x" = "snake_start"$
                + $"snake_start_y" = "snake_start" - "diagonal"$
                + $"snake_end_x" = "best_x_forward"[m + n + "diagonal"]$
                + $"snake_end_y" = "best_x_forward"[m + n + "diagonal"] - "diagonal"$
                + *return* $("snake_start_x", "snake_start_y", "snake_end_x", "snake_end_y")$
              + *end*
            + *end*
            + *for* diagonal *in* $-("operations" - 2 * max(0, "operations" - m))$ *to* $"operations" - 2 * max(0, "operations" - m)$
              + $"calculate_best_x_backward"("best_x_forward", "diagonal", m, n)$
              + $"snake_end" = "follow_snake_backward"("best_x_backward", "diagonal", x, y, m, n)$
              + *if* $"overlap_backward"()$
                + $"snake_start_x" = m - "best_x_forward"[m + n + "diagonal"]$
                + $"snake_start_y" = n - "best_x_forward"[m + n + "diagonal"] + "diagonal"$
                + $"snake_end_x" = m - "snake_end"$
                + $"snake_end_y" = n - "snake_end" + "diagonal"$
                + *return* $("snake_start_x", "snake_start_y", "snake_end_x", "snake_end_y")$
              + *end*
            + *end*
          + *end*
        + *end*
      ],
      width: 100%
    ),
    caption: [Myers' algorithm ($"find_snake"$ function).]
  ) <myers_algorithm_find_snake>

  #figure(
    block(
      pseudocode-list[
        + *def* $"calculate_best_x_forward"("best_x_forward", "diagonal", m, n)$
          + *if* $"diagonal" = -"operations"$
            + $"best_x_forward"[m + n + "diagonal"] = "best_x_forward"[m + n + "diagonal" + 1]$
          + *else if* $"diagonal" = "operations"$
            + $"best_x_forward"[m + n + "diagonal"] = "best_x_forward"[m + n + "diagonal" - 1]$
          + *else*
            + *if* $"best_x_forward"[m + n + "diagonal" - 1] > "best_x_forward"[m + n + "diagonal" + 1]$
              + $"best_x_forward"[m + n + "diagonal"] = "best_x_forward"[m + n + "diagonal" - 1]$
            + *else*
              + $"best_x_forward"[m + n + "diagonal"] = "best_x_forward"[m + n + "diagonal" + 1]$
            + *end*
          + *end*
        + *end*
      ],
      width: 100%
    ),
    caption: [Myers' algorithm ($"calculate_best_x_forward"$ function).]
  ) <myers_algorithm_calculate_best_x_forward>

  #figure(
    block(
      pseudocode-list[
        + *def* $"follow_snake_forward"("best_x_forward", "diagonal", x, y, m, n)$
          + $"snake_start" = "best_x_forward"[m + n + "diagonal"]$
          + *while* $"best_x_forward"[m + n + "diagonal"] < m and "best_x_forward"[m + n + "diagonal"] < n and A[x + "best_x_forward"[m + n + "diagonal"]] == B[y + "best_x_forward"[m + n + "diagonal"] - "diagonal"]$ 
            + $"best_x_forward"[m + n + "diagonal"] = "best_x_forward"[m + n + "diagonal"] + 1$
          + *end*
          + *return* $"snake_start"$
        + *end*
      ],
      width: 100%
    ),
    caption: [Myers' algorithm ($"follow_snake_forward"$ function).]
  ) <myers_algorithm_follow_snake_forward>

  #figure(
    block(
      pseudocode-list[
        + *def* $"overlap_forward"("best_x_forward", "best_x_backward", "diagonal", x, y, m, n)$
          + *return* $(-2n < "diagonal") and ("diagonal" < 2m) and ("best_x_forward"[m + n + "diagonal"] != -1) and ("best_x_backward"[2m + "diagonal"] != -1) and ("best_x_forward"[m + n + "diagonal"] + "best_x_backward"[2m + "diagonal"] >= m)$
        + *end*
      ],
      width: 100%
    ),
    caption: [Myers' algorithm ($"overlap_forward"$ function).]
  ) <myers_algorithm_overlap_forward>

  The $"_backward"$ functions used in @myers_algorithm_find_snake are analogous to the $"_forward"$ functions shown in @myers_algorithm_calculate_best_x_forward, @myers_algorithm_follow_snake_forward and @myers_algorithm_overlap_forward.
]

=== Patience Algorithm
#figure(
  block(
    pseudocode-list[
      + *def* $"patience"()$
        + find unique elements common to both $A$ and $B$
        + *if* there are no unique elements
          + *return* the results of another diff algorithm (for example $"myers"()$)
        + *end*
        + apply patience sort to the unique common elements to find the longest increasing sequence
        + *for* each range between the elements of the sequence produced by the patience sort
          + *if* the range is trivial
            + append the trivial result to the edit script
          + *else*
            + run $"patience"()$ recursively on the range and append the result to the edit script
          + *end*
          + append $(1, 1)$ to the edit script
        + *end*
        + *return* the edit script
      + *end*
    ],
    width: 100%
  ),
  caption: [Patience algorithm.]
) <patience_algorithm_abstract>

#code(breakable: true)[
  As with the Myers' algorithm, the implementation of the Patience algorithm differs slightly from the abstract representation.

  #block(
    pseudocode-list[
      + *def* $"patience"(x, y, m, n)$
        + $"index_matches" = "find_index_matches"(x, y, m, n)$
        + *if* $"index_matches"$ *is empty*
          + *return* $"myers"(x, y, m, n)$
        + *end*
        + $"increasing_matches" = "patience_sort"("index_matches")$
        + *append* $(m, n)$ *to* $"increasing_matches"$
        + $"edit_script"$ *is* $"vector of" ("integer", "integer")$
        + $("prev_a_index", "prev_b_index") = (0, 0)$
        + *for* $("a_index", "b_index")$ *in* $"increasing_matches"$
          + $("a_delta", "b_delta") = ("a_index" - "prev_a_index", "b_index" - "prev_b_index")$
          + *if* $"a_delta" > 0 and "b_delta" > 0$
            + *append* $"patience"("prev_a_index", "prev_b_index", "a_delta", "b_delta")$ *to* $"edit_script"$
          + *else if* $"a_delta" > 0$
            + *append* $("a_delta", 0)$ *to* $"edit_script"$
          + *else if* $"b_delta" > 0$
            + *append* $(0, "b_delta")$ *to* $"edit_script"$
          + *end*
          + *if* $"a_index" = m and "b_index" = n$
            + *return* $"edit_script"$
          + *end*
          + *if* $($*last element of* $"edit_script")[0] = ($*last element of* $"edit_script")[1]$ {
            + $($*last element of* $"edit_script")[0] = ($*last element of* $"edit_script")[0] + 1$
            + $($*last element of* $"edit_script")[1] = ($*last element of* $"edit_script")[1] + 1$
          + *else* 
            + *append* $(1, 1)$ *to* $"edit_script"$
          + *end*
          + $("prev_a_index", "prev_b_index") = ("a_index" + 1, "b_index" + 1)$
        + *end*
      + *end*
    ],
    width: 100%
  )

  #block(
    pseudocode-list[
      + *def* $"find_index_matches"(x, y, m, n)$
        + $"a_count"$ *is* $"map of gates to integers"$
        + $"a_index"$ *is* $"map of gates to integers"$
        + $"b_count"$ *is* $"map of gates to integers"$
        + $"b_index"$ *is* $"map of gates to integers"$
        + *for* i *in* 0 *to* m
          + $"a_count"[A[x + i]] = "a_count"[A[x + i]] + 1$
          + $"a_index"[A[x + i]] = i$
        + *end*
        + *for* i *in* 0 *to* n
          + $"b_count"[B[x + i]] = "b_count"[B[x + i]] + 1$
          + $"b_index"[B[x + i]] = i$
        + *end*
        + $"index_matches"$ *is* $"map of integers to integers"$
        + *for* $("gate", "count")$ *in* $"a_count"$
          + *if* $"count" = 1 and "b_count"["gate"] = 1$
            + $"index_matches"["a_index"["gate"]] = "b_index"["gate"]$
          + *end*
        + *end*
        + *return* $"index_matches"$
      + *end*
    ],
    width: 100%
  )

  #block(
    pseudocode-list[
      + *def* $"patience_sort"("index_matches")$
        + $"a_count"$ *is* $"map of gates to integers"$
        + $"a_index"$ *is* $"map of gates to integers"$
        + $"b_count"$ *is* $"map of gates to integers"$
        + $"b_index"$ *is* $"map of gates to integers"$
        + *for* i *in* 0 *to* m
          + $"a_count"[A[x + i]] = "a_count"[A[x + i]] + 1$
          + $"a_index"[A[x + i]] = i$
        + *end*
        + *for* i *in* 0 *to* n
          + $"b_count"[B[x + i]] = "b_count"[B[x + i]] + 1$
          + $"b_index"[B[x + i]] = i$
        + *end*
        + $"index_matches"$ *is* $"map of integers to integers"$
        + *for* $("gate", "count")$ *in* $"a_count"$
          + *if* $"count" = 1 and "b_count"["gate"] = 1$
            + $"index_matches"["a_index"["gate"]] = "b_index"["gate"]$
          + *end*
        + *end*
        + *return* $"index_matches"$
      + *end*
    ],
    width: 100%
  )
]

=== Adaptation of Diff Algorithms for QCEC
All of these algorithms had a common issue, however.
For a diff algorithm to be useful as an application scheme for @qcec, it must output a list of pairs of numbers describing the quantity of gates to apply from either circuit.
This is contrary to the typical requirement of an edit script that describes insert, remove and keep operations.
These operations, however, correspond directly to the application:
- A removal operation in the edit script is analogous to the application of a gate from the left of the first circuit, expanding the @dd.
- An insertion operation in turn is analogous to the inverse application of a gate from the right of the second circuit, theoretically bringing the @dd closer to the identity again.
- Finally, A keep operation causes both applications simultaneously, which should leave the @dd unchanged.

Furthermore, the specifications of the actual gates that are being applied are redundant once the edit script has been found.
Only the application order is significant to the algorithm.
This results in a sequence consisting only of the operations "apply first", "apply second" and "apply both".
Sequences of identical operations can also be combined into a single operation as this does not affect the application order.
Each application operation can then be represented by a tuple of two values $(r, l)$, the first of which specifies the gates to be applied from the first circuit, and the other those from the second.

Additionally, the order of the gates in the second circuit must be inverted before calculating the edit script.
This is due to the "socks and shoes" rule of matrix inversion: For the product of two matrices $A$ and $B$ the equation $(A B) ^ (-1) = B ^ (-1) A ^ (-1)$ must hold.
The inversion of the product may be calculated by taking the inverse of each matrix and multiplying them in reverse order.
By induction the same is true for the product of any number of matrices.

As quantum gates and circuits are representations of matrices, the same rule applies to them as well.
The @dd\-based alternating equivalence checker therefore not only inverts each gate in the second circuit, but reverses their application order as well.
This means that the second circuit must also be reversed before applying the diff algorithm in order to find structural similarities between the first circuit and the inverse of the second circuit.

The following example illustrates these concepts graphically.

#example[
  Keeping the same sequence as used in the previous examples, "hxhy" and "yhhx", @example_edit_script_conversion demonstrates the conversion of an edit script as produced by the discussed diff algorithms into a form useable by @qcec.
  The edit script used is identical to the one found in @example_path.

  #figure(
    grid(
      columns: (4fr, 2fr, 4fr, 2fr, 4fr),
      align(horizon)[`+ y` \ `+ h` \ `keep h` \ `keep x` \ `- h` \ `- y`],
      align(horizon)[$->$ \ convert],
      align(horizon)[$(0, 1) \ (0, 1) \ (1, 1) \ (1, 1) \ (1, 0) \ (1, 0)$],
      align(horizon)[$->$ \ simplify],
      align(horizon)[$(0, 2) \ (2, 2) \ (2, 0)$]
    ),
    kind: image,
    caption: [Sample transformation of edit script operations into a sequence of gate applications.]
  ) <example_edit_script_conversion>

  In this example, the second circuit is assumed to have been inverted beforehand.
  The original circuit would have been "xhhy".
]
