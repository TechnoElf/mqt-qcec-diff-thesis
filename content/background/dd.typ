#import "@preview/cetz:0.2.2": canvas, draw
#import "@preview/fletcher:0.5.1": diagram, node, edge
#import "@preview/gentle-clues:0.9.0": example
#import "@preview/quill:0.3.0": quantum-circuit, lstick, rstick, ctrl, targ

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
    grid(
      columns: (4fr, 1fr, 4fr),
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
      columns: (4fr, 1fr, 4fr),
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

#example[
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

