////
//// Gleam UI super svg util functions
////

import gleam/list
import gleam/string

import lustre/attribute as a
import lustre/element
import lustre/element/html
import lustre/element/svg

import gbr/ui/svg/model.{type Circle, type Path, type Properties, type Rect, Svg}

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

pub fn draw(svg, value, fill) {
  Svg(..svg, att: [#("fill", fill)], path: [[#("d", value)], ..svg.path])
}

pub fn draw_filless(svg, value) {
  draw(svg, value, "")
}

pub fn stroke_none(svg, draw) {
  stroke(svg, draw, "none")
}

pub fn stroke(svg, draw, fill) {
  Svg(..svg, att: [#("fill", fill), ..svg.att], path: [
    [#("d", draw), ..stroke_()],
    ..svg.path
  ])
}

pub fn evenodd_filless(svg, draw) {
  evenodd(svg, draw, "")
}

pub fn evenodd(svg, draw, fill) {
  Svg(..svg, att: [#("fill", "none")], path: [
    [#("d", draw), ..evenodd_(fill)],
    ..svg.path
  ])
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
