#let configuration = yaml("../configs/sidebar/technologies.yml")

#set page(paper: "a4", margin: (x: 0.5cm, y: 0.5cm))
#set text(font: "Roboto")
#import "sidebar.typ"

#set document(
  title: "'s CV",
  author: "Mms",
)

#show link: set text(fill: blue, weight: 700)
#show link: underline

#let primary_colour = rgb("#05408d")
#let link_colour = rgb("#3d5085")

#let icon(name, shift: 1.5pt) = {
  box(
    baseline: shift,
    height: 10pt,
    "icon",
  )
  h(3pt)
}



#let term(start, end) = {
  text(9pt)[#icon("calendar") #start - #end #h(1fr) #icon("location")]
}



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


#let styled-link(dest, content) = emph(text(
  fill: link_colour,
  link(dest, content),
))


#let add_experience(roles) = {
  [= Experience]

  for item in roles {
    [== #item.company]
    [=== _ #item.role _]
    term(item.start, item.end)

    if "description" in item.keys() {
      grid(
        columns: 1fr,
        row-gutter: 2.5pt,
        eval(item.description, mode: "markup"),
      )
    }
  }
}
#let side() = {
  contact(yaml("../meta/main.yaml"), ("email": "", "phone": "")) // yaml("../meta/contact.yaml"))
  sidebar.sidebar((), configuration)
}

#grid(
  columns: (1fr, 3fr),
  column-gutter: 1em,
  side(), add_experience(yaml("../configs/experience.yml")),
)
