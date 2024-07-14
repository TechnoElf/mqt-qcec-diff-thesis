#import "@preview/cetz:0.2.2": canvas, draw
#import "@preview/fletcher:0.5.1": diagram, node, edge
#import "@preview/gentle-clues:0.9.0": example
#import "@preview/quill:0.3.0": quantum-circuit, lstick, rstick, ctrl, targ, mqgate, meter


= Background
== Quantum Computation and Quantum Circuits
A quantum computer is a device that performs calculations by using certain phenomena of quantum mechanics.
The algorithms that run on this device are specified in quantum circuits.

#figure(
  [$alpha|0〉 + beta|1〉$ #h(2em) $vec(alpha, beta)$],
  caption: [A Qubit in algebraic and vector notation]
) <example_vec>

#figure(
  canvas({
    import draw: *
    scale(1)

    circle((0, 0, 0), radius: 2)
    group({rotate(x: 90deg); circle((0, 0, 0), radius: 2)})
    group({rotate(y: 90deg); circle((0, 0, 0), radius: 2)})
    circle((0, 0, 0), radius: 0.1, fill: black)
    
    line((0, 0, 0), (0, 0, -1.5), mark: (end: ">"), name: "x")
    line((0, 0, 0), (1.5, 0, 0), mark: (end: ">"), name: "y")
    line((0, 0, 0), (0, 1.5, 0), mark: (end: ">"), name: "z")

    content("x.end", anchor: "north", [x])
    content("y.end", anchor: "west", [y])
    content("z.end", anchor: "south", [z])

    content((0, 2.5, 0), [|0〉])
    content((0, -2.5, 0), [|1〉])
  }),
  caption: [A Bloch sphere]
) <example_bloch>

#example[
  @example_qc shows a simple quantum circuit that implements a specific quantum algorithm.

  #figure(
    quantum-circuit(
      lstick($|0〉$), $H$, mqgate($U$, n: 2, width: 5em, inputs: ((qubit: 0, label: $x$), (qubit: 1, label: $y$)), outputs: ((qubit: 0, label: $x$), (qubit: 1, label: $y plus.circle f(x)$))), $H$, meter(), [\ ],
      lstick($|1〉$), $H$, 1, 1, 1
    ),
    caption: [A quantum circuit implementing the Deutsch-Jozsa algorithm]
  ) <example_qc>
]


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


== The Longest Common Subsequence Problem
#example[
  #figure(
    diagram(
      node-stroke: .1em,
      node((0, 0), [hxhy], radius: 2em),
      node((1, 0), [xhy], radius: 2em),
      node((2, 0), [hy], radius: 2em),
      node((3, 0), [y], radius: 2em),
      node((4, 0), [], radius: 2em),
      node((0, 1), [yhxhy], radius: 2em),
      node((1, 1), [yxhy], radius: 2em),
      node((2, 1), [yhy], radius: 2em),
      node((3, 1), [yy], radius: 2em),
      node((4, 1), [y], radius: 2em),
      node((0, 2), [yhhxhy], radius: 2em),
      node((1, 2), [yhxhy], radius: 2em),
      node((2, 2), [yhhy], radius: 2em),
      node((3, 2), [yhy], radius: 2em),
      node((4, 2), [yh], radius: 2em),
      node((0, 3), [yhhhxhy], radius: 2em),
      node((1, 3), [yhhxhy], radius: 2em),
      node((2, 3), [yhhhy], radius: 2em),
      node((3, 3), [yhhy], radius: 2em),
      node((4, 3), [yhh], radius: 2em),
      node((0, 4), [yhhxhxhy], radius: 2em),
      node((1, 4), [yhhxxhy], radius: 2em),
      node((2, 4), [yhhxhy], radius: 2em),
      node((3, 4), [yhhxy], radius: 2em),
      node((4, 4), [yhhx], radius: 2em),

      edge((3, 0), (4, 1), "->"),
      edge((0, 1), (1, 2), "->"),
      edge((2, 1), (3, 2), "->"),
      edge((0, 2), (1, 3), "->"),
      edge((2, 2), (3, 3), "->"),
      edge((1, 3), (2, 4), "->"),

      edge((0, 0), (1, 0), [-h], "->"),
      edge((1, 0), (2, 0), [-x], "->"),
      edge((2, 0), (3, 0), [-h], "->"),
      edge((3, 0), (4, 0), [-y], "->"),
      edge((0, 1), (1, 1), [-h], "->"),
      edge((1, 1), (2, 1), [-x], "->"),
      edge((2, 1), (3, 1), [-h], "->"),
      edge((3, 1), (4, 1), [-y], "->"),
      edge((0, 2), (1, 2), [-h], "->"),
      edge((1, 2), (2, 2), [-x], "->"),
      edge((2, 2), (3, 2), [-h], "->"),
      edge((3, 2), (4, 2), [-y], "->"),
      edge((0, 3), (1, 3), [-h], "->"),
      edge((1, 3), (2, 3), [-x], "->"),
      edge((2, 3), (3, 3), [-h], "->"),
      edge((3, 3), (4, 3), [-y], "->"),
      edge((0, 4), (1, 4), [-h], "->"),
      edge((1, 4), (2, 4), [-x], "->"),
      edge((2, 4), (3, 4), [-h], "->"),
      edge((3, 4), (4, 4), [-y], "->"),

      edge((0, 0), (0, 1), [+y], "->"),
      edge((0, 1), (0, 2), [+h], "->"),
      edge((0, 2), (0, 3), [+h], "->"),
      edge((0, 3), (0, 4), [+x], "->"),
      edge((1, 0), (1, 1), [+y], "->"),
      edge((1, 1), (1, 2), [+h], "->"),
      edge((1, 2), (1, 3), [+h], "->"),
      edge((1, 3), (1, 4), [+x], "->"),
      edge((2, 0), (2, 1), [+y], "->"),
      edge((2, 1), (2, 2), [+h], "->"),
      edge((2, 2), (2, 3), [+h], "->"),
      edge((2, 3), (2, 4), [+x], "->"),
      edge((3, 0), (3, 1), [+y], "->"),
      edge((3, 1), (3, 2), [+h], "->"),
      edge((3, 2), (3, 3), [+h], "->"),
      edge((3, 3), (3, 4), [+x], "->"),
      edge((4, 0), (4, 1), [+y], "->"),
      edge((4, 1), (4, 2), [+h], "->"),
      edge((4, 2), (4, 3), [+h], "->"),
      edge((4, 3), (4, 4), [+x], "->"),
    ),
    caption: [An edit graph.]
  ) <example_edit_graph>

  #figure(
    diagram(
      node-stroke: .1em,
      for y in range(0, 5) {
        for x in range(0, 5) {
          node((x, y), radius: 1em)
        }
      },

      edge((3, 0), (4, 1), "->"),
      edge((0, 1), (1, 2), "->"),
      edge((2, 1), (3, 2), "->"),
      edge((0, 2), (1, 3), "->", [keep h], stroke: 2pt),
      edge((2, 2), (3, 3), "->"),
      edge((1, 3), (2, 4), "->", [keep x], stroke: 2pt),

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
      edge((2, 4), (3, 4), "->", [-h], stroke: 2pt),
      edge((3, 4), (4, 4), "->", [-y], stroke: 2pt),

      edge((0, 0), (0, 1), "->", [+y], stroke: 2pt),
      edge((0, 1), (0, 2), "->", [+h], stroke: 2pt),
      edge((0, 2), (0, 3), "->"),
      edge((0, 3), (0, 4), "->"),
      edge((1, 0), (1, 1), "->"),
      edge((1, 1), (1, 2), "->"),
      edge((1, 2), (1, 3), "->"),
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
    caption: [One possible shortest path through the edit graph.]
  ) <example_path>
]

