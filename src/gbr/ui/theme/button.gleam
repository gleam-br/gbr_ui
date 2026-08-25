////
//// 🎛️ UI Tailwindcss Button Module
////
//// Olá, aqui temos o módulo que permite mostrarmos botões na tela utilizando
//// `lustre/element/html.button`.
////

import lustre/attribute as a
import lustre/element as el

import gbr/ui/theme

//
// -- Tipos
//

/// Dados do botão.
pub type UIButton {
  Submit
  Normal
  Reset
}

/// Visualizar um botão temático.
///
pub fn view(
  button: UIButton,
  theme theme,
  attributes attributes: List(a.Attribute(msg)),
  elements elements: List(el.Element(msg)),
) -> el.Element(msg) {
  let type_ = button_to_type(button)
  let attributes = [a.type_(type_), a.attribute("role", type_), ..attributes]

  theme.button(theme, attributes, elements)
}

// -----------------------------------------------------------------------------
//
// -- Auxiliares (Interno)
//
// -----------------------------------------------------------------------------

fn button_to_type(button: UIButton) -> String {
  case button {
    Submit -> "submit"
    Normal -> "button"
    Reset -> "reset"
  }
}
