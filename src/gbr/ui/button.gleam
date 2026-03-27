////
//// UI core button module
////
//// Olá, aqui estamos diante do element botão que é representado aqui através
//// da sua estrutura DOM + a11y, sem estilo visual.

import lustre/attribute as a
import lustre/element as el
import lustre/element/html as h

pub type UIButton {
  ButtonSubmit
  ButtonNormal
  ButtonReset
}

/// Recebe atributos arbitrários e elementos internos .
///
@internal
pub fn to_element(
  button: UIButton,
  attributes: List(a.Attribute(msg)),
  children elements: List(el.Element(msg)),
) -> el.Element(msg) {
  let type_ = button_to_type(button)
  let attributes = [a.type_(type_), a.attribute("role", type_), ..attributes]

  h.button(attributes, elements)
}

fn button_to_type(button: UIButton) {
  case button {
    ButtonSubmit -> "submit"
    ButtonNormal -> "button"
    ButtonReset -> "reset"
  }
}
