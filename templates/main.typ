#import "sections.typ"

#set page(paper: "a4", margin: (x: 0.5cm, y: 0.5cm))
#set text(font: "Roboto")
#set document(
  title: "'s CV",
  author: "Mms",
)

#show link: set text(fill: blue, weight: 700)
#show link: underline

#grid(
  columns: (1fr, 3fr),
  column-gutter: 2em,
  sections.side(
    meta_data: yaml("../meta/main.yaml"),
    //contact_data: yaml("../meta/contact.yaml"),
    tech_data: yaml("../configs/sidebar/technologies.yml"),
    //cert_data: yaml("../configs/sidebar/certificates.yml"),
    education_data: yaml("../configs/sidebar/education.yml"),
    //extra_data: yaml("../configs/sidebar/extra.yml"),
  ),
  sections.main(
    experience_data: yaml("../configs/experience.yml"),
    //volunteering_data: yaml("../configs/after/volunteering.yml"),
  ),
)
