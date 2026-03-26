////
//// UI core a11y
////
//// Olá, aqui temos o módulo que ajuda a todos sem distinção o módulo de
//// Acessibilidade são os (ARIA roles). Pertencem ao core pois são
//// contratos do HTML e não de estilo.

import lustre/attribute.{type Attribute}

/// Estado de carregamento.
///
pub fn aria_busy(is_loading: Bool) -> Attribute(msg) {
  case is_loading {
    True -> attribute.attribute("aria-busy", "true")
    False -> attribute.attribute("aria-busy", "false")
  }
}

/// Atributo para ocultar elementos puramente visuais (ex: ícones decorativos) de leitores de tela.
///
pub fn aria_label(label: String) -> Attribute(msg) {
  attribute.attribute("aria-label", label)
}

/// Atributo para ocultar elementos puramente visuais (ex: ícones decorativos) de leitores de tela.
///
pub fn aria_hidden() -> Attribute(msg) {
  attribute.attribute("aria-hidden", "true")
}
