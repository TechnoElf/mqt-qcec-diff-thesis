#import "@preview/gentle-clues:0.9.0": example, code

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

