#import "@preview/fletcher:0.5.1": diagram, node, edge
#import "@preview/gentle-clues:0.9.0": example
#import "@preview/tablex:0.0.8": tablex
#import "@preview/quill:0.3.0": quantum-circuit, lstick, rstick, ctrl, targ, mqgate, meter

= State of the Art
There are various existing approaches to equivalence checking of quantum circuits.
Two broad categories are considered here: Those that use the same @dd\-based equivalence checking methodology used in this thesis and those that use entirely different methods.
While @dd\-based equivalence checking is currently the most performant, it is worth noting that there are other approaches as well that may benefit from the ideas developed in this work @burgholzer2021ec.

== Quantum Decision Diagram Equivalence Verification
The state-of-the-art quantum circuit equiavalence checking methodology verifies that two given circuits implement the same functionality by exploiting the identity relation $f^(-1)(f(x))=x$.
The equivalence two circuits $G$ and $G'$ and their system matrices $U$ and $U'$ can be similarly stated as follows @burgholzer2021ec:

$
  G = G' &<=> U = U' \
         &<=> U dot U'^(-1) = I \
         &<=> U dot U'^dagger = I \
         &<=> g_1 dot g_2 dot ... dot g_n dot g'^dagger_m dot ... dot g'^dagger_2 dot g'^dagger_1 = I
$

The @dd\-based alternating equiavalence checker uses @dd[s] to represent the intermediate state of the system matrix as the gates are applied.
Once all gates have been applied to the @dd, it has the identity form if and only if the circuits $G$ and $G'$ have the same system matrix, thus implementing the same functionality.

Due to the associativity of the system matrices of quantum gates, the order in which gates are applied to the @dd may freely chosen, as long as the order within their respective circuits remains unaltered.
To efficiently check two quantum circuits for equivalence by reducing them to the identity circuit using a @dd thus necessitates the use of an application scheme which determines the order in which gates are to be applied to the @dd.
The aim of these schemes is to determine a sequence that keeps the @dd as close as possible to the identity as possible @burgholzer2021ec.

There are a variety of existing approaches to providing a suitable oracle for quantum circuit equivalence checking based on @dd[s].
@qcec currently implements gate-cost, lookahead, one-to-one, proportional and sequential application schemes @burgholzer2021ec.
The following example illustrates the functionailty of each of these schemes.

#example(breakable: true)[
  Consider the two circuits in @circuit_g that implement the same system matrix $U$.

  #figure(
    [
      #grid(
        columns: (4fr, 1fr, 2fr),
        align(horizon, quantum-circuit(
          lstick($|q_0〉$), $H$, 1, 1, [\ ],
          lstick($|q_1〉$), 1, $X$, 1
        )),
        align(horizon)[$<=>$],
        align(horizon)[$U = 1/sqrt(2) mat(
          0, 1, 0, 1;
          1, 0, 1, 0;
          0, 1, 0, -1;
          1, 0, -1, 0
        )$]
      )
      #grid(
        columns: (4fr, 1fr, 2fr),
        align(horizon, quantum-circuit(
          lstick($|q_0〉$), $"S"$, $sqrt(X)$, $"S"$, 1, [\ ],
          lstick($|q_1〉$), 1, 1, 1, $X$, 1
        )),
        align(horizon)[$<=>$],
        align(horizon)[$U' = 1/sqrt(2) mat(
          0, 1, 0, 1;
          1, 0, 1, 0;
          0, 1, 0, -1;
          1, 0, -1, 0
        )$]
      )
    ],
    caption: [Quantum circuit $G$ and $G'$.]
  ) <circuit_g>

  The matrices can be trivially verified for equivalence showing that $G$ and $G'$ do indeed implement the same functionality.
  This approach, however, is impractical in practice as the size of the system matrix grows exponentially with the number of qubits in the circuit.

  To verify the equivalence of $G$ and $G'$ using the @dd\-based alternating equivalence checking methodology, the latter must first be inverted to produce $G'^dagger$.
  @circuit_g_dagger visualises this circuit.
  In this case $G'^dagger$ happens to have the same system matrix as $G'$ because $G'$ is symmetric, but this is not necessarily always the case.

  #figure(
    grid(
      columns: (4fr, 1fr, 3fr),
      align(horizon, quantum-circuit(
        lstick($|q_0〉$), 1, $"S"^dagger$, $sqrt(X)^dagger$, $"S"^dagger$, 1, [\ ],
        lstick($|q_1〉$), $X^dagger$, 1, 1, 1
      )),
      align(horizon)[$<=>$],
      align(horizon)[$(U')^(-1) = U'^dagger = 1/sqrt(2) mat(
        0, 1, 0, 1;
        1, 0, 1, 0;
        0, 1, 0, -1;
        1, 0, -1, 0
      )$]
    ),
    caption: [$G'^dagger$, the inverse of $G'$.]
  ) <circuit_g_dagger>

  These two circuits can now be concatenated to produce the identity, as demonstrated in @circuit_identity.

  #figure(
    grid(
      columns: (4fr, 1fr, 3fr),
      align(horizon, quantum-circuit(
        lstick($|q_0〉$), $H$, 1, 1, $"S"^dagger$, $sqrt(X)^dagger$, $"S"^dagger$, 1, [\ ],
        lstick($|q_1〉$), 1, $X$, $X^dagger$, 1, 1, 1
      )),
      align(horizon)[$<=>$],
      align(horizon)[$U dot U'^dagger =  mat(
        1, 0, 0, 0;
        0, 1, 0, 0;
        0, 0, 1, 0;
        0, 0, 0, 1
      ) = I$]
    ),
    caption: [The combination of $G$ and $G'^dagger$ produces the identity, thus proving their equivalence.]
  ) <circuit_identity>

  As the resulting circuit implements the identity function, this approach thereby proves the equivalence of the two input circuits.
  The system matrix is instead represented by a @dd in the state-of-the-art equivalence checking method, which usually results in a much more compact representation than the initial approach of comparing the system matrices of the two circuits.

  The approach presented thus far will, however, also always result in the full construction of circuit $G$ in the intermediate @dd.
  This is an improvement over fully constructing the system matrices for both circuits, but may still result in an exponentially sized @dd.
  To avoid this issue, the gates can instead be applied using one of the application schemes shown in @application_schemes. 
  By applying parts of the two circuits in sequence, it is possible to further reduce the size of the @dd.

  The tuples $(a, b)$ used in the table signify a single application step where $a$ gates are applied from the first circuit ($G$), followed by $b$ gates from the second inverted circuit ($G'^dagger$).
  The sequential application scheme is therefore identical to the naive scheme presented above.

  #figure(
    tablex(
      columns: (1fr, 1fr, 1fr, 1fr, 1fr),
      [*One-to-one*], [*Sequential*], [*Proportional*], [*Lookahead*], [*Gate-cost*],
      align(center, [$\ (1, 1) \ (1, 1) \ (0, 2)$]),
      align(center, [$\ (2, 4)$]),
      align(center, [$\ (1, 2) \ (1, 2)$]),
      align(center, [? \ (depends on the implementation of the @dd)]),
      align(center, [? \ (depends on the implementation of the @dd)])
    ),
    caption: [Different state-of-the-art application schemes.]
  ) <application_schemes>

  Using the proportional application scheme, for instance, produces the circuit in @application_scheme_prop, which also implements the identity function.
  Applying the gates to the @dd in this order helps to keep its average size low.
  This is also the scheme that is used in @mqt @qcec by default.

  #figure(
    quantum-circuit(
      lstick($|q_0〉$), $H$, 1, $"S"^dagger$, 1, $sqrt(X)^dagger$, $"S"^dagger$, 1, [\ ],
      lstick($|q_1〉$), 1, $X^dagger$, 1, $X$, 1, 1
    ),
    caption: [The circuit produced by the proportional application scheme.]
  ) <application_scheme_prop>
]

== Other Verification Methods
Besides reducing a @dd to the identity, alternative methods for verifying equivalent functionality of quantum circuits exist. One approach involves the use of ZX-calculus @kissinger2020pyzx.

Additionally, in the case of proving non-equivalence, it is sufficient to find inputs that produce different outputs.
In this case, it is usually more efficient to simulate such a case on both circuits and compare the outputs.
@qcec makes use of this fact by initially running three simulation instances using random inputs @burgholzer2021ec.
Only if the simulation runs each produce identical outputs is another verification method attempted.

While these alternative verification methods present interesting perspectives on quantum circuit equivalence checking, they are difficult to compare directly to the @dd\-based approach.
They are therefore not used in the comparisons of equiavalence checking methodologies portrayed in this work.
It may, however, be worth considering the impact that the developed methods may have on these as part of future work.

