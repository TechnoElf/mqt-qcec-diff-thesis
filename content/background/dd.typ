#import "@preview/cetz:0.2.2": canvas, draw
#import "@preview/fletcher:0.5.1": diagram, node, edge
#import "@preview/gentle-clues:0.9.0": example
#import "@preview/tablex:0.0.8": tablex, vlinex, hlinex
#import "@preview/quill:0.3.0": quantum-circuit, lstick, rstick, ctrl, targ

== Decision Diagrams
Decision diagrams in general are directed acyclical graphs, that may be used to express control flow through a series of conditions.
It consists of a set of decision nodes and terminal nodes.
The decision nodes represent an arbitrary decision based on an input value and may thus have any number of outgoing edges.
The terminal nodes represent output values and may not have outgoing edges.

A @bdd is a specific kind of decision diagram, where there are two terminal nodes (0 and 1) and each decision node has two outgoing edges, depending solely on a single bit of an input value.
@bdd[s] may be used to represent any boolean function, as illustrated by the following example.

#example(breakable: true)[
  Example @bdd[s] implementing boolean functions with an arity of $2$ are show in @example_bdd_xor and @example_bdd_and.

  #figure(
    grid(
      columns: (4fr, 1fr, 4fr, 1fr, 4fr),
      align(
        horizon,
        canvas({
          import draw: *
          let x = calc.cos(calc.asin(0.25)) - calc.cos(calc.asin(0.5)) - 0.6
          merge-path(close: true, {
            arc((0.5, 0), start: -90deg, stop: -30deg, anchor: "end", name: "bcurve")
            arc((0.5,0), start: 30deg, stop: 90deg, anchor: "start", name: "tcurve")
            line("tcurve.end", (-0.5, 0.5))
            arc((), start: 30deg, stop: -30deg, anchor: "start")
          })
          arc((-0.6, -0.5), start: -30deg, stop: 30deg)
          line((x, 0.25), (-1, 0.25))
          line((x, -0.25), (-1, -0.25))
          line((0.5, 0), (1, 0))
          content((-1, 0.25), [$x_0$], anchor: "east")
          content((-1, -0.25), [$x_1$], anchor: "east")
        })
      ),
      align(horizon)[$<=>$],
      align(
        horizon,
        tablex(
          columns: (1cm, 1cm, 1cm),
          auto-vlines: false,
          auto-hlines: false,
          [*$x_1$*], [*$x_2$*], vlinex(), [out],
          hlinex(),
          [0], [0], [0],
          [0], [1], [1],
          [1], [0], [1],
          [1], [1], [0]
        )
      ),
      align(horizon)[$<=>$],
      align(
        horizon,
        diagram(
          node-stroke: .1em,
          node((0, 0), [$x_1$], radius: 1em),
          edge((0, 0), (-0.5, 1), [0], "->"),
          edge((0, 0), (0.5, 1), [1], "->"),
          node((-0.5, 1), [$x_0$], radius: 1em),
          node((0.5, 1), [$x_0$], radius: 1em),
          edge((-0.5, 1), (-0.5, 2), [0], "->"),
          edge((-0.5, 1), (0.5, 2), [1], "->"),
          edge((0.5, 1), (0.5, 2), [0], "->"),
          edge((0.5, 1), (-0.5, 2), [1], "->"),
          node((-0.5, 2), [$0$], shape: rect),
          node((0.5, 2), [$1$], shape: rect)
        )
      )
    ),
    caption: [A @bdd for an XOR gate.]
  ) <example_bdd_xor>

  #figure(
    grid(
      columns: (4fr, 1fr, 4fr, 1fr, 4fr),
      align(
        horizon,
        canvas({
          import draw: *
          merge-path(close: true, {
            arc((0,0), start: -90deg, stop: 90deg, radius: 0.5, anchor: "origin", name: "curve")
            line((0, 0.5), (-0.5, 0.5), (-0.5, -0.5))
          })
          line((-0.5, 0.25), (-1, 0.25))
          line((-0.5, -0.25), (-1, -0.25))
          line((0.5, 0), (1, 0))
          content((-1, 0.25), [$x_0$], anchor: "east")
          content((-1, -0.25), [$x_1$], anchor: "east")
        })
      ),
      align(horizon)[$<=>$],
      align(
        horizon,
        tablex(
          columns: (1cm, 1cm, 1cm),
          auto-vlines: false,
          auto-hlines: false,
          [*$x_1$*], [*$x_2$*], vlinex(), [out],
          hlinex(),
          [0], [0], [0],
          [0], [1], [0],
          [1], [0], [0],
          [1], [1], [1]
        )
      ),
      align(horizon)[$<=>$],
      align(
        horizon,
        diagram(
          node-stroke: .1em,
          node((1, 0), [$x_1$], radius: 1em),
          edge((1, 0), (0, 2), [0], "->"),
          edge((1, 0), (1, 1), [1], "->"),
          node((1, 1), [$x_0$], radius: 1em),
          edge((1, 1), (0, 2), [0], "->"),
          edge((1, 1), (1, 2), [1], "->"),
          node((0, 2), [$0$], shape: rect),
          node((1, 2), [$1$], shape: rect)
        )
      )
    ),
    caption: [A @bdd for an AND gate.]
  ) <example_bdd_and>
]

A quantum @dd in turn is a representation of the system matrix of a quantum circuit.
Here the end nodes represent specific values in the matrix.
The location of the value is determined by the outgoing edges of the previous nodes.
At each layer $q_n$ of the graph, the matrix is recursively split up into four submatrices.
The left to right, the edges represent a decent into the top left, top right, bottom left and bottom right corners of the matrix respectively.
As the $0$ end node is usally the most common, it can be left out entirely and represented by unconnected edges instead.
Additionally, the edges can be assigned weights to represent a multiplication of the entire matrix by a coefficient.
Therefore, only a single end node with the value $1$ is needed in quantum @dd[s].

The following example demonstrates the relation between a quantum gate, its system matrix and the resulting @dd representation.

#example(breakable: true)[
  #figure(
    grid(
      columns: (4fr, 1fr, 4fr, 1fr, 4fr),
      align(
        horizon,
        quantum-circuit(
          lstick($|q_0〉$), ctrl(1), 1, [\ ],
          lstick($|q_1〉$), targ(), 1
        )
      ),
      align(horizon)[$<=>$],
      align(horizon)[$mat(
        1, 0, 0, 0;
        0, 1, 0, 0;
        0, 0, 0, 1;
        0, 0, 1, 0
      )$],
      align(horizon)[$<=>$],
      align(
        horizon,
        diagram(
          node-stroke: .1em,
          edge((0, -0.5), (0, 0), [], "->"),
          node((0, 0), [$q_1$], radius: 1em),
          edge((0, 0), (0, 1), [], "->", bend: -30deg),
          edge((0, 0), (0, 0.5), [], "->", bend: -10deg),
          edge((0, 0), (0, 0.5), [], "->", bend: 10deg),
          edge((0, 0), (0, 1), [], "->", bend: 30deg),
          node((0, 0.5), [$0$], stroke: 0pt),
          node((0, 1), [$q_0$], radius: 1em),
          edge((0, 1), (-0.5, 1.5), [], "->", bend: 10deg),
          edge((0, 1), (0, 2), [], "->", bend: -10deg),
          edge((0, 1), (0, 2), [], "->", bend: 10deg),
          edge((0, 1), (0.5, 1.5), [], "->", bend: -10deg),
          node((-0.5, 1.5), [$0$], stroke: 0pt),
          node((0.5, 1.5), [$0$], stroke: 0pt),
          node((0, 2), [$1$], shape: rect),
        )
      )
    ),
    caption: [A quantum CNOT gate, its matrix representation and the @dd of the matrix.]
  ) <example_dd>
]

