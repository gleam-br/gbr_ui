////
//// 🚹 GBR: UI a11y module
////
//// Olá, aqui temos o módulo que ajuda a todos sem distinção!
////
//// O módulo de acessibilidade concentra as regras a11y (ARIA roles).

import lustre/attribute.{type Attribute} as a

/// Estado de carregamento.
///
pub fn aria_busy(is_loading: Bool) -> Attribute(msg) {
  case is_loading {
    True -> a.attribute("aria-busy", "true")
    False -> a.attribute("aria-busy", "false")
  }
}

/// Descrever elementos visuais (ex: imagens) em leitores de tela.
///
pub fn aria_label(label: String) -> Attribute(msg) {
  a.attribute("aria-label", label)
}

/// Descrever elementos usando ref. a outro elemento, exemplo `<h2 id="..." />`.
///
pub fn aria_labelledby(id: String) {
  a.attribute("aria-labelledby", id)
}

/// Ocultar elementos visuais (ex: ícones decorativos) de leitores de tela.
///
pub fn aria_hidden() -> Attribute(msg) {
  a.attribute("aria-hidden", "true")
}

/// Indica se o componente está expandido ou não, útil para sidebar menu.
///
pub fn aria_expanded(expand: Bool) {
  a.attribute("aria-expanded", case expand {
    True -> "true"
    False -> "false"
  })
}
