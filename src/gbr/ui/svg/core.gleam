////
//// Gleam UI super svg model types
////

import gleam/list
import gleam/option.{type Option}
import gleam/string

import lustre/attribute as a
import lustre/element
import lustre/element/html
import lustre/element/svg

import gbr/ui/core/el
import gbr/ui/core/model.{type UIProperties, type UISwitches}

pub type Properties =
  UIProperties

pub type Rect =
  List(Properties)

pub type Circle =
  List(Properties)

pub type Path =
  List(Properties)

pub type Mask {
  Circle(kind: Circle, att: Properties)
  Path(kind: Path, att: Properties)
}

/// Svg super element.
///
pub type Svg {
  Svg(
    el: el.UIEl,
    rect: Rect,
    circle: Circle,
    path: List(Properties),
    mask: Option(Mask),
    animate: List(String),
  )
}

pub const svg_key = ".svg"

/// Replace class
///
pub fn class(in: Svg, class: String) -> Svg {
  let el = el.class(in.el, class)

  Svg(..in, el:)
}

/// Replace classes
///
pub fn classes(in: Svg, classes: UISwitches) -> Svg {
  let el = el.classes(in.el, classes)

  Svg(..in, el:)
}

pub fn animate(in: Svg, animate: List(String)) {
  Svg(..in, animate:)
}

pub fn to_path(path: Path) {
  case path {
    [] -> [element.none()]
    path ->
      list.map(path, fn(path) {
        svg.path(list.map(path, fn(path) { a.attribute(path.0, path.1) }))
      })
  }
}

pub fn to_att(att: Properties) {
  case att {
    [] -> [a.attribute("fill", "none")]
    att -> list.map(att, fn(att) { a.attribute(att.0, att.1) })
  }
}

pub fn to_animate(in, animate) {
  case animate {
    [] -> in
    _ -> html.span([a.class(string.join(animate, " "))], [in])
  }
}

pub fn draw(svg: Svg, value, fill) {
  let el = el.att(svg.el, [#("fill", fill)])

  Svg(..svg, el:, path: [[#("d", value)], ..svg.path])
}

pub fn draw_filless(svg, value) {
  draw(svg, value, "")
}

pub fn stroke_none(svg, draw) {
  stroke(svg, draw, "none")
}

pub fn stroke(svg: Svg, draw, fill) {
  let el = el.att(svg.el, [#("fill", fill)])

  Svg(..svg, el:, path: [[#("d", draw), ..stroke_()], ..svg.path])
}

pub fn evenodd_filless(svg, draw) {
  evenodd(svg, draw, "")
}

pub fn evenodd(svg: Svg, draw, fill) {
  let el = el.att(svg.el, [#("fill", "none")])

  Svg(..svg, el:, path: [[#("d", draw), ..evenodd_(fill)], ..svg.path])
}

pub fn to_attrs_rect(rect: Rect) {
  case rect {
    [] -> [element.none()]
    rect ->
      list.map(rect, fn(rect) {
        svg.rect(list.map(rect, fn(rect) { a.attribute(rect.0, rect.1) }))
      })
  }
}

pub fn to_attrs_circle(circle: Circle) {
  case circle {
    [] -> [element.none()]
    circle ->
      list.map(circle, fn(circle) {
        svg.circle(
          list.map(circle, fn(circle) { a.attribute(circle.0, circle.1) }),
        )
      })
  }
}

// PRIVATE
//

fn stroke_() {
  [
    #("stroke", ""),
    #("stroke-width", "1.5"),
    #("stroke-linecap", "round"),
    #("stroke-linejoin", "round"),
  ]
}

fn evenodd_(fill) {
  [
    #("fill-rule", "evenodd"),
    #("clip-rule", "evenodd"),
    #("fill", fill),
  ]
}
