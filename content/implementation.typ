#import "@preview/gentle-clues:0.9.0": example, code

= Implementation
#include "implementation/algorithms.typ"

== Visualisation
Initially, a visualisation of the diff algorithms applied to quantum circuits was created to assess their usefulness in equivalence checking.
Additionally, this served as exercise to better understand the algorithms to be used for the implementation in @qcec.


== QCEC Application Scheme
The Myers' Algorithm was implemented as an application scheme in @qcec.


== QCEC Benchmarking Tool
As @qcec doesn’t have built-in benchmarks, a benchmarking tool was developed to test different configurations on various circuit pairs.


== Postprocessing of Edit Scripts
=== Removing Empty Operations
#example[
  #figure(
    grid(
      columns: (4fr, 1fr, 4fr),
      [$(0, 2) \ (0, 0) \ (2, 2) \ (0, 0) \ (2, 0)$],
      align(horizon)[$->$],
      [$(0, 2) \ (2, 2) \ (2, 0)$]
    ),
    caption: [Removing empty operations.]
  ) <example_remove_empty_ops>
]

=== Merging Same Operations
#example[
  #figure(
    grid(
      columns: (4fr, 1fr, 4fr),
      [$(0, 1) \ (0, 1) \ (2, 2) \ (2, 0)$],
      align(horizon)[$->$],
      [$(0, 2) \ (2, 2) \ (2, 0)$]
    ),
    caption: [Merging same operations.]
  ) <example_merge_same_ops>
]

=== Swapping Left and Right Operations Operations
#example[
  #figure(
    grid(
      columns: (4fr, 1fr, 4fr),
      [$(0, 2) \ (2, 2) \ (2, 0)$],
      align(horizon)[$->$],
      [$(2, 0) \ (2, 2) \ (0, 2)$]
    ),
    caption: [Swapping left and right operations.]
  ) <example_swap_ops>
]

=== Splitting Large Operations
#example[
  #figure(
    grid(
      columns: (4fr, 1fr, 4fr),
      [$(0, 2) \ (2, 2) \ (2, 0)$],
      align(horizon)[$->$],
      [$(1, 0) \ (1, 0) \ (1, 1) \ (1, 1) \ (0, 1) \ (0, 1)$]
    ),
    caption: [Split large operations.]
  ) <example_split_ops>
]

=== Merging Left and Right Operations
#example[
  #figure(
    grid(
      columns: (4fr, 1fr, 4fr),
      [$(0, 1) \ (1, 1) \ (1, 0) \ (1, 1) \ (0, 1) \ (1, 0)$],
      align(horizon)[$->$],
      [$(0, 1) \ (1, 1) \ (1, 0) \ (1, 1) \ (1, 1)$]
    ),
    caption: [Merging consecutive left and right operations.]
  ) <example_merge_left_right_ops>
]

=== Interleaving Left and Right Operations
#example[
  #figure(
    grid(
      columns: (4fr, 1fr, 4fr),
      [$(4, 0)$ \ $(0, 4)$],
      align(horizon)[$->$],
      [$(2, 0) \ (0, 2) \ (2, 0) \ (0, 2)$]
    ),
    caption: [Interleaving consecutive left and right operations.]
  ) <example_merge_left_right_ops>
]

=== Final Postprocessing Steps



