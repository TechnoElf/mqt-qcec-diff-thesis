#import "@preview/fletcher:0.5.1": diagram, node, edge
#import "@preview/gentle-clues:0.9.0": example, code
#import "@preview/lovelace:0.3.0": pseudocode-list

= Implementation
== Visualisation
Initially, a visualisation of the diff algorithms applied to quantum circuits was created to assess their usefulness in equivalence checking.
Additionally, this served as exercise to better understand the algorithms to be used for the implementation in @qcec.


== QCEC Application Scheme
The Myers' Algorithm was implemented as an application scheme in @qcec.

#code[
  #figure(
    block(
      pseudocode-list[
        + *def* $"myers"()$
          + $"best_x_forward"$ *is* $"array"((m + n) * 2 + 1)$
          + $"best_x_backward"$ *is* $"array"((m + n) * 2 + 1)$
          + *for* operations *in* $0$ *to* $m + n$
            + *for* diagonal *in* $-("operations" - 2 * max(0, "operations" - m))$ *to* $"operations" - 2 * max(0, "operations" - m)$
              + $"x_position" = "max" + "diagonal"$
              + *if* $"diagonal" = -"operations"$
                + $"best_x_forward"[m + n + "diagonal"] = "best_x"[m + n + "diagonal" + 1]$
              + *else if* $"diagonal" = "operations"$
                + $"best_x_forward"[m + n + "diagonal"] = "best_x"[m + n + "diagonal" - 1]$
              + *else*
                + *if* $"best_x_forward"[m + n + "diagonal" - 1] > "best_x"[m + n + "diagonal" + 1]$
                  + $"best_x_forward"[m + n + "diagonal"] = "best_x"[m + n + "diagonal" - 1]$
                + *else*
                  + $"best_x_forward"[m + n + "diagonal"] = "best_x"[m + n + "diagonal" + 1]$
                + *end*
              + *end*
            + *end*
          + *end*
        + *end*
      ],
      width: 100%
    ),
    caption: [Myers' algorithm.]
  ) <myers_algorithm>
]

#example[
  #figure(
    diagram(
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


== QCEC Benchmarking Tool
As @qcec doesn’t have built-in benchmarks, a benchmarking tool was developed to test different configurations on various circuit pairs.

