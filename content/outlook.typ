= Outlook
Over the course of this thesis, many aspects of the application of diff algorithms to quantum circuit equivalence checking have been explored.
This work, however, also opens various avenues of future exploration.

One possible path is the development of new diff and diff-like algorithms that are better suited as a heuristic for the verification problem.
It may, for instance, be possible to modify edit graphs using quantum identities to create further possibilities for matches and thus reduce the length of resulting edit scripts.
This could improve the predictions of the application scheme.

Additionally, the diff-based application scheme considers quantum circuits as lists of gates.
In contrast to this, quantum circuits are usually represented by two-dimensional structures, such as matrices, @dd[s] or ZX-diagrams.
For instance, quantum circuits are often visualised as a two-dimensional grid where gates may be rearranged horizontally as long as the ordering of operations on individual qubits remains the same.
Such information on the positioning of the gate is unfortunately lost with the current approach.

Similarly, it may be beneficial to explore further possibilities of modifying the output of a diff algorithm for suitability to the quantum circuit verification task.
While a few permutations of possible post-processing functions have been tested in this work, the entire solution space is much more expansive.

Furthermore, the applicability of a heuristic approach as explored here should be explored with regards to other quantum circuit equivalence checking methodologies.
For example, the ZX-calculus uses a very similar method for verification as used in conjunction with @dd[s].
In any approach that relies a certain order of operations to maintain efficiency, the solution explored here may be of some use.

In general, it is fair to conclude that the development of better application schemes has mostly been unexplored thus far.
This technology, however, is crucial to the progress of current equivalence checking schemes, which are in turn indispensible for the creation of more effective quantum circuit optimisation methods.
The work presented here is a small step in that direction.
//In the end, however, the real application schemes were the friends that were made along the way.

