#import "@preview/gentle-clues:0.9.0": example, code

== Post-processing of Edit Scripts
Using the implementation of the diff algorithms and the benchmarking framework, initial tests of the complete equivalence checking flow could be performed.
Naively applying gates based on the outputs of the diff algorithm generally results in a worse overall runtime for most test cases compared to the state of the art application scheme, however.

Comparing the output sequences of the proportional application scheme to that of the diff application scheme reveals a few possible reasons for this performance regression.
For instance, the diff alogrithms tend to produce large blocks of insertion or deletion operations.
This makes sense when the goal is to produce a human-readable edit script, however, this property is counterproductive for the equivalence checking flow.
A good application schemes ideally interleaves corresponding gates so that the size of the @dd remains minimal.

Based on these observations, a series of post-processing steps are introduced in an attempt to alleviate this issue.
An alternative approach would have been to develop a new diff algorithm that produces edit scripts that are more suitable to equivalence checking, however post-processing proves to be effective and efficient enough to produce the desired results.

This is possible due to the unique properties of the alternating equivalence checker based on @dd[s].
The correctness of the result only depends on all gates from both circuits being applied in the right order.
The exact sequence in which left and right gates are applied is irrelevant.
It is therefore possible to use such heuristics to modify the application sequence.

The post-proccessing steps are explained in the next sections, followed by a discussion of the final sequence that was used to achieve the best performance.

*Removing Empty Operations*

This step simply removes any operation that applies neither left nor right gates.
While this shouldn't have a great impact on performance, it does reduce the memory footprint of the array.

#example[
  As shown in @example_remove_empty_ops, entries in the sequence that contain only zeros are removed in this step.

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

*Merging Same Operations*

The edit script sometimes contained consecutive operations that apply gates from the same side.
This makes sense for a normal edit script, where operations may usually only operate on a single element, however, this restriction does not apply here.
The alternating equivalence checker can apply any number of gates in a single step.
It may therefore make sense to combine these operations wherever possible to reduce the length of the edit script.

#example[
  This step combines two consecutive operations by taking their sum.
  It does this wherever the left sides are both zero or the right sides are both zero.
  In @example_merge_same_ops, the first two operations are summed together this way.

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

*Swapping Left and Right Operations*

The idea behind this post-processing step stemmed from the uncertainty of the way @mqt @qcec handles the left and right application of gates.
If this was opposite to the expected direction, swapping the insertion and deletion operations should improve the runtime.
Applying this step, however, resulted in consistently worse runtimes.
As such, this step served as a sanity check of wether or not the algorithm was producing the correct output.
It was therefore not used in the final post processing sequence.

#example[
  @example_swap_ops demonstrates how insertion and deletion operations are swapped.
  Keep operations remain unchanged as they are symmetrical.
  This was achieved by simply swapping the first and second element of each tuple.

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

*Splitting Large Operations*

This step essentially implements the inverse of the "merging same" step.
It aims to split up large operations.
While splitting application operations like this should not affect the runtime, this step was used to develop other, more effective post-processing methods.

Two different approaches were implemented for this step.
The initial implementation iteratively split up each operation where the size was above a certain threshold.
The second implementation calculated the number of splits needed to reduce the size below a certain threshold and split the operation accordingly.

#example[
  As shown in @example_split_ops, each operation is split into two smaller operation.
  The threshold would be 1 in this case.

  #figure(
    grid(
      columns: (4fr, 1fr, 4fr),
      [$(0, 2) \ (2, 2) \ (2, 0)$],
      align(horizon)[$->$],
      [$(0, 1) \ (0, 1) \ (1, 1) \ (1, 1) \ (1, 0) \ (1, 0)$]
    ),
    caption: [Split large operations.]
  ) <example_split_ops>
]

*Merging Left and Right Operations*

When the @dd\-based equivalence checker is given an operation with both left and right gates (such as a "keep" operation in the diff), it applies the gates from either side sequentially.
This is identical to having two consecutive operations that apply gates from opposite directions.
The aim of this step is therefore to reduce the size of the edit script by combining such operations that would result in the same application order anyway.

#example[
  This step works similarly to the "merge same" step, however, it instead checks wether the opposite directions of two consecutive operations are zero.
  If this is the case, it sums them together, as shown in @example_merge_left_right_ops.

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

*Interleaving Left and Right Operations*

This is the post processing step that had the most impact on the performance of the application scheme.
It aims to split up operations, similar to the "splitting large operations" step, however, it does so only where it can interleave left and right application operations
Interleaving the operations this way is analogous to creating a diagonal step pattern in the edit graph.
This shape is exactly the path that produces the optimal sequence of applications to keep the @dd as close as possible to the identity by ensuring that each left gate is matched to a right gate.

#example[
  @example_interleave_left_right_ops demonstrates one iteration of this step with a threshold of less than 4.
  The two consecutive and opposite operations are split into four operations of which each consecutive pair has opposite application directions.

  #figure(
    grid(
      columns: (4fr, 1fr, 4fr),
      [$(4, 0)$ \ $(0, 4)$],
      align(horizon)[$->$],
      [$(2, 0) \ (0, 2) \ (2, 0) \ (0, 2)$]
    ),
    caption: [Interleaving consecutive left and right operations.]
  ) <example_interleave_left_right_ops>
]

*Final Postprocessing Steps*

Various combinations of the procedures described in the previous sections were implemented in an attempt to reduce the runtime.
Most sequences either had no discernable effect or worsened the results.

The best results were achieved with the following sequence of post processing steps:
1. Merge same operations.
2. Interleave left and right operations down to a threshold of 5 iteratively 3 times
3. Merge left and right operations
4. Remove empty operations

The rationale behind these steps is as follows:
Step one ensures that step two can work effectively.
It makes it more likely for there to be two consecutive operations that apply gates from different sides.
The second step then ensures that the @dd stays as close to the identity as possible while keeping the length of the edit script reasonably low.
Step three reduces the size of the edit script by combining operations that would have been applied in the same sequence anyway, reducing the need to query the application scheme.
The fourth step is simply there to clean up any empty operations that may be left by the merge and interleave steps.

This is the sequence that was used to benchmark the diff-based equivalence checking approach in the next section.
