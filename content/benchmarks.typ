#import "@preview/cetz:0.2.2": canvas, plot, chart, styles, draw, palette
#import "@preview/tablex:0.0.8": tablex
#import "@preview/unify:0.6.0": qty

#let unclip(res) = {
  res.filter(r => not r.clipped).enumerate().map(((i, r)) => {
    r.i = i
    r
  })
}

#let sort-by-circuit-size(res) = {
  res.sorted(key: r => r.total-circuit-size).enumerate().map(((i, r)) => {
    r.i = i
    r
  })
}

#let filter(res) = {
  res.filter(r => r.equivalence-rate > 0.35).enumerate().map(((i, r)) => {
    r.i = i
    r
  })
}

#let filter-rev(res) = {
  res.filter(r => r.equivalence-rate-rev > 0.35).enumerate().map(((i, r)) => {
    r.i = i
    r
  })
}

#let results-r1-b5q16-cprop = csv("../resources/results-r1-b5q16-cprop-smc.csv", row-type: dictionary)
#let results-r1-b5q16-cmyersrev-pmismc = csv("../resources/results-r1-b5q16-cmyersrev-pmismc-smc.csv", row-type: dictionary)
#let results-r1-b5q16-cmyersrev-p = csv("../resources/results-r1-b5q16-cmyersrev-p-smc.csv", row-type: dictionary)
#let results-r1-b5q16-cmyers-p = csv("../resources/results-r1-b5q16-cmyers-p-smc.csv", row-type: dictionary)
#let results-r1-b5q16-cpatience-p = csv("../resources/results-r1-b5q16-cpatience-p-smc.csv", row-type: dictionary)
#let results-r1-b5q16-cmyers-pmismc = csv("../resources/results-r1-b5q16-cmyers-pmismc-smc.csv", row-type: dictionary)

#let results-r1-b5q16 = results-r1-b5q16-cprop.enumerate().map(((i, r)) => {
  let cmyersrev-pmismc = results-r1-b5q16-cmyersrev-pmismc.find(r2 => r2.name == r.name)
  let cmyersrev-p = results-r1-b5q16-cmyersrev-p.find(r2 => r2.name == r.name)
  let cmyers-p = results-r1-b5q16-cmyers-p.find(r2 => r2.name == r.name)
  let cmyers-pmismc = results-r1-b5q16-cmyers-pmismc.find(r2 => r2.name == r.name)
  let cpatience-p = results-r1-b5q16-cpatience-p.find(r2 => r2.name == r.name)
  let num-gates-1 = float(r.numGates1)
  let num-gates-2 = float(r.numGates2)
  let total-circuit-size = num-gates-1 + num-gates-2

  (
    name: r.name,
    i: i,
    clipped: not ((r.finished == "true") and (cmyersrev-pmismc.finished == "true") and (cmyersrev-p.finished == "true") and (cmyers-pmismc.finished == "true") and (cmyers-p.finished == "true")),
    total-circuit-size: total-circuit-size,
    circuit-size-difference: calc.abs(num-gates-1 - num-gates-2),
    equivalence-rate: float(cmyers-pmismc.diffEquivalenceCount) / total-circuit-size,
    equivalence-rate-rev: float(cmyersrev-pmismc.diffEquivalenceCount) / total-circuit-size,
    cprop: (
      mu: float(r.runTimeMean)
    ),
    cmyersrev-pmismc: (
      mu: float(cmyersrev-pmismc.runTimeMean)
    ),
    cmyersrev-p: (
      mu: float(cmyersrev-p.runTimeMean)
    ),
    cmyers-p: (
      mu: float(cmyers-p.runTimeMean)
    ),
    cmyers-pmismc: (
      mu: float(cmyers-pmismc.runTimeMean)
    ),
    cpatience-p: (
      mu: float(cpatience-p.runTimeMean)
    ),
  )
})

#let results-r1-b5q16-hist = {
  let min = calc.log(0.001)
  let max = calc.log(20)
  let bins = 15

  let bins-mu = range(bins + 1).map(x => calc.pow(10, min + x * (max - min) / bins))
  let cprop-mu = bins-mu.slice(1).map(_ => 0)
  let cmyersrev-pmismc-mu = bins-mu.slice(1).map(_ => 0)
  let cmyersrev-p-mu = bins-mu.slice(1).map(_ => 0)
  let cmyers-p-mu = bins-mu.slice(1).map(_ => 0)
  let cmyers-pmismc-mu = bins-mu.slice(1).map(_ => 0)
  let cpatience-p-mu = bins-mu.slice(1).map(_ => 0)

  for r in unclip(results-r1-b5q16) {
    for b in range(bins) {
      if bins-mu.at(b) <= r.cprop.mu and r.cprop.mu < bins-mu.at(b + 1) {
        cprop-mu.at(b) += 1
      }
      if bins-mu.at(b) <= r.cmyersrev-pmismc.mu and r.cmyersrev-pmismc.mu < bins-mu.at(b + 1) {
        cmyersrev-pmismc-mu.at(b) += 1
      }
      if bins-mu.at(b) <= r.cmyersrev-p.mu and r.cmyersrev-p.mu < bins-mu.at(b + 1) {
        cmyersrev-p-mu.at(b) += 1
      }
      if bins-mu.at(b) <= r.cmyers-p.mu and r.cmyers-p.mu < bins-mu.at(b + 1) {
        cmyers-p-mu.at(b) += 1
      }
      if bins-mu.at(b) <= r.cmyers-pmismc.mu and r.cmyers-pmismc.mu < bins-mu.at(b + 1) {
        cmyers-pmismc-mu.at(b) += 1
      }
      if bins-mu.at(b) <= r.cpatience-p.mu and r.cpatience-p.mu < bins-mu.at(b + 1) {
        cpatience-p-mu.at(b) += 1
      }
    }
  }

  let scientific(val) = {
    let exp = calc.floor(calc.log(val))
    [$#(calc.round(val / calc.pow(10, exp), digits: 2)) dot 10 ^ #exp$]
  }

  (
    bins-mu: bins-mu.slice(0, -1).zip(bins-mu.slice(1)).map(((s, e)) => [$<$ #scientific(e)]),
    cprop: (
      mu: cprop-mu
    ),
    cmyersrev-pmismc: (
      mu: cmyersrev-pmismc-mu
    ),
    cmyersrev-p: (
      mu: cmyersrev-p-mu
    ),
    cmyers-p: (
      mu: cmyers-p-mu
    ),
    cmyers-pmismc: (
      mu: cmyers-pmismc-mu
    ),
    cpatience-p: (
      mu: cpatience-p-mu
    )
  )
}

= Benchmarks
This section presents the results of applying the implemented @qcec application scheme on practical problems.
The focus herein lies on the performance in terms of run time of the methodology compared to previous approaches, as the accuracy is already guaranteed by the @dd\-based equivalnce checking method.
First, the test cases used will be listed and justified.
Next, the environment which was used to perform the benchmarks will be elaborated.
Finally, the quantitative results will be presented and interpreted.

== Test Cases
To generate test cases for the application schemes discussed in the implementation section, @mqt Bench was used @quetschlich2023mqtbench.
A subset of the available circuits was generated using the python package of @mqt Bench at version 1.1.3.
Implementations of the Deutsch-Jozsa @deutsch1992quantum, Portfolio Optimization with QAOA @hodson2019qaoa, Portfolio Optimization with VQE @peruzzo2014vqe, Quantum Fourier Transformation @coppersmith2002qft, and Quantum Neural Network @purushothaman1997qnn benchmarks were generated using 4, 8, and 16 qubits.
Each implementation was compiled using Qiskit for the IBM Eagle target (named IBM Washington in @mqt Bench) @chow2021eagle with optimisation levels 0 and 3.
There are therefore 5 different versions of each circuit:

- Target independent representation
- Native gates representation with no optimisation
- Native gates representation with full optimisation
- Mapped representation with no optimisation
- Mapped representation with full optimisation

As any two optimisation stages can be compared, this results in $binom(2, 5) = 5!/(2!(5-2)!) = 10$ benchmark instances per circuit.
This means that there are $10 dot 3 = 30$ benchmarks per circuit type and $30 dot 5 = 150$ benchmarks in total for each application scheme.

== Environment
The following data was collected using @mqt @qcec Bench, the benchmarking tool developed in the course of this work.
It was compiled using `clang` 17.0.6, `cmake` 3.29.2 and `ninja` 1.11.1.
`cmake` was configured to build the application in release mode and without tests or python bindings.

The application was then run on a virtual machine for each benchmarking and @qcec configuration sequentially.
The virtual machine was configured with 32 AMD EPYC 7H12 cores and 64GiB of RAM.
It ran NixOS 23.11 as the operating system on top of an ESXi hypervisor.

Initially, the application was locked to a single core using the taskset utility in an attempt to prevent the Linux scheduler from interfering with the benchmark.
This significantly reduced the performance of the benchmarking application, however, which lowered the turnaround time for the benchmark results.
It was determined that the variance due to context switches was low enough, so this restriction was removed.

@qcec itself was configured as follows:
- The numerical tolerance is set to the builtin epsilon (1024 times the smallest possible value of a double-precision floating-point value according to IEEE 754)
- Parallel execution is disabled.
- The alternating checker is enabled. All other checkers are disabled.
- All optimisations are disabled.
- The application scheme is set to either proprtional or diff-based.
- The trace threshold is set to $10^(-8)$
- Partial equivalence checking is disabled.

Additionally, the following configuration was used for @qcec Bench:
- The timeout is set to 30 seconds.
- The minimum run count for each benchmark is 3.

== Results
@results_overview_histogram presents an overview of the performed benchmarking runs.
The results are sorted into bins and portrayed as a histogram.
A larger count in a bin that is further to the left therefore points towards a better algorithm.

This graph suggests that there is no significant difference in the runtime of the tested algorithms and configurations in most cases.
The proportional application scheme does, however, appear to have a slight advantage in benchmarks that have a higher runtime.

#figure(
  canvas({
    draw.set-style(
      axes: (bottom: (tick: (
        label: (angle: 45deg, anchor: "east"),
      )))
    )
    chart.columnchart(
      mode: "clustered",
      label-key: 0,
      value-key: range(1, 7),
      size: (14, 5),
      x-label: [Run Time (s)],
      x-tick: 45,
      y-label: [Count],
      y-max: 22,
      y-min: 0,
      legend: "legend.inner-north-east",
      bar-style: i => { if i >= 1 { palette.red(i) } else { palette.cyan(i) } },
      labels: ([Proportional], [Myers' Diff (Reversed, Processed)], [Myers' Diff (Processed)], [Myers' Diff (Reversed)], [Myers' Diff], [Patience Diff]),
      results-r1-b5q16-hist.bins-mu.zip(
        results-r1-b5q16-hist.cprop.mu,
        results-r1-b5q16-hist.cmyersrev-pmismc.mu,
        results-r1-b5q16-hist.cmyers-pmismc.mu,
        results-r1-b5q16-hist.cmyersrev-p.mu,
        results-r1-b5q16-hist.cmyers-p.mu,
        results-r1-b5q16-hist.cpatience-p.mu
      )
    )
  }),
  caption: [
    Benchmark instances sorted into bins based on their run time.
    The size of the bins increases exponentially to better reflect the distribution of the results.
    The benchmark runs that did not finish within the time limit are excluded from these results.
  ]
) <results_overview_histogram>

The difference between the runtimes of the application schemes can be further highlighted by graphing the relative improvement according to the following formula:

$ p_"improvement" = (t_"proportional" - t_"diff") / t_"proportional" * 100% $

@results_improvement visualises the improvement for each benchmark instance of the processed Myers' diff application scheme compared to the proportional application scheme.

#figure(
  canvas({
    chart.columnchart(
      size: (14, 6),
      x-ticks: (),
      y-label: [Run Time Improvement (%)],
      y-max: 100,
      y-min: -100,
      sort-by-circuit-size(unclip(results-r1-b5q16)).map(r =>
        ([#r.name], calc.max(-(r.cmyers-pmismc.mu / r.cprop.mu * 100 - 100), -100))
      )
    )
  }),
  caption: [
    The run time improvement of the application scheme based on the processed Myers' algorithm relative to the proportional application scheme for each benchmark instance.
    The bars are arranged according to the total size of the circuits compared in the benchmark instance, with the smallest circuits being on the left.
  ]
) <results_improvement>

Taking the average of this improvement for each variant of the diff-based application scheme produces a good measure of their relative performance.
@results_average_improvement presents the results obtained by this method.

#figure(
  tablex(
    columns: (1fr, 1fr),
    [*Algorithm*], [*Average Runtime Improvement (%)*],
    [Myers' Diff], align(right, [#calc.round(unclip(results-r1-b5q16).map(r => -(r.cmyers-p.mu / r.cprop.mu * 100 - 100)).sum() / unclip(results-r1-b5q16).len(), digits: 3)]),
    [Myers' Diff (Processed)], align(right, [#calc.round(unclip(results-r1-b5q16).map(r => -(r.cmyers-pmismc.mu / r.cprop.mu * 100 - 100)).sum() / unclip(results-r1-b5q16).len(), digits: 3)]),
    [Myers' Diff (Reversed)], align(right, [#calc.round(unclip(results-r1-b5q16).map(r => -(r.cmyersrev-p.mu / r.cprop.mu * 100 - 100)).sum() / unclip(results-r1-b5q16).len(), digits: 3)]),
    [Myers' Diff (Reversed, Processed)], align(right, [#calc.round(unclip(results-r1-b5q16).map(r => -(r.cmyersrev-pmismc.mu / r.cprop.mu * 100 - 100)).sum() / unclip(results-r1-b5q16).len(), digits: 3)]),
    [Patience Diff], align(right, [#calc.round(unclip(results-r1-b5q16).map(r => -(r.cpatience-p.mu / r.cprop.mu * 100 - 100)).sum() / unclip(results-r1-b5q16).len(), digits: 3)]),

  ),
  caption: [
    The average of the runtime improvement of all benchmark instances over the proportional application scheme for each variant of the diff application scheme.
    This value is used as an indicator to determine the relative performance of the application schemes.
  ]
) <results_average_improvement>

These results show that, on average, every variant of the diff-base application scheme results in a significantly worse runtime compared to the state-of-the-art proportional application scheme.
Of these, the reversed Myers' algorithms performed the worst by a significant margin.
On the other hand, the processed variants performed better than their plain counterparts.
This shows that the approach of reversing the second circuit before running the diff algorithm is clearly wrong, but processing the edit script to make it more suitable for use in the equivalnce checker tends to work in most cases.

By comparing the run time improvement to various independent variables, a scheme was developed to determine wether or not applying the diff application scheme would result in a positive improvement.
Properties such as the circuit length in terms of gate count, the number of qubits in either circuit, and the @dd node count were considered.
However, the key variable for this scheme turned out to be the equivalence rate of the two circuits.
It was determined by counting the number of keep operations in the edit script and dividing it by the total size of the circuits.
In @results_equivalence_rate, the results of each variant are plotted dependent on their respective equivalence rates.

#figure(
  canvas({
    plot.plot(
      size: (14, 6),
      x-label: [Equivalence Rate],
      y-label: [Run Time Improvement (%)],
      y-max: 100,
      y-min: -100,
      legend: "legend.inner-north-east",
      {
        plot.add-hline(style: (stroke: black), 0)
        plot.add(
          mark: "triangle",
          mark-style: (fill: none),
          style: (stroke: none),
          label: [Myers' Diff],
          unclip(results-r1-b5q16).map(r =>
            (r.equivalence-rate, calc.max(-(r.cmyers-p.mu / r.cprop.mu * 100 - 100), -100))
          )
        )
        plot.add(
          mark: "square",
          mark-style: (fill: none),
          style: (stroke: none),
          label: [Myers' Diff (Processed)],
          unclip(results-r1-b5q16).map(r =>
            (r.equivalence-rate, calc.max(-(r.cmyers-pmismc.mu / r.cprop.mu * 100 - 100), -100))
          )
        )
        plot.add(
          mark: "o",
          mark-style: (fill: none),
          style: (stroke: none),
          label: [Myers' Diff (Reversed)],
          unclip(results-r1-b5q16).map(r =>
            (r.equivalence-rate, calc.max(-(r.cmyersrev-p.mu / r.cprop.mu * 100 - 100), -100))
          )
        )
        plot.add(
          mark: "x",
          mark-style: (fill: none),
          style: (stroke: none),
          label: [Myers' Diff (Reversed, Processed)],
          unclip(results-r1-b5q16).map(r =>
            (r.equivalence-rate, calc.max(-(r.cmyersrev-pmismc.mu / r.cprop.mu * 100 - 100), -100))
          )
        )
        plot.add(
          mark: "+",
          mark-style: (fill: none),
          style: (stroke: none),
          label: [Patience],
          unclip(results-r1-b5q16).map(r =>
            (r.equivalence-rate, calc.max(-(r.cpatience-p.mu / r.cprop.mu * 100 - 100), -100))
          )
        )
      }
    )
  }),
  caption: [The runtime improvement dependent on the circuit equivalence rate for each diff algorithm.]
) <results_equivalence_rate>

The plot suggests that diff-based application schemes tend to do better when the equivalence rate is higher.
This makes sense as there is no structure that could be exploited using an edit script to apply gates when there are few common subsequences in the two circuits.

Even so, the right side of the graph is obviously very noisy for most diff variants.
The results of the application scheme based on the processed Myers' algorithm look especially interesting in this regard, as they tend to rank higher than those of the other algorithms.
@results_equivalence_rate_processed shows this application scheme on its own to highlight the relationship between the variables.

#figure(
  canvas({
    plot.plot(
      size: (14, 6),
      x-label: [Equivalence Rate],
      y-label: [Run Time Improvement (%)],
      y-max: 100,
      y-min: -100,
      {
        plot.add-hline(style: (stroke: black), 0)
        plot.add(
          mark: "square",
          mark-style: (stroke: green, fill: none),
          style: (stroke: none),
          unclip(results-r1-b5q16).map(r =>
            (r.equivalence-rate, calc.max(-(r.cmyers-pmismc.mu / r.cprop.mu * 100 - 100), -100))
          )
        )
        plot.add-vline(style: (stroke: red), 0.35)
      }
    )
  }),
  caption: [ 
    The runtime improvement dependent on the circuit equivalence rate for the application scheme based on the processed Myers' diff algorithm.
    Using the vertical line at 0.35, the benchmark instances can be filtered into cases where the diff application scheme is superior to the proportional application scheme.
  ]
) <results_equivalence_rate_processed>

Using an equivalence rate of $0.35$ as a limit, it is possible to separate most good benchmark instances where it is beneficial to use a diff-based application scheme from those where the run time increases.
As this value was determined empirically, it may need further adjustment based on more thorough tests.
For the benchmark instances used in this thesis, it was sufficiently precise, however.
@results_filtered_improvement visualises the run time improvement of the benchmark instances filtered using the described approach.

#figure(
  canvas({
    chart.columnchart(
      size: (14, 6),
      x-ticks: (),
      y-label: [Run Time Improvement (%)],
      y-max: 100,
      y-min: -100,
      filter(sort-by-circuit-size(unclip(results-r1-b5q16))).map(r =>
        ([#r.name], calc.max(-(r.cmyers-pmismc.mu / r.cprop.mu * 100 - 100), -100))
      )
    )
  }),
  caption: [
    The run time improvement of the application scheme based on the processed Myers' algorithm relative to the proportional application scheme for each benchmark instance.
    The benchmark instances are filtered so the application scheme is only used for those where the circuits are more than 40% equivalent.
  ]
) <results_filtered_improvement>

#let mu = calc.round(filter(unclip(results-r1-b5q16)).map(r => -(r.cmyers-pmismc.mu / r.cprop.mu * 100 - 100)).sum() / filter(unclip(results-r1-b5q16)).len(), digits: 3)
#let sigma = calc.round(calc.sqrt(filter(unclip(results-r1-b5q16)).map(r => calc.pow(-(r.cmyers-pmismc.mu / r.cprop.mu * 100 - 100) - mu, 2)).sum() / filter(unclip(results-r1-b5q16)).len()), digits: 3)
#let max = calc.round(filter(unclip(results-r1-b5q16)).map(r => -(r.cmyers-pmismc.mu / r.cprop.mu * 100 - 100)).fold(0, calc.max), digits: 3)
#let min = -calc.round(filter(unclip(results-r1-b5q16)).map(r => -(r.cmyers-pmismc.mu / r.cprop.mu * 100 - 100)).fold(0, calc.min), digits: 3)

These results are significantly better than those obtained through the naive approach of applying the scheme to all equivalence checking instances.
The average of the runtime improvement of the filtered test cases is $#mu%$, with a standard deviation of $#sigma%$.
Furthermore, the application scheme results in a maximum improvement of $#max%$ and a maximum regression of $#min%$.

