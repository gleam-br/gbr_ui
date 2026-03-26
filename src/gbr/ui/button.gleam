////
//// UI core button module
////
//// Olá, aqui estamos diante do element botão que é representado aqui através
//// da sua estrutura DOM + a11y, sem estilo visual.

import lustre/attribute as a
import lustre/element as el
import lustre/element/html as h

/// Recebe atributos arbitrários e elementos internos .
///
@internal
pub fn to_element(
  attributes: List(a.Attribute(msg)),
  children elements: List(el.Element(msg)),
) -> el.Element(msg) {
  let attributes = [
    a.type_("button"),
    a.attribute("role", "button"),
    ..attributes
  ]

  h.button(attributes, elements)
}
