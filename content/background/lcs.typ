#import "@preview/fletcher:0.5.1": diagram, node, edge
#import "@preview/gentle-clues:0.9.0": example

== The Longest Common Subsequence Problem
The @lcs problem seeks to find the maximum length of a sequence of symbols common to two lists of symbols, where the order of symbols in their original lists is maintained.
It is of interest to quantum circuit equivalence checking due to its close relation to the problem of finding the minimal edit script @myers1986diff.
An edit script is a description of the steps needed to transform one sequence of symbols into another.
It consists of three operations: Insert, remove and keep.

#example(breakable: true)[
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
