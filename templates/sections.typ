#import "sidebar.typ"
#import "@preview/fontawesome:0.6.0": fa-icon

#let link_colour = rgb("#3d5085")

#let icon2(name, shift: 1.5pt) = {
  box(
    baseline: shift,
    height: 10pt,
    name,
  )
  h(3pt)
}

#let icon(name, icon) = {
  [name + " " + icon]
}

#let term(start, end) = {
  text(9pt)[#start - #end 📅]
}

#let styled-link(dest, content) = emph(text(
  fill: link_colour,
  link(dest, content),
))

#let contact(meta, contact_details, author) = {
  if (author != "") {
    text(size: 18pt)[#author]
    [\ ]
  }

  show: set align(right)
  show text: set text(size: 7pt)
  set par(leading: 0.1em, spacing: 0.2em)
  grid(
    columns: (1fr, 1fr),
    row-gutter: 2.5pt,
    "",
    if (contact_details.email != "") {
      link("mailto:" + contact_details.email, contact_details.email) + fa-icon("inbox")
    },

    if (meta.contact != "") {
      fa-icon(meta.contact.fa_icon) + link(meta.contact.url, meta.contact.display)
    },
    if (contact_details.phone != "") {
      contact_details.phone + " " + fa-icon("phone")
    },

    if (meta.timezone != "") {
      fa-icon("clock") + " " + meta.timezone
    },

    if (meta.location != "") {
      meta.location + " " + fa-icon("map")
    },
  )

  sidebar.links(meta.links)
}

#let add_experience(roles, name: "Experience", icon: "suitcase") = {
  [= #fa-icon(icon) #name]

  for item in roles {
    [== #if "icon" in item { box(image(item.icon, width: 10pt)) } #item.at("company", default: item.at(
      "name",
      default: "Unnamed Company",
    ))]
    [=== 💻 _ #item.at("role", default: "") _ #h(1fr) #term(item.at("start", default: item.at("date", default: "")), item.at("end", default: ""))]

    if "description" in item.keys() {
      eval(item.description, mode: "markup")
    }
  }
}

#let certs(cert_data, name: "Certificates", icon: "certificate") = {
  [= #name #fa-icon(icon)]
  for org in cert_data {
    grid(
      columns: 2,
      column-gutter: 1fr,
      [=== #org.organisation],
      [==== _#if "url" in org.certificates.first() { link(org.certificates.first().url)[#org.certificates.first().name] } else { org.certificates.first().name }_],
    )
    for item in org.certificates.slice(1) {
      [==== _#if "url" in item { link(item.url)[#item.name] } else { item.name }_]
    }
  }
}

#let extra(data, name: "Extra", icon: "puzzle-piece") = {
  [= #name #fa-icon(icon)]
  for item in data {
    grid(
      columns: 2,
      column-gutter: 1fr,
      [=== #if "link" in item { link(item.link)[#item.name] } else { [#item.name] }],
      eval(item.description, mode: "markup"),
    )
  }
}

#let education(education_data, name: "Education", icon: "university") = {
  [= #name #fa-icon(icon)]
  show list: set align(right)
  for item in education_data {
    [=== _ #item.name _]
    if "date" in item {
      text(9pt)[#item.date]
    }
    show list: set par(leading: 0.3em)
    show: set list(marker: "")
    eval(item.description, mode: "markup")
  }
}

#let side(sections) = {
  show: set text(size: 8.5pt)
  show heading: set align(right)
  show heading: set block(spacing: 0.4em, above: 0.7em, below: 0.5em)
  show heading.where(level: 3): set align(left)
  show heading.where(level: 2): set text(size: 12pt)
  show heading.where(level: 3): set text(size: 10pt)
  show heading.where(level: 2): underline
  set par(leading: 0.5em, spacing: 0.5em)

  for section in sections.sidebar {
    if "include_parser" in section.keys() {
      let func = (file, name: "", icon: "") => {}
      if section.include_parser == "education" {
        func = education
      } else if section.include_parser == "certificates" {
        func = certs
      } else if section.include_parser == "extra" {
        func = extra
      } else if section.include_parser == "skill_list" {
        sidebar.sidebar(yaml(section.include))
      }
      func(
        yaml(section.include),
        icon: section.at("icon", default: ""),
        name: section.at("name", default: ""),
      )
    }
  }
}

#let main(sections) = {
  show heading.where(level: 1): set align(center)
  show heading.where(level: 1): set text(size: 16pt)
  show heading.where(level: 2): set text(size: 13pt)
  show heading.where(level: 3): set text(size: 10pt)
  show heading: set block(spacing: 0.4em, above: 1em, below: 0.5em)
  set par(leading: 0.5em)

  for section in sections.main {
    if section.len() > 0 {
      add_experience(yaml(section.file), name: section.name, icon: section.icon)
    }
  }
}
