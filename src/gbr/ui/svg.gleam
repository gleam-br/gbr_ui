////
//// 🐯 Gleam UI super lustre element svg.
////

import gleam/int
import gleam/list
import gleam/option.{None}
import gleam/string

import lustre/element/html
import lustre/element/svg

import gbr/ui/core/el
import gbr/ui/core/model.{type UIRender, type UISwitchs}

import gbr/ui/svg/core.{
  Circle, Path, Svg, svg_key, to_animate, to_att, to_attrs_circle, to_attrs_rect,
  to_path,
}

type Switchs =
  UISwitchs

/// Svg super element.
///
pub type Svg =
  core.Svg

/// Function identity to `gbr/ui/svg.Svg`.
///
pub type Identity =
  fn(Svg) -> Svg

/// Constructor of super svg element `gbr/ui/svg.Svg`.
///
pub fn new(height h, width w) -> Svg {
  let height = int.to_string(h)
  let width = int.to_string(w)
  let view_port = "0 0 " <> string.join([width, height], " ")

  let el =
    el.new(svg_key)
    |> el.att([
      #("height", height),
      #("width", width),
      #("viewBox", view_port),
      #("xmlns", "http://www.w3.org/2000/svg"),
    ])

  Svg(el:, path: [], rect: [], circle: [], animate: [], mask: None)
}

/// Replace class
///
pub fn class(in: Svg, class: String) -> Svg {
  let el = el.class(in.el, class)

  Svg(..in, el:)
}

/// Replace classes
///
pub fn classes(in: Svg, classes: Switchs) -> Svg {
  let el = el.classes(in.el, classes)

  Svg(..in, el:)
}

/// Render super svg element in `lustre/element/html.{svg}`.
///
pub fn render(in: Svg) -> UIRender(a) {
  let Svg(el:, path:, rect:, circle:, mask:, animate:) = in
  let path = to_path(path)
  let rect = to_attrs_rect(rect)
  let circle = to_attrs_circle(circle)
  let mask =
    map_mask(mask)
    |> option.unwrap([])

  let attrs = el.attrs(el)

  html.svg(
    attrs,
    list.append(path, rect)
      |> list.append(circle)
      |> list.append(mask),
  )
  |> to_animate(animate)
}

// PRIVATE
//

fn map_mask(mask) {
  use mask <- option.map(mask)

  case mask {
    Path(path, att_mark) -> {
      [svg.mask(to_att(att_mark), to_path(path))]
    }
    Circle(circle, att_mark) -> {
      [svg.mask(to_att(att_mark), to_attrs_circle(circle))]
    }
  }
}
