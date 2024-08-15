#import "@preview/fletcher:0.5.1": diagram, node, edge
#import "@preview/gentle-clues:0.9.0": example

== Decision Diagrams
Decision diagrams in general are directed acyclical graphs, that may be used to express control flow through a series of conditions.
It consists of a set of decision nodes and terminal nodes.
The decision nodes represent an arbitrary decision based on an input value and may thus have any number of outgoing edges.
The terminal nodes represent output values and may not have outgoing edges.

A @bdd is a specific kind of decision diagram, where there are two terminal nodes (0 and 1) and each decision node has two outgoing edges, depending solely on a single bit of an input value.
@bdd[s] may be used to represent any boolean function.

#example[
  Example @bdd[s] implementing boolean functions with an arity of $2$ are show in @example_bdd_xor and @example_bdd_and.

  #figure(
    diagram(
      node-stroke: .1em,
      node((0, 0), [$x_0$], radius: 1em),
      edge((0, 0), (-1, 1), [0], "->"),
      edge((0, 0), (1, 1), [1], "->"),
      node((-1, 1), [$x_1$], radius: 1em),
      node((1, 1), [$x_1$], radius: 1em),
      edge((-1, 1), (-1, 2), [0], "->"),
      edge((-1, 1), (1, 2), [1], "->"),
      edge((1, 1), (1, 2), [0], "->"),
      edge((1, 1), (-1, 2), [1], "->"),
      node((-1, 2), [$0$]),
      node((1, 2), [$1$]),
    ),
    caption: [A @bdd for an XOR gate.]
  ) <example_bdd_xor>

  #figure(
    diagram(
      node-stroke: .1em,
      node((1, 0), [$x_0$], radius: 1em),
      edge((1, 0), (0, 2), [0], "->"),
      edge((1, 0), (1, 1), [1], "->"),
      node((1, 1), [$x_1$], radius: 1em),
      edge((1, 1), (0, 2), [0], "->"),
      edge((1, 1), (1, 2), [1], "->"),
      node((0, 2), [$0$]),
      node((1, 2), [$1$]),
    ),
    caption: [A @bdd for an AND gate.]
  ) <example_bdd_and>
]

#example[
  #figure(
    diagram(
      node-stroke: .1em,
      node((1, 0), [$x_0$], radius: 1em),
      edge((1, 0), (0, 2), [0], "->", bend: -20deg),
      edge((1, 0), (0, 2), [1], "->", bend: -10deg),
      edge((1, 0), (0, 2), [1], "->", bend: 10deg),
      edge((1, 0), (0, 2), [1], "->", bend: 20deg),
      node((0, 2), [$0$]),
    ),
    caption: [A @dd.]
  ) <example_dd>
]

A quantum @dd in turn is a representation of the system matrix of a quantum circuit.
