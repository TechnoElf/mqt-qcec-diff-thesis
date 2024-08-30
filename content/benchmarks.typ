#import "@preview/cetz:0.2.2": canvas, plot, chart, styles, draw
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

#let results-r1-b5q16-cprop = csv("../resources/results-r1-b5q16-cprop.csv", row-type: dictionary)
#let results-r1-b5q16-cmyersrev-pmismc = csv("../resources/results-r1-b5q16-cmyersrev-pmismc.csv", row-type: dictionary)
#let results-r1-b5q16-cmyersrev-p = csv("../resources/results-r1-b5q16-cmyersrev-p.csv", row-type: dictionary)
#let results-r1-b5q16-cmyers-p = csv("../resources/results-r1-b5q16-cmyers-p.csv", row-type: dictionary)

#let results-r1-b5q16 = results-r1-b5q16-cprop.enumerate().map(((i, r)) => {
  let cmyersrev-pmismc = results-r1-b5q16-cmyersrev-pmismc.find(r2 => r2.name == r.name)
  let cmyersrev-p = results-r1-b5q16-cmyersrev-p.find(r2 => r2.name == r.name)
  let cmyers-p = results-r1-b5q16-cmyers-p.find(r2 => r2.name == r.name)

  (
    name: r.name,
    i: i,
    clipped: not ((r.finished == "true") and (cmyersrev-pmismc.finished == "true")),
    total-circuit-size: r.numGates1 + r.numGates2,
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
    )
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
    )
  )
}

= Benchmarks
== Test Cases
To generate test cases for the application schemes, @mqt Bench was used. @quetschlich2023mqtbench

== Results

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
      value-key: range(1, 5),
      size: (14, 6),
      x-label: [Run Time (s)],
      x-tick: 45,
      y-label: [Count],
      y-max: 40,
      y-min: 0,
      legend: "legend.inner-north-east",
      labels: ([Proportional], [Myers' Diff (Processed)], [Myers' Diff], [Myers' Diff (Reversed)]),
      results-r1-b5q16-hist.bins-mu.zip(results-r1-b5q16-hist.cprop.mu, results-r1-b5q16-hist.cmyersrev-pmismc.mu, results-r1-b5q16-hist.cmyersrev-p.mu, results-r1-b5q16-hist.cmyers-p.mu)
    )
  }),
  caption: [A histogram.]
) <histogram>

#figure(
  canvas({
    chart.columnchart(
      size: (10, 6),
      x-ticks: (),
      y-label: [Run Time Improvement (%)],
      y-max: 100,
      y-min: -100,
      sort-by-circuit-size(unclip(results-r1-b5q16)).map(r =>
        ([#r.name], calc.max(-(r.cmyersrev-pmismc.mu / r.cprop.mu * 100 - 100), -100))
      )
    )
  }),
  caption: [A chart.]
) <chart_improvement>

#figure(
  canvas({
    chart.columnchart(
      size: (10, 6),
      x-ticks: (),
      y-label: [Run Time Improvement (%)],
      y-max: 100,
      y-min: -100,
      sort-by-circuit-size(unclip(results-r1-b5q16)).map(r =>
        ([#r.name], calc.max(-(r.cmyers-p.mu / r.cprop.mu * 100 - 100), -100))
      )
    )
  }),
  caption: [A chart.]
) <chart_improvement>



