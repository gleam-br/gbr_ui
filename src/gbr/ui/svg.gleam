////
//// 🐯 Gleam UI super lustre element svg.
////

import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/string

import lustre/attribute
import lustre/element
import lustre/element/html
import lustre/element/svg

import gbr/ui/svg/core.{
  Circle, Path, Svg, to_animate, to_att, to_attrs_circle, to_attrs_rect, to_path,
}

import gbr/ui/core.{type UIRender} as uicore

/// Svg super element.
///
pub type Svg =
  core.Svg

/// Function identity to `gbr/ui/svg/core.{type Svg}`.
///
pub type Identity =
  fn(Svg) -> Svg

/// Constructor of super svg element `gbr/ui/svg/core.{type Svg}`.
///
pub fn new(id: String, height h, width w) -> Svg {
  Svg(
    id: uicore.to_id(id),
    h:,
    w:,
    att: [],
    path: [],
    rect: [],
    circle: [],
    classes: [],
    animate: [],
    mask: None,
  )
}

/// Append list in `gbr/ui/svg/core.{type Svg}` classes.
///
pub fn classes(in: Svg, classes: List(String)) -> Svg {
  Svg(..in, classes: list.append(in.classes, classes))
}

/// Render super svg element in `lustre/element/html.{svg}`.
///
pub fn render(in: Svg) -> UIRender(a) {
  let Svg(id:, h:, w:, att:, path:, rect:, circle:, classes:, animate:, mask:) =
    in
  let view_port = "0 0 " <> int.to_string(w) <> " " <> int.to_string(h)
  let att = to_att(att)
  let path = to_path(path)
  let rect = to_attrs_rect(rect)
  let circle = to_attrs_circle(circle)
  let mask = case mask {
    Some(Path(path, att_mark)) -> {
      [svg.mask(to_att(att_mark), to_path(path))]
    }
    Some(Circle(circle, att_mark)) -> {
      [svg.mask(to_att(att_mark), to_attrs_circle(circle))]
    }
    None -> [element.none()]
  }

  html.svg(
    [
      attribute.id(id),
      attribute.height(h),
      attribute.width(w),
      attribute.attribute("viewBox", view_port),
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.class(string.join(classes, " ")),
      ..att
    ],
    list.append(path, rect)
      |> list.append(circle)
      |> list.append(mask),
  )
  |> to_animate(animate)
}
