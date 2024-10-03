#import "@preview/lovelace:0.3.0": pseudocode-list

== QCEC Application Scheme
Based on the lessons learnt from Kaleidoscope, the Myers' algorithm was implemented as an application scheme in @mqt @qcec.
This was accomplished by adding appropriate C++ classes and extending the existing functionality for configuring equivalence checking runs.

=== The `DiffApplicationScheme` Class
In general, @qcec is written in a very flexible manner.
The software enables additional application schemes to be added by inheriting a class called `ApplicationScheme`, that is templated with the current equivalence checking configuration.
This class has a single virtual method which must be implemented, namely the `()` operator.
This method returns a `std::pair` of `usize`, which specifies the number of gates to be applied from the left and right respectively in a single cycle.
As such, the summed up outputs of the method must eventually be equal to the number of gates in either circuit.

The @dd\-based alternating equivalence checker repeatedly calls `operator()` on the chosen application scheme and passes the result to two `TaskManager` instances using the `advance()` method.
These each have a reference to a different quantum circuit.
Both also have a reference to a single `DDPackage`, which holds a representation of the current @dd.
The `advance()` method then applies the specified number of gates from the respective circuit to the `DDPackage`.
One of the `TaskManager`s is configured to apply the inverse of each gate in reverse order, thereby implementing the alternating equivalence checking approach.
When the circuits are equivalent and the application scheme has applied all gates, the `DDPackage` holds a representation of the identity after this process.

A class named `DiffApplicationScheme` implements the adaptation of edit script calculation into @qcec.
The diff itself is calculated in the constructor and cached, in order to speed up the equivalence checking flow.
The implementation of `operator()` then returns the value contained in the cache based on an index that is incremented with each call.
This ensures that the entire edit script is eventually returned to the `DDAlternatingChecker` and that all gates in the two circuits are applied.
@diff_appl_scheme_class outlines the structure of this class.

#figure(
  block(
    pseudocode-list[
      + *class* $"DiffApplicationScheme"$
        + $"editScript"$ is a list of pairs
        + $"counter"$ is a positive integer
        + *def* $"init"(a, b)$
          + $"editScript" = "myersDiff"(a, b)$ 
          + $"counter" = 0$ 
        + *end*
        + *def* $"operator()"()$
          + *return* $"getNextOperation"()$
        + *end*
        + *def* $"getNextOperation"()$
          + *if* $"counter" <$ length of $"editScript"$
            + $"counter" "+=" 1$
            + *return* $"editScript"["counter" - 1]$
          + *else*
            + *return* $(0, 0)$
          + *end*
        + *end*
      + *end*
    ],
    width: 100%
  ),
  caption: [The Structure of the `DiffApplicationScheme` class.]
) <diff_appl_scheme_class>

The calculation of the diff itself is performed by a method named `myersDiff()`.
It calls another method named `myersDiffRecursive()` implementing the algorithm as discussed in the previous sections with appropriate parameters to retrieve a full edit script of the two circuits.
Furthermore, it performs post processing of the edit script to make it suitable for use with the `operator()`.

The patience diff algorithm was also implemented in a method named `patienceDiff()` that had a structure analogous to `myersDiff()`.
This method is not used by the `DiffApplicationScheme` however, as the results were found to be very similar to that of `myersDiff()`.

=== Configuration Changes
Besides adding the class for the diff-based application scheme, other areas of the @qcec code needed adjustment to integrate it into the codebase.
For instance, the `ApplicationSchemeType` enum and its utility functions were extended to allow representation of the new class.
Additionally, the `DDEquivalenceChecker` class had to be extended with a special case for the `DiffApplicationScheme`.
Compared to the other application schemes, it has the unique requirement of needing access to a representation of both circuits in their entirety.
This was solved by simply passing references to the `TaskManager`s, which the `DDEquivalenceChecker` owns, to the `DiffApplicationScheme` when it is constructed.
This approach is sound as the application scheme instance is also owned by the `DDEquivalenceChecker`.

=== Tests
Testing of software is vital to ensure its functionality while being maintained by multiple people over long periods of time.
@qcec provides facilites for automating this process and indeed performs these checks on each new contribution to the code.
To ensure the functionality of the diff application scheme in the same manner, tests were added covering these new code paths.

Specifically, the `SimpleCircuitIdentitiesTest` was extended with a diff-based configuration.
This test ensures that the equivalence checker works for 8 simple circuit pairs.
While this does not ensure the correctness of the generated edit scripts, it performs well as a sanity check for the functionality of the application scheme.
For the test to pass, the sum of the output of the application scheme must cover both circuits in their entirety, thus ensuring a minimum level of functionality.

