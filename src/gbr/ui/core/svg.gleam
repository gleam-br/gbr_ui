////
//// 🐯 Gleam UI super lustre element svg.
////
//// Olá, tudo bem? Aqui estamos no módulo que encanta os olhos de qualquer um
//// os ícones e imagens vetorias (SVG), animadas ou não. Neste módulo temos
//// as representações e funções DOM + a11y.

import lustre/attribute as a
import lustre/element as el
import lustre/element/html as h
import lustre/element/svg

///
pub fn with_path_draw(draw: String) -> a.Attribute(msg) {
  a.attribute("d", draw)
}

pub fn with_path_fill_none() -> a.Attribute(msg) {
  a.attribute("fill", "none")
}

pub fn with_path_fill_current() -> a.Attribute(msg) {
  a.attribute("fill", "currentColor")
}

pub fn with_path_rule_fill_evenodd() -> a.Attribute(msg) {
  a.attribute("fill-rule", "evenodd")
}

pub fn with_path_rule_clip_evenodd() -> a.Attribute(msg) {
  a.attribute("clip-rule", "evenodd")
}

pub fn with_path_rule_fill_stroke() -> a.Attribute(msg) {
  a.attribute("fill-rule", "stroke")
}

pub fn with_path_rule_clip_stroke() -> a.Attribute(msg) {
  a.attribute("clip-rule", "stroke")
}

pub fn with_path_evenodd_fill_draw(draw: String) -> List(a.Attribute(msg)) {
  [
    with_path_rule_clip_evenodd(),
    with_path_rule_fill_evenodd(),
    with_path_fill_none(),
    with_path_draw(draw),
  ]
}

pub fn with_path_fill_current_draw(draw: String) -> List(a.Attribute(msg)) {
  [
    with_path_fill_current(),
    with_path_draw(draw),
  ]
}

pub fn path(attributes: List(a.Attribute(msg))) -> el.Element(msg) {
  svg.path(attributes)
}

/// UI core svg DOM + a11y
///
@internal
pub fn to_element(
  attributes: List(a.Attribute(msg)),
  elements elements: List(el.Element(msg)),
) -> el.Element(msg) {
  h.svg(attributes, elements)
}
