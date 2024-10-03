== QCEC Benchmarking Tool
Besides testing the newly developed approaches for correctness, possible performance regressions should be monitored as well.
@qcec does not have built-in benchmarks, however.
For this purpose, a benchmarking tool was therefore developed to test different configurations of the equivalence checker on various circuit pairs. 
This is necessary to show the quantitative improvement gained by using different application schemes.
Two different approaches were implemented, which will be discussed in the following sections.

=== Google Benchmark
The Google Benchmark framework was initially used to develop benchmarks for @mqt @qcec.
The benchmarks generally had the following procedure.
First, the equivalence checker was configured.
The application scheme was set to either the proportional or diff approach according to the benchmark definition.
Next, the circuits were loaded according to the benchmark definition.
Finally, the equivalence checking run was carried out in a loop by the benchmarking framework.

To generate the quantum circuits for the benchmark instances, @mqt Bench was used @quetschlich2023mqtbench.
A subset of the available benchmarks was chosen for initial tests, namely the Deutsch-Jozsa algorithm @deutsch1992quantum, Grover's algorithm @grover1996db and Shor's algorithm @shor1997discretelog.
The qubit count was set to 8 for initial testing.

These circuits were each compiled using Qiskit for the IBM native gate set and the IBM Eagle @qpu target device (called IBM Washington in @mqt Bench).
This @qpu has a total of 127 qubits and natively supports the $X$, square root of $x$, rotate $z$ and echoed cross-resonance gates @chow2021eagle.
Its gates are connected using a heavy-hexagonal layout.
While other @qpu[s] were not tested in this study, these should yield similar results as the compilation process works in the same manner on these platforms.

These benchmarks were manually downloaded from the @mqt Bench instance hosted by the Chair for Design Automation and subsequently implemented in the @qcec codebase.
This approach doesn't scale very well, however.
Each test instance takes roughly 30 lines of C++ code and the corresponding circuit must be downloaded by the user as there are too many circuits to reasonably add to the git repository.
Considering that @mqt Bench currently has 28 different quantum circuits, most of which have a variable number of qubits, this would be unreasonable to implement by hand @quetschlich2023mqtbench.
Furthermore, there are 36 permutations that can be compared for each benchmark instance as each level of specification and optimisation can be compared to all higher levels of specification and optimisation.
Additionally, it would certainly be interesting to test different combinations of compilers and targets in future work, which would be very difficult with this approach.

Another issue of Google Benchmark is the inability to benchmark variables other than runtime.
To benchmark @qcec, it is desirable to track and compare further variables.
For instance, the node count of the decision diagram can be a good indicator of the efficacy of the application scheme.
Due to these factors, it became necessary to implement a benchmarking framework specifically for @mqt @qcec.

=== MQT QCEC Bench
As Google Benchmark lacked the needed flexibility to adequately test @mqt @qcec, a new benchmarking wrapper around the tool was developed.

This framework was designed around a set of configuration files that specify how the equivalence checker is to be configured and which benchmark instances it should be run on.
The configuration of the equivalence checker currently only allows setting the application scheme for the alternating checker as this was sufficient for this work.
It can, however, trivially be extended to allow for a more flexible configuration.
The benchmark instance configuration allows specifying multiple instances, each with a name, an @mqt bench circuit, a choice of which optimisation and specification levels to compare, a qubit count, a minimum run count and a timeout after which the benchmark will abort.

These configuration files can be written by hand much more quickly than the Google Benchmark test cases.
Additionally, it was possible to script the creation of these configuration files using Python to allow programmatic generation of benchmark instances.
This approach was used to generate the final benchmark configuration with 190 instances.

Furthermore, unlike Google benchmark, this framework doesn't require manually downloading the circuits from @mqt Bench.
@qcec bench automatically builds the required files using the @mqt Bench python package if they haven't been built yet.
It also caches the results so future runs of the benchmark can be started more quickly.

Google Benchmark has a convenient feature to reduce the noise of measurements that was initially lacking from @qcec Bench.
When the runtime of the benchmark is very short, it will automatically increase the run count to calculate a more precise average.
This technique was also adopted in @qcec Bench as the variance for some of the smaller benchmark instances was too high to allow proper interpretation of the results.

