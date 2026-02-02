#import "sections.typ"
#import "sidebar.typ"

#set page(paper: "a4", margin: (x: 0.5cm, y: 0.5cm))
#set text(font: "Roboto")

#let author = sys.inputs.at("author", default: "")
#let sections_file = yaml(sys.inputs.at("sections", default: "../configs/sections.yml"))

#set document(
  title: author + " Resume",
  author: author,
  date: datetime.today(),
)

#show link: set text(fill: blue, weight: 700)
#show link: underline
#show heading.where(level: 1): underline

#let meta_data = yaml(sys.inputs.at("meta", default: "../meta/main.yaml"))
#let contact_data = {
  if sys.inputs.at("contact", default: false) {
    yaml(sys.inputs.at("contact", default: "../meta/contact.yaml"))
  } else { ("email": "", "phone": "") }
}

#grid(
  columns: (1fr, 3fr),
  column-gutter: 2em,
  {
    if meta_data.len() > 0 {
      sections.contact(meta_data, contact_data, author)
    }
    sections.side(sections_file)
  },
  sections.main(sections_file),
)
