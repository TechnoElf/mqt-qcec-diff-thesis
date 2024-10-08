#import "@preview/tablex:0.0.8": tablex, rowspanx, colspanx, cellx
#import "@preview/unify:0.6.0": qty

== Visualisation
A visualisation of the diff algorithms applied to quantum circuits was created to assess their usefulness in equivalence checking.
Specifically, the tool was meant to demonstrate that diff algorithms produce meaningful output when applied to the same circuit at different optimisation levels.
Additionally, this served as exercise to better understand the algorithms to be used for the implementation in @qcec.

The tool is named Kaleidoscope and consists of a framework for loading quantum circuit file formats and manipulating them and a @gui for displaying comparisons between circuits.
For the implementation, Rust was chosen as the programming language and Dear ImGUI as the user interface framework.
No additional libraries (called "crates" in the Rust language) are used.
While crates for quantum computation do exist (for instance, `qoqo` @bark2021qoqo or `qasm` @kelly2018qasm), these are unsuitable due to their inflexibility and a lack of a suitable representation to apply diff algorithms to.
Instead, a representation of quantum circuits based on sequences of gates was developed specifically for the Kaleidoscope framework.

Using this representation, a parser for the OpenQASM 2.0 format @cross2017qasm, which is also used by @qcec and @mqt bench, was developed to allow interoperability with these tools.
The parser does not implement the full OpenQASM 2.0 specification and instead focuses on a subset of operations found in the circuits generated by @mqt bench.

Additionally, a visual representation of the circuit was developed.
This allows the exploration of the varying properties that different diff algorithms may have.
@kaleidoscope_grover shows a sample circuit loaded into Kaleidoscope.

#figure(
  image("../../resources/kaleidoscope-grover.png", width: 80%),
  caption: [A quantum circuit implementing Grover's algorithm loaded into Kaleidoscope. If a gate has parameters, these are shown when hovering over it.]
) <kaleidoscope_grover>

The framework also includes a general representation of an edit graph built from two quantum circuits, to allow simple adaptation of existing diff algorithms.
Using this framework, Djikstra's algorithm was implemented @djikstra1959shortest.
@kaleidoscope_diff_grover demonstrates the application of the algorithm to a small instance of Grover's algorithm with 3 qubits, mapped to the native gate set of the IBM Washington target using Qiskit at optimisation levels 0 and 3.

#figure(
  image("../../resources/kaleidoscope-diff-grover.png", width: 80%),
  caption: [Kaleidoscope showing the diff of two optimisation levels of a circuit implementing Grover's algorithm. The lower window shows the edit script to transform circuit A into circuit B. Red gates (those that are present in A, but not B) are removed and green gates (those that are present in B, but not A) are added.]
) <kaleidoscope_diff_grover>

Djikstra's algorithm does not scale well to practical quantum circuits, however.
The quadratic growth in runtime proved to make comparing even circuits on the order of thousands of gates take multiple seconds.
Considering that the calculation of the edit script would only be a pre-processing step to the actual equivalence check, this is unacceptable.
Subsequently, three different versions of Myers' algorithm were implemented, each with a progressively lower level of abstraction.
This approach was taken to make the functionality of the algorithm easier to follow as the relation of the pseudocode given in Myers' paper to the abstract algorithm is not immediately clear @myers1986diff.
Version 1 is thus closest to the abstract algorithm and version 3 is closest to Myers' pseudocode.

Each of these versions was benchmarked using randomly generated sequences consisting of alphanumeric characters.
The benchmarks were built and run on a NixOS 24.11 system with rustc 1.81.0.
The system consists of an Intel Core i5-1240P with 32 GiB of RAM.
@kaleidoscope_runtime shows a comparison between the results for the different diff algorithm implementations in Kaleidoscope.

#figure(
  tablex(
    columns: (2fr, 1fr, 1fr, 1fr),
    rowspanx(2)[*Algorithm*], colspanx(3)[*Run time for an $n$ by $n$ edit graph*], (), (),
    (), [$n=10$], [$n=100$], [$n=1000$],
    [Djikstra's], cellx(align: right)[$qty("3979", "ns")$], cellx(align: right)[$qty("2352516", "ns")$], cellx(align: right)[$qty("2230049065", "ns")$],
    [Myers' (Version 1)], cellx(align: right)[$qty("3396", "ns")$], cellx(align: right)[$qty("907375", "ns")$], cellx(align: right)[$qty("1163141162", "ns")$],
    [Myers' (Version 2)], cellx(align: right)[$qty("1994", "ns")$], cellx(align: right)[$qty("236898", "ns")$], cellx(align: right)[$qty("124349238", "ns")$],
    [Myers' (Version 3)], cellx(align: right)[$qty("1784", "ns")$], cellx(align: right)[$qty("88573", "ns")$], cellx(align: right)[$qty("21964467", "ns")$]
  ),
  caption: [Run time of different diff Algorithm implementations on random sequences of gates with varying lengths.]
) <kaleidoscope_runtime>

@kaleidoscope_runtime also highlights the trade off between abstraction and performance.
Version 3 of Myers' algorithm is able to process circuits on the order of 10000 gates in just a few seconds, an improvement of two orders of magnitude over the initial implementation of Djikstra's algorithm.
Version 3 is, however, still not an optimal solution.
It makes heavy use of dynamically allocated memory, as this is more convenient to implement.
It also uses a 2D array of the entire edit graph in order reconstruct the edit script, which requires an unreasonable amount of memory for larger circuits.
Despite this, the approach was now sufficient to find the diff between two instances of Shor's algorithm, as demonstrated in @kaleidoscope_diff_shor.

#figure(
  image("../../resources/kaleidoscope-diff-shor.png", width: 80%),
  caption: [Kaleidoscope showing the diff of two circuits implementing two different instances of Shor's algorithm.]
) <kaleidoscope_diff_shor>

Using the tool, it is possible to compare practical quantum circuits and analyse their edit scripts.
This was deemed sufficient evidence that an implementation of the algorithm in @qcec would be viable.

