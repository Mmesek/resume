#import "spidergraph.typ"
#import "@preview/cloudy:0.1.1"

#let primary_colour = rgb("#05408d")
#let secondary_colour = rgb("#d39014")

#let max_rating = 10
#let add_meter(rating) = {
  let done = false
  let i = 1
  while (not done) {
    let colour = secondary_colour
    let strokeColor = primary_colour
    let radiusValue = (left: 0em, right: 0em)

    if (i <= rating) {
      colour = primary_colour
      strokeColor = primary_colour
    }

    // Add rounded corners for the first and last boxes
    if (i == 1) {
      radiusValue = (left: 2em, right: 0em)
    } else if (i == max_rating) {
      radiusValue = (left: 0em, right: 2em)
    }

    box(rect(
      height: 0.5em,
      width: 2pt,
      stroke: strokeColor,
      fill: colour,
      radius: radiusValue,
    ))

    if (max_rating == i) {
      done = true
    }

    i += 1
  }
}

#let familiarity(id, name, rating) = {
  if calc.odd(id) {
    show grid: set align(right)
    grid(
      columns: 2,
      name, add_meter(rating),
    )
  }
  if calc.even(id) {
    show grid: set align(left)
    grid(
      columns: 2,
      add_meter(rating), name,
    )
  }
}

#let add_list(array, columns: 2) = {
  grid(
    columns: columns,
    row-gutter: 2.5pt,
    column-gutter: 3em,
    align: end,

    ..array
      .sorted(key: v => v.proficiency, by: (l, r) => l >= r)
      .enumerate()
      .map(value => {
        if "description" in value.at(1) {
          list.item(value.at(1).name + " - " + value.at(1).description)
        } else {
          familiarity(value.at(0), value.at(1).name, value.at(1).proficiency)
        }
      })
  )
}

#let add_section(name, section) = {
  show: set align(right)

  if name == "Spidergraph" {
    spidergraph.spidergraph(
      section.list.sorted(key: v => v.proficiency, by: (l, r) => l >= r).map(s => (s.name, s.proficiency / max_rating)),
      fill: blue.transparentize(50%),
      stroke: blue.transparentize(90%),
      radius: 1.3,
    )
  } else {
    [== #name]

    if section.keys().contains("list") {
      add_list(section.list, columns: section.at("columns", default: 2))
    } else if section.keys().contains("cloud") {
      show: set align(center)
      cloudy.cloud(
        section
          .cloud
          .enumerate()
          .map(item => {
            text(item.at(1), size: 1em + item.at(0) * 0.1pt)
          }),
        height: 70pt,
        width: 90pt,
      )
    }
  }
}

#let sidebar(contact, sections) = {
  set text(8pt)
  //let icon = icon.with(shift: 2.5pt)

  grid(
    columns: (1fr, 1fr),

    ..contact.map(service => {
      /*icon(service.name)

      if "display" in service.keys() {
        link("b")[#{ service.display }]
      } else {
        link("a")
      }*/
      [service]
    })
  )

  set text(10pt)
  for (section) in sections {
    add_section(section.name, section)
  }
}
