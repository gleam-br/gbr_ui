////
//// Gleam UI super svg model types
////

import gleam/list
import gleam/option.{type Option}

pub type Property =
  #(String, String)

pub type Properties =
  List(Property)

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

pub type Svg {
  Svg(
    h: Int,
    w: Int,
    att: Properties,
    path: List(Properties),
    rect: Rect,
    circle: Circle,
    mask: Option(Mask),
    animate: List(String),
    classes: List(String),
  )
}

pub fn animate(in: Svg, animate: List(String)) {
  Svg(..in, animate:)
}

pub fn classes(svg: Svg, classes: List(String)) -> Svg {
  Svg(..svg, classes: list.append(classes, svg.classes))
}
