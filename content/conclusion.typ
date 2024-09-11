= Conclusion
In this thesis, a novel approach to @dd\-based quantum circuit equivalence checking was developed.
This approach uses the fact that a system matrix multiplied by its inverse produces the identity.
Gates from either circuit are sequentially applied to the @dd, which is reduced to the identity if the circuits are equivalent.
Using solutions to the @lcs problem, commonly known as diff algorithms, a scheme was developed that seeks to keep the system's @dd as close to the identity as possible by exploiting structural similarities in the circuits.

Over the course of the work, Djikstra's algorithm, Myers' algorithm and the patience algorithm were analysed and implemented.
The functionality was demonstrated using a visualisation tool, which also highlighted the structural relationship between circuits at different stages of compilation.
Myers' algorithm and the patience algorithm were subsequently integrated into @mqt @qcec and successfully applied to the equivalence checking problem.
Finally, a specialised benchmarking tool was developed for @mqt @qcec to compare application schemes using benchmark instances generated by @mqt Bench.

Despite the extensive exploration, the results of this work are mixed.
While significant speed ups have been demonstrated, most of the explored approaches tend to cause significant regressions in the run time of the equivalence checking procedure.

Specifically, the proposed application scheme based on a processed edit script produced by the Myers' algorithm can speed up equivalence checking by almost 60% in the right circumstances.
In many other cases, however, it fails to provide any meaningful speedup or even significantly slows down computation by a factor of up to 400%.
While there is no apparent correlation between the easily analysable properties of the circuits and the runtime improvement of using a diff-based application scheme, a heuristic based on the gate equivalence rate of the two circuits manages to filter out most bad instances.

The culmination of this work is an application scheme that can be applied selectively to accomplish an average speedup of 7.09% compared to the state-of-the-art application scheme.

