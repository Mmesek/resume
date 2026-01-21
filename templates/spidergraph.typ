#import "@preview/cetz:0.4.1": canvas, draw

#let radar(
  data,
  pos: (0, 0),
  radius: 1,
  ticks: (0.15, 0.25, 0.45, 0.7, 1),
  label-key: 0,
  value-key: 1,
  web-style: (
    stroke: black.lighten(80%),
  ),
  ..style,
) = {
  let angle = 360deg / data.len()
  let pts = ()
  for (i, d) in data.enumerate() {
    let label = d.at(label-key)
    let value = d.at(value-key)
    let axis-name = "axis-" + str(i)
    draw.line(
      pos,
      (
        rel: (-angle * i + 90deg, radius),
        to: (),
      ),
      name: axis-name,
      stroke: black.lighten(50%),
    )
    draw.content(
      (axis-name + ".start", 120%, axis-name + ".end"),
      text(label, size: 7pt),
    )
    pts.push((axis-name + ".start", radius * value, axis-name + ".end"))
  }
  for tick in ticks {
    let pts2 = ()
    for i in range(data.len()) {
      pts2.push((
        rel: (-angle * i + 90deg, radius * tick),
        to: pos,
      ))
    }
    draw.line(..pts2, close: true, ..web-style)
  }
  draw.line(..pts, close: true, ..style)
}

#let spidergraph(
  data,
  pos: (0, 0),
  radius: 1,
  ticks: (..range(1, 11),).map(i => i * 0.1),
  label-key: 0,
  value-key: 1,
  web-style: (
    stroke: black.lighten(80%),
  ),
  ..style,
) = {
  canvas({
    radar(
      data,
      pos: pos,
      label-key: label-key,
      radius: radius,
      ticks: ticks,
      value-key: value-key,
      web-style: web-style,
      ..style,
    )
  })
}

// Example usage
/*
#spidergraph(
  (
    ([Category A], 0.3),
    ([Category B], 0.6),
    ([Category C], 0.3),
    ([Category D], 0.4),
    ([Category E], 0.8),
    ([Category F], 1),
  ),
  fill: blue.transparentize(70%),
  radius: 2,
)
*/
