//// 🐯 GBR: UI Svg Module.
////
//// Olá, tudo bem? Estamos no módulo que encanta os olhos de qualquer um,
//// os ícones e imagens vetorias (SVG), animadas ou não. Neste módulo temos
//// os tipos algébricos para podermos construir um svg do zero usando o lustre.
////

import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}

import lustre/attribute as a
import lustre/element as el
import lustre/element/svg

import gbr/ui/theme

pub type UISvg {
  UISvg(height: Int, width: Int, fill: Option(String), paths: List(UISvgPath))
}

pub opaque type UISvgPath {
  UISvgPath(
    draw: String,
    fill: Option(String),
    fill_rule: Option(String),
    clip_rule: Option(String),
    stroke: Option(String),
    stroke_linecap: Option(String),
    stroke_linejoin: Option(String),
    stroke_width: Option(String),
  )
}

pub fn new_path(draw) -> UISvgPath {
  UISvgPath(
    draw:,
    fill: None,
    fill_rule: None,
    clip_rule: None,
    stroke: None,
    stroke_linecap: None,
    stroke_linejoin: None,
    stroke_width: None,
  )
}

pub fn with_fill(svg, fill) {
  UISvg(..svg, fill: Some(fill))
}

pub fn with_path_stroke(path, stroke) {
  UISvgPath(..path, stroke: Some(stroke))
}

pub fn with_path_stroke_width(path, stroke) {
  UISvgPath(..path, stroke_width: Some(stroke))
}

pub fn with_path_stroke_linecap(path, stroke) {
  UISvgPath(..path, stroke_linecap: Some(stroke))
}

pub fn with_path_stroke_linejoin(path, stroke) {
  UISvgPath(..path, stroke_linejoin: Some(stroke))
}

pub fn with_path_fill(path, fill) {
  UISvgPath(..path, fill: Some(fill))
}

pub fn with_path_fill_rule(path, fill_rule) {
  UISvgPath(..path, fill_rule: Some(fill_rule))
}

pub fn with_path_clip_rule(path, clip_rule) {
  UISvgPath(..path, clip_rule: Some(clip_rule))
}

pub fn new(w width, h height) -> UISvg {
  UISvg(width:, height:, fill: None, paths: [])
}

pub fn with_path(svg, path) {
  UISvg(..svg, paths: path)
}

pub fn default(svg: UISvg, with a, inner e) -> el.Element(msg) {
  view(theme.new(), svg, a, e)
}

pub fn view(theme, svg: UISvg, with a, inner e) -> el.Element(msg) {
  let UISvg(fill:, paths:, ..) = svg

  let fill =
    fill
    |> option.map(a.attribute("fill", _))
    |> option.unwrap(a.none())
  let with = [fill, ..a]
  let inner =
    view_paths(paths)
    |> list.append(e)

  theme.svg(theme, with:, inner:)
}

/// View svg já contendo o atributo view-box.
///
pub fn view_box(svg: UISvg, with a, inner e) -> el.Element(msg) {
  let UISvg(height:, width:, ..) = svg
  // theme
  let xmlns = xmlns()
  let view_box = view_box_(height, width)
  let with = [xmlns, view_box, ..a]

  // paint
  default(svg, with, e)
}

// -----------------------------------------------------------------------------
//
// -- HELPER SVG
//
// -----------------------------------------------------------------------------

/// Atribute href apontando para o namespace da especificação w3 svg.
///
pub fn xmlns() {
  a.attribute("xmlns", "http://www.w3.org/2000/svg")
}

/// A lista de atributos `viewBox`, `width` e `height`.
///
pub fn view_box_width_height(width width: Int, height height: Int) {
  [view_box_(width:, height:), ..width_height(width:, height:)]
}

/// A lista de atributos `width` e `height`.
///
pub fn width_height(width w: Int, height h: Int) {
  [a.width(w), a.height(h)]
}

/// O atribute `fill="none"` muito usado em ícones svg.
///
pub fn path_fill_none() -> a.Attribute(msg) {
  a.attribute("fill", "none")
}

/// O atribute `fill="currentColor" muito usado em ícones svg.
///
pub fn path_fill_current() -> a.Attribute(msg) {
  a.attribute("fill", "currentColor")
}

//
// --- VIEWS (Interno)
//

fn view_paths(paths) {
  use path <- list.map(paths)

  let UISvgPath(
    draw:,
    fill:,
    fill_rule:,
    clip_rule:,
    stroke:,
    stroke_linecap:,
    stroke_linejoin:,
    stroke_width:,
  ) = path

  let fill =
    fill
    |> option.map(path_fill)
    |> option.unwrap(a.none())
  let fill_rule =
    fill_rule
    |> option.map(path_fill_rule)
    |> option.unwrap(a.none())
  let clip_rule =
    clip_rule
    |> option.map(path_clip_rule)
    |> option.unwrap(a.none())
  let stroke =
    stroke
    |> option.map(path_stroke)
    |> option.unwrap(a.none())
  let stroke_width =
    stroke_width
    |> option.map(path_stroke_width)
    |> option.unwrap(a.none())
  let stroke_linecap =
    stroke_linecap
    |> option.map(path_stroke_linecap)
    |> option.unwrap(a.none())
  let stroke_linejoin =
    stroke_linejoin
    |> option.map(path_stroke_linejoin)
    |> option.unwrap(a.none())

  svg.path([
    path_draw(draw),
    fill,
    fill_rule,
    clip_rule,
    stroke,
    stroke_width,
    stroke_linecap,
    stroke_linejoin,
  ])
}

//
// -- Auxiliares (Interno)
//

/// O atributo `viewBox`
///
fn view_box_(width w: Int, height h: Int) {
  let width = int.to_string(w)
  let height = int.to_string(h)
  let view_box = "0 0 " <> width <> " " <> height

  a.attribute("viewBox", view_box)
}

/// O atributo `d` usado em `svg.path`.
///
fn path_draw(draw: String) -> a.Attribute(msg) {
  a.attribute("d", draw)
}

/// O atributo `fill` usado em `svg`.
///
fn path_fill(fill: String) -> a.Attribute(msg) {
  a.attribute("fill", fill)
}

/// O atribute `fill-rule="" muito usado em ícones svg.
///
fn path_fill_rule(rule) -> a.Attribute(msg) {
  a.attribute("fill-rule", rule)
}

/// O atribute `clip-rule="" muito usado em ícones svg.
///
fn path_clip_rule(rule) -> a.Attribute(msg) {
  a.attribute("clip-rule", rule)
}

/// O atribute `stroke="" muito usado em ícones svg.
///
fn path_stroke(rule) -> a.Attribute(msg) {
  a.attribute("stroke", rule)
}

/// O atribute `stroke-width="" muito usado em ícones svg.
///
fn path_stroke_width(rule) -> a.Attribute(msg) {
  a.attribute("stroke-width", rule)
}

/// O atribute `stroke-linecap="" muito usado em ícones svg.
///
fn path_stroke_linecap(rule) -> a.Attribute(msg) {
  a.attribute("stroke-linecap", rule)
}

/// O atribute `stroke-linejoin="" muito usado em ícones svg.
///
fn path_stroke_linejoin(rule) -> a.Attribute(msg) {
  a.attribute("stroke-linejoin", rule)
}
