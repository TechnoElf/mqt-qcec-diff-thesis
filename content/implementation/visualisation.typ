== Visualisation
Initially, a visualisation of the diff algorithms applied to quantum circuits was created to assess their usefulness in equivalence checking.
Additionally, this served as exercise to better understand the algorithms to be used for the implementation in @qcec.

#figure(
  image("../../resources/kaleidoscope-grover.png", width: 80%),
  caption: [A quantum circuit implementing Grover's algorithm loaded into kaleidoscope. If a gate has parameters, these are shown when hovering over it.]
) <kaleidoscope-grover>

#figure(
  image("../../resources/kaleidoscope-diff-grover.png", width: 80%),
  caption: [Kaleidoscope showing the diff of two optimisation levels of a circuit implementing Grover's algorithm.]
) <kaleidoscope-diff-grover>

#figure(
  image("../../resources/kaleidoscope-diff-shor.png", width: 80%),
  caption: [Kaleidoscope showing the diff of two circuits implementing two different instances of Shor's algorithm.]
) <kaleidoscope-diff-shor>

Kaleidoscope uses an unoptimised implementation of Myers' algorithm.
Despite this, it can process the Shor's algorithm circuits in under three seconds.
This was sufficient evidence that an implementation of the algorithm in qcec was viable.

