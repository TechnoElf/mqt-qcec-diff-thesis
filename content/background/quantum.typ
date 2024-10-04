#import "@preview/cetz:0.2.2": canvas, draw
#import "@preview/gentle-clues:0.9.0": example
#import "@preview/quill:0.3.0": quantum-circuit, lstick, rstick, ctrl, targ, mqgate, meter
#import "@preview/tablex:0.0.8": tablex

== Quantum Computation and Quantum Circuits
A quantum computer is a device that performs calculations by using certain phenomena of quantum mechanics @nielsen2010quantum.
The algorithms that run on this device are specified in quantum circuits.
Quantum circuits consist of quantum gates that operate sequentially on a set of qubits.
Quantum circuits, quantum gates and qubits function analogous to their classical counterparts in electronics.

Unlike classical gates and bits, however, quantum gates and qubits have the ability to operate on quantum states.
Whereas classical computers operate on the binary states '0' and '1', quantum computers operate on linear combinations of these states by exploiting a phenomenon from quantum mechanics known as superposition.
It is this simultaneity of classical states in quantum computers that can give them an edge over classical computers for certain problems.

#figure(
  canvas({
    import draw: *
    scale(1)

    circle((0, 0, 0), radius: 2)
    group({rotate(x: 90deg); circle((0, 0, 0), radius: 2)})
    group({rotate(y: 90deg); circle((0, 0, 0), radius: 2)})
    circle((0, 0, 0), radius: 0.1, fill: black)
    
    line((0, 0, 0), (0, 0, -1.5), mark: (end: ">"), name: "x")
    line((0, 0, 0), (1.5, 0, 0), mark: (end: ">"), name: "y")
    line((0, 0, 0), (0, 1.5, 0), mark: (end: ">"), name: "z")

    content("x.end", anchor: "north", [x])
    content("y.end", anchor: "west", [y])
    content("z.end", anchor: "south", [z])

    content((0, 2.5, 0), [|0〉])
    content((0, -2.5, 0), [|1〉])
  }),
  caption: [A Bloch sphere.]
) <example_bloch>

Qubits are usually represented in one of three forms shown in @example_vec and @example_bloch.
The Bloch sphere is a good visualisation for the superposition that can occur in a single qubit.
Besides the two basis states (usually called |0〉 and |1〉) it is possible for the qubit to have any value on the surface of the sphere.
These quantum states can be mapped to classical states by projecting them onto the z axis.
This corresponds to a probability of either state being observed in a real quantum system.
The coefficients $alpha$ and $beta$ thus also correspond to the probability of either basis state being measured when the state is observed.

#figure(
  [$alpha|0〉 + beta|1〉$ #h(2em) $vec(alpha, beta)$],
  caption: [A qubit in algebraic and vector notation.]
) <example_vec>

The Bloch sphere is, however, not suitable for demonstrating entanglement; another phenomenon from quantum mechanics that is essential to quantum computation.
Abstractly, entanglement refers to the ability of single qubit states to depend on the state of other qubits.
To show entanglement of qubits, it is necessary to fall back on the algebraic or vector notation.
@example_vec2 shows two-qubit system in these forms.

#figure(
  [$alpha_00|00〉 + alpha_01|01〉 + alpha_10|10〉 + alpha_11|11〉$ #h(2em) $vec(alpha_00, alpha_01, alpha_10, alpha_11)$],
  caption: [Two qubits in algebraic and vector notation.]
) <example_vec2>

Instead of two basis states, there are now four representing each permutation of possible classical states of the two qubits.
An example for an entangled state in this system would be $frac(1, sqrt(2))|00〉 + 0|01〉 + 0|10〉 + frac(1, sqrt(2))|11〉$.
If the first qubit where to be measured in this system, we would also know the classical state of the second qubit; A measured '0' would imply a '0' for the other qubit as the probabilities for all other states are $0$.

Additionally, there are a few important restrictions on quantum states and quantum operations that stem from quantum mechanics.
Unlike classical electronic circuits, from which this analogy is derived, quantum circuits must have the same number of inputs as outputs.
They may also not contain loops.
These restrictions are summarised in the reversibility constraint @nielsen2010quantum.

Besides being reversible, quantum gates must also be unitary.
Quantum states must also be normalised, a condition which is satisfied by the requirement for unitary operations.

#example(breakable: true)[
  @example_qc_dj shows a simple quantum circuit that implements a specific quantum algorithm.
  The Deutsch, or, more generally, the Deutsch-Jozsa algorithm, solves the problem of determining whether a function is constant or balanced @deutsch1992quantum.
  A constant function produces the same output for all inputs, whereas a balanced function produces a '0' for half of all possible inputs and a '1' for the other.
  The Deutsch algorithm does this for any boolean function with a single bit input and the Deutsch-Jozsa algorithm generalises this to any number of bits.
  While there are currently no known applications for this algorithm, it serves as a good example for the capability of quantum computation to outperform classical computation.

  #figure(
    quantum-circuit(
      lstick($|0〉$), $H$, mqgate($U$, n: 2, width: 5em, inputs: ((qubit: 0, label: $x$), (qubit: 1, label: $y$)), outputs: ((qubit: 0, label: $x$), (qubit: 1, label: $y plus.circle f(x)$))), $H$, meter(), [\ ],
      lstick($|1〉$), $H$, 1, 1, 1
    ),
    caption: [A quantum circuit implementing the Deutsch-Jozsa algorithm]
  ) <example_qc_dj>

  The input may be represented as a state vector $S_1$ corresponding to the state $0|00〉 + 1|01〉 + 0|10〉 + 0|11〉$.
  The leftmost Hadamard gates may in turn be represented as the unitary matrix $U_1$.

  $ S_1 = vec(0, 1, 0, 0) #h(1cm) U_1 = frac(1, sqrt(2)) mat(1, 1; 1, -1) times.circle frac(1, sqrt(2)) mat(1, 1; 1, -1) = frac(1, 2) mat(1, 1, 1, 1; 1, -1, 1, -1; 1, 1, -1, -1; 1, -1, -1, 1) $

  Multiplying these yields the state vector $S_2$. The oracle $U$ has the unitary matrix $U_U$. 

  $ S_2 = frac(1, 2) vec(1, -1, 1, -1) #h(1cm) U_U = mat(overline(f(0)), f(0), 0, 0; f(0), overline(f(0)), 0, 0; 0, 0, overline(f(1)), f(1); 0, 0, f(1), overline(f(1))) $

  Applying this again to the preceding state vector results in the new state vector $S_3$.
  The rightmost Hadamard gate is described by the matrix $U_2$.

  $ S_3 = frac(1, 2) vec(overline(f(0)) - f(0), f(0) - overline(f(0)), overline(f(1)) - f(1), f(1) - overline(f(1))) #h(1cm) U_2 = frac(1, sqrt(2)) mat(1, 1; 1, -1) times.circle mat(1, 0; 0, 1) = frac(1, sqrt(2)) mat(1, 0, 1, 0; 0, 1, 0, 1; 1, 0, -1, 0; 0, 1, 0, -1) $

  This results in the final state vector $S_4$.

  $ S_4 = frac(1, 2 sqrt(2)) vec(overline(f(0)) - f(0) + overline(f(1)) - f(1), f(0) - overline(f(0)) + f(1) - overline(f(1)), overline(f(0)) - f(0) - overline(f(1)) + f(1), f(0) - overline(f(0)) - f(1) + overline(f(1))) $

  This vector cannot be split into the individual qubits, so the following table shows all possible output states for each realisation of $f$.

  #tablex(
    columns: (1fr, 1fr, 6fr, 2fr),
    [*f(0)*], [*f(1)*], [*Output State*], [*Measurement*],
    [$0$], [$0$], [$frac(1, sqrt(2))|00〉 - frac(1, sqrt(2))|01〉 + 0|10〉 + 0|11〉$], [$0$],
    [$0$], [$1$], [$0|00〉 + 1|01〉 + frac(1, sqrt(2))|10〉 - frac(1, sqrt(2))|11〉$], [$1$],
    [$1$], [$0$], [$0|00〉 + 1|01〉 - frac(1, sqrt(2))|10〉 + frac(1, sqrt(2))|11〉$], [$1$],
    [$1$], [$1$], [$-frac(1, sqrt(2))|00〉 + frac(1, sqrt(2))|01〉 + 0|10〉 + 0|11〉$], [$0$]
  )

  Observing the possible measurements, it is clear that this circuit does indeed satisfy the problem statement given by Deutsch.
  When the function is balanced (produces the same number of '0' outputs as '1' outputs), the measurement is '1', whereas a constant function (the output is always '0' or '1') is measured as '0'.

  Initially, this example may seem counter intuitive.
  Computing the output of the quantum circuit necessitated the computation of all possible outputs of $f$ in addition to multiple matrix / vector multiplications and processing of state vectors.
  It would therefore appear that the quantum implementation of this algorithm is less efficient than the classical solution.
  This observation, however, disregards the fact that the above calculation solved the problem for all possible $f$.
  Additionally, an implementation of this algorithm on real quantum hardware would only have to evaluate the gate $U$ and thus the function $f$ once.
  This highlights the inefficiency of simulating quantum circuits on classical hardware, a problem that grows exponentially with the number of qubits.
  
  Another conclusion that can be drawn from this is that it is therefore ineffective to verify the functionality of quantum circuits through plain simulation.
  More effective methods will be discussed in this thesis.
]
