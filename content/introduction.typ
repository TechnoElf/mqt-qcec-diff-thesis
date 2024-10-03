= Introduction
Quantum computing is poised to revolutionise the way we solve problems.
It promises to enable certain kinds of calculations and algorithms that were previously unthinkably inefficient @nielsen2010quantum.
The technology enables a kind of probabilistic approach to computation that allows an extremely efficient parallelisation of certain algorithms.

One key application of quantum computers is their potential use in chemistry due to their inherent ability to simulate quantum systems @mcardle2020chem.
For instance, a circuit structure known as a @vqe is able to solve for the ground state of a given physical quantum system, a task that would be classically impossible within a reasonable time frame. 
Similar techniques can be applied to various optimisation problems in other fields.

A core problem in the field of quantum computing is the transformation of an abstract algorithm to sequence of operations to be executed on real quantum computing hardware.
Various factors must be considered in this process, such as the available types of operations and the geometry of the quantum computer.
Additionally, it is desirable to transform the algorithm in such a way that it can be executed with minimal noise.
A plethora of software tools exist for this purpose, notably the @mqt @wille2024mqthandbook.

As these "quantum compilers" become more intricate and more optimisation techniques are employed, it becomes harder to verify that their output implements the same functionality as the original circuit.
This makes the development of new compilation methodologies increasingly difficult, as the reliability becomes difficult to prove numerically.
To verify the functionality of a compiled quantum circuit, it is therefore necessary to check its equivalence to the original algorithm automatically.
@mqt provides a tool named @qcec for this purpose.

This work extends @qcec with a novel variation of the existing verification flow based on @dd[s].
Specifically, an application scheme is developed for the alternating @dd equivalence checker based on algorithms originally intended for solving the @lcs problem (so called "diff" algorithms).
This approach thereby exploits the structural similarity that is present in quantum circuits at different stages of compilation.
Additionally, a heuristic is developed that can discern, whether or not this new approach can reduce the run time of the state-of-the-art flow for any given pair of circuits.
When combined, these new approach results in run time improvements of up to $59%$ in some cases, with an average improvement of $7%$.

The remainder of the thesis is structured as follows:
In section 2, the concepts required to understand the developed methods will be elaborated.
Section 3 will then present the current state of quantum circuit verification schemes.
Following this, section 4 will discuss the algorithms themselves and their application to @qcec.
Next, section 5 will present the results of applying the new equivalence checking methodology to real-world problems and detail the procedure used to acquire them.
Section 6 will discuss the results and draw conclusions from them.
Finally, section 7 will judge the impact of this work as a whole and suggest future pathways of exploration.

