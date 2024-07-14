= Introduction
Quantum computing is poised to revolutionise the way we solve problems.
It promises to enable certain kinds of calculations and algorithms that were previously unthinkably innefficient.

A core problem in the field of quantum computing is the transformation of an abstract algorithm to sequence of operations to be executed on real quantum computing hardware.
Various factors must be considered in this process, such as the available types of operations and the geometry of the quantum computer.
Additionally, it is desireable to transform the algorithm in such a way that it can be executed with minimal noise.

To verify the functionality of a compiled quantum circuit, it is necessary to check its equivalence to the original algorithm.
@mqt provides a tool named @qcec for this purpose.
