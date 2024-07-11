#import "template/conf.typ": conf

#set document(title: "Equivalence Checking of Quantum Circuits using Diff Algorithms", author: "Janis Heims")

#show: doc => conf(
  title: "Equivalence Checking of Quantum Circuits using Diff Algorithms",
  author: "Janis Heims",
  chair: [
    Chair for Design Automation \
    School of Computation, Information and Technology \
    Technical University of Munich
  ],
  doc
)

#include "content/introduction.typ"
#include "content/background.typ"
#include "content/state.typ"
#include "content/implementation.typ"
#include "content/benchmarks.typ"
#include "content/conclusion.typ"
#include "content/outlook.typ"

#counter(heading).update(0)
#heading(numbering: none)[Terms]
#include "terms.typ"

#counter(heading).update(0)
#bibliography("bibliography.bib", style: "mla")

