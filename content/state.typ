= State of the Art
== Existing Application Schemes
To efficiently check two quantum circuits for equivalence by reducing them to the identity circuit using a @dd necessitates the use of an application scheme which determines the order in which gates are to be applied to the @dd.
The aim of these schemes is to determine a sequence that keeps the @dd as close as possible to the identity as possible @burgholzer2021ec.

There are a variety of existing approaches to providing a suitable oracle for quantum circuit equivalence checking based on @dd[s].
@qcec currently implements gate-cost, lookahead, one-to-one, proportional and sequential application schemes @burgholzer2021ec.


== Other Verification Methods
Besides reducing a @dd to the identity, alternative methods for verifying equivalent functionality of quantum circuits exist. One approach involves the use of ZX-calculus @kissinger2020pyzx.

Additionally, in the case of proving non-equivalence, it is sufficient to find inputs that produce different outputs. In this case, it is usually more efficient to simulate such a case on both circuits and compare the outputs. @qcec makes use of this fact by initially running three simulation instances using random inputs @burgholzer2021ec. Only if the simulation runs each produce identical outputs is another verification method attempted.


