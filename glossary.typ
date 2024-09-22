#import "@preview/glossarium:0.4.1": print-glossary

#counter(heading).update(0)
#heading(numbering: none)[Glossary]

#print-glossary((
  (key: "bdd", short: "BDD", plural: "BDDs", long: "binary decision diagram", longplural: "binary decision diagrams"),
  (key: "dag", short: "DAG", long: "directed acyclical graph"),
  (key: "dd", short: "DD", plural: "DDs", long: "decision diagram", longplural: "decision diagrams"),
  (key: "gui", short: "GUI", long: "graphical user interface"),
  (key: "lcs", short: "LCS", long: "longest common subsequence"),
  (key: "mqt", short: "MQT", long: "Munich Quantum Toolkit"),
  (key: "qcec", short: "QCEC", long: "Quantum Circuit Equivalence Checker"),
  (key: "qpu", short: "QPU", long: "quantum processing unit"),
  (key: "spsp", short: "SPSP", long: "single-pair shortest path"),
  (key: "sssp", short: "SSSP", long: "single-source shortest path"),
  (key: "vqe", short: "VQE", long: "variational quantum eigensolver")
))

