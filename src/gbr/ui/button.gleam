////
//// 🎛️ UI core button module
////
//// Olá, aqui estamos diante do elemento botão que é representado aqui através
//// da sua estrutura DOM + a11y, sem estilo visual.

import lustre/attribute as a
import lustre/element as el

import gbr/ui/theme

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
  theme,
  attributes: List(a.Attribute(msg)),
  children elements: List(el.Element(msg)),
) -> el.Element(msg) {
  let type_ = button_to_type(button)
  let attributes = [a.type_(type_), a.attribute("role", type_), ..attributes]

  theme.button(theme, attributes, elements)
}

// PRIVATE
//

fn button_to_type(button: UIButton) {
  case button {
    ButtonSubmit -> "submit"
    ButtonNormal -> "button"
    ButtonReset -> "reset"
  }
}
