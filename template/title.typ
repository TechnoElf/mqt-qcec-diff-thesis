#import "colour.typ": *

#let title_page(
  title: "",
  author: "",
  chair: []
) = {
  set text(
    font: "TUM Neue Helvetica",
    size: 10pt
  )

  set page(
    paper: "a4",
    margin: (
      top: 5cm,
      bottom: 3cm,
      x: 2cm,
    ),
    header: [
      #grid(
        columns: (1fr, 1fr),
        rows: (auto),
        text(
          fill: tum_blue,
          size: 8pt,
          chair
        ),
        align(bottom + right, image("resources/TUM_Logo_blau.svg", height: 30%))
      )
    ],
    footer: []
  )

  v(1cm)

  set align(top + left)
  text(size: 24pt, [*#title*])

  v(3cm)

  text(fill: tum_blue, size: 17pt, [*#author*])

  v(3cm)

  [Thesis for the attainment of the academic degree]
  v(1em)
  [*Bachelor of Science (B.Sc.)*]
  v(1em)
  [at the School of Computation, Information and Technology of the Technical University of Munich.]

  v(3cm)

  [*Examiner:*\ Prof. Dr. Robert Wille]
  v(0em)
  [*Supervisor:*\ DI Lucas Berent]
  v(0em)
  [*Submitted:*\ Munich, 22.07.2024]
}
