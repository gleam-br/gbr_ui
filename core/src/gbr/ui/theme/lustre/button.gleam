////
//// 🎛️ UI Tailwindcss Button Module
////
//// Olá, aqui temos o módulo que permite mostrarmos botões na tela utilizando
//// `lustre/element/html.button`.
////

import gleam/option.{type Option}

import lustre/attribute as a
import lustre/element as el

import gbr/ui/theme/lustre

//
// -- Tipos
//

/// Dados do botão.
pub type UIButton {
  Submit
  Normal
  Reset
  Link(href: String, target: Option(String))
}

/// Visualizar um botão temático.
///
pub fn view(
  button: UIButton,
  theme theme,
  attributes attributes: List(a.Attribute(msg)),
  elements elements: List(el.Element(msg)),
) -> el.Element(msg) {
  case button {
    Link(href:, target:) -> view_link(theme, href, target, attributes, elements)
    _ -> {
      let type_ = button_to_type(button)
      let attributes = [
        a.type_(type_),
        a.attribute("role", type_),
        ..attributes
      ]

      lustre.button(theme, attributes, elements)
    }
  }
}

// -----------------------------------------------------------------------------
//
// -- Auxiliares (Interno)
//
// -----------------------------------------------------------------------------

fn view_link(theme, href, target, attributes, elements) {
  let attributes = [
    a.href(href),
    target
      |> option.map(a.target)
      |> option.unwrap(a.none()),
    ..attributes
  ]

  lustre.button(theme, attributes, elements)
}

fn button_to_type(button: UIButton) -> String {
  case button {
    Submit -> "submit"
    Reset -> "reset"
    _ -> "button"
  }
}
