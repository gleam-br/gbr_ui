////
//// 🚹 GBR: UI a11y module
////
//// Olá, aqui temos o módulo que ajuda a todos sem distinção!
////
//// O módulo de acessibilidade concentra as regras a11y (ARIA roles).

import gbr/ui/lustre

/// Estado de carregamento.
///
pub fn aria_busy(is_loading: Bool) {
  case is_loading {
    True -> lustre.Attribute("aria-busy", "true")
    False -> lustre.Attribute("aria-busy", "false")
  }
}

/// Descrever elementos visuais (ex: imagens) em leitores de tela.
///
pub fn aria_label(label: String) {
  lustre.Attribute("aria-label", label)
}

/// Descrever elementos usando ref. a outro elemento, exemplo `<h2 id="..." />`.
///
pub fn aria_labelledby(id: String) {
  lustre.Attribute("aria-labelledby", id)
}

/// Ocultar elementos visuais (ex: ícones decorativos) de leitores de tela.
///
pub fn aria_hidden() {
  lustre.Attribute("aria-hidden", "true")
}

/// Indica se o componente está expandido ou não, útil para sidebar menu.
///
pub fn aria_modal(modal: Bool) {
  lustre.Attribute("aria-modal", case modal {
    True -> "true"
    False -> "false"
  })
}

/// Indica se o componente está expandido ou não, útil para sidebar menu.
///
pub fn aria_expanded(expand: Bool) {
  lustre.Attribute("aria-expanded", case expand {
    True -> "true"
    False -> "false"
  })
}
