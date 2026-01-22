#import "sidebar.typ"

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

#let contact(meta, contact_details) = {
  if (meta.author != "") {
    text(size: 24pt)[#meta.author]
    [\ ]
  }

  show text: set align(right)
  show text: set text(size: 7pt)
  set par(leading: 0.1em)
  if (contact_details.email != "") {
    link("mailto:" + contact_details.email, contact_details.email)
  }
  grid(
    columns: (1fr, 1fr),
    row-gutter: 2.5pt,

    if (meta.contact != "") {
      link(meta.contact.url, meta.contact.display)
    },
    if (contact_details.phone != "") {
      contact_details.phone + " 📞"
    },

    if (meta.timezone != "") {
      "🕒 " + meta.timezone
    },

    if (meta.location != "") {
      meta.location + " 🗺️"
    },
  )
}

#let add_experience(roles, name: "💼 Experience") = {
  [= #name]

  for item in roles {
    [== #if "icon" in item { box(image(item.icon, width: 10pt)) } #item.at("company", default: item.at(
      "name",
      default: "Unnamed Company",
    ))]
    [=== 💻 _ #item.at("role", default: "") _ #h(1fr) #term(item.at("start", default: item.at("date", default: "")), item.at("end", default: ""))]


    if "description" in item.keys() {
      grid(
        columns: 1fr,
        row-gutter: 2.5pt,
        eval(item.description, mode: "markup"),
      )
    }
  }
}

#let certs(cert_data) = {
  [== Certifications 📜]
  for org in cert_data {
    show heading: set align(left)
    [=== #org.organisation]
    show text: set align(right)
    for item in org.certificates {
      [==== _ #item.name _]
      [#item.date]
    }
  }
}

#let education(education_data, name: "Education 🎓") = {
  [== #name]
  show text: set align(right)
  for item in education_data {
    [=== _ #item.name _]
    if "date" in item {
      text(9pt)[#item.date]
    }
    //term(item.at("date", default: ""), "")
    [#item.description]
  }
}

#let side(
  meta_data: (),
  contact_data: ("email": "", "phone": ""),
  tech_data: (),
  cert_data: (),
  education_data: (),
  extra_data: (),
) = {
  if meta_data.len() > 0 {
    contact(meta_data, contact_data)
  }
  show heading: set align(right)
  if tech_data.len() > 0 {
    sidebar.sidebar((), tech_data)
  }
  if cert_data.len() > 0 {
    certs(cert_data)
  }
  if education_data.len() > 0 {
    education(education_data)
  }
  if extra_data.len() > 0 {
    education(extra_data, name: "Extra 🧩")
  }
}

#let main(experience_data: (), volunteering_data: ()) = {
  show heading.where(level: 1): set align(center)
  show heading.where(level: 1): set text(size: 16pt)
  show heading.where(level: 2): set text(size: 13pt)
  show heading.where(level: 3): set text(size: 10pt)
  show heading: set block(spacing: 0.4em, above: 1em, below: 0.5em)
  set par(leading: 0.5em)

  if experience_data.len() > 0 {
    add_experience(experience_data)
  }
  if volunteering_data.len() > 0 {
    add_experience(volunteering_data, name: "Volunteering")
  }
}
