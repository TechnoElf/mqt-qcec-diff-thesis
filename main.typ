#import "@preview/cetz:0.2.2"
#import "@preview/fletcher:0.5.1"
#import "@preview/gentle-clues:0.9.0"
#import "@preview/glossarium:0.4.1": make-glossary
#import "@preview/lovelace:0.3.0"
#import "@preview/tablex:0.0.8"
#import "@preview/unify:0.6.0"
#import "@preview/quill:0.3.0"
#import "@preview/wordometer:0.1.2": word-count, total-words

#import "template/conf.typ": conf

#show: make-glossary

#set document(title: "Equivalence Checking of Quantum Circuits using Diff Algorithms", author: "Janis Heims")

#show: word-count

#show: doc => conf(
  title: "Equivalence Checking of Quantum Circuits using Diff Algorithms",
  author: "Janis Heims",
  chair: "Chair for Design Automation",
  school: "School of Computation, Information and Technology",
  degree: "Bachelor of Science (B.Sc.)",
  examiner: "Prof. Dr. Robert Wille",
  supervisor: "DI Lucas Berent",
  submitted: "22.07.2024",
  doc
)

#set math.vec(delim: "[")
#set math.mat(delim: "[")

#include "content/introduction.typ"
#include "content/background.typ"
#include "content/state.typ"
#include "content/implementation.typ"
#include "content/benchmarks.typ"
#include "content/conclusion.typ"
#include "content/outlook.typ"

#counter(heading).update(0)
#heading(numbering: none)[List of Figures]
#outline(
  title: none,
  target: figure.where(kind: image),
)

#include "glossary.typ"

#counter(heading).update(0)
#bibliography("bibliography.bib", style: "mla", full: true)

//#pagebreak()
//Total word count: #total-words

