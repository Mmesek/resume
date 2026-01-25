#import "spidergraph.typ"
#import "@preview/cloudy:0.1.1"
#import "@preview/fontawesome:0.6.0": fa-icon

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
      name + " ", add_meter(rating),
    )
  }
  if calc.even(id) {
    show grid: set align(left)
    grid(
      columns: 2,
      add_meter(rating) + " ", name,
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

#let inline_tag(name) = {
  box(name, stroke: gray.lighten(10%), inset: (x: 0.1pt, y: 0.01pt), outset: (x: 0.5pt, y: 1.3pt), radius: 50%)
}

#let add_section(name, section) = {
  if name == "Spidergraph" {
    spidergraph.spidergraph(
      section.list.sorted(key: v => v.proficiency, by: (l, r) => l >= r).map(s => (s.name, s.proficiency / max_rating)),
      fill: blue.transparentize(50%),
      stroke: blue.transparentize(90%),
      radius: 1.3,
    )
  } else {
    [== #name #fa-icon(section.icon)]

    if section.keys().contains("list") {
      add_list(section.list, columns: section.at("columns", default: 2))
    } else if section.keys().contains("cloud") {
      for item in section.cloud { [#inline_tag(item) ] }
      show: set align(center)
      //cloudy.cloud(
      //  section
      //    .cloud
      //    .enumerate()
      //    .map(((x, item)) => {
      //      inline_tag(text(item, size: 0.7em + x * 0.1pt))
      //    }),
      //  height: 5em,
      //  width: 10em,
      //)
    }
  }
}

#let sidebar(urls, sections) = {
  show: set align(right)
  show: set text(8pt)
  for service in urls {
    if service.display != none {
      link(service.url, service.display) + " "
    } else {
      link(service.url, fa-icon(service.fa_icon)) + " "
    }
  }
  show: set text(10pt)
  for (section) in sections {
    add_section(section.name, section)
  }
}
