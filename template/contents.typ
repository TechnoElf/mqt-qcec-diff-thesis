#import "colour.typ": *

#let contents_page() = {
  set text(font: "TUM Neue Helvetica")

  show outline.entry.where(
    level: 1
  ): it => {
    v(0.5em)
    strong(it)
  }

  outline(indent: auto)
}
