////
//// UI core control module
////
//// Olá, aqui estamos no módulo usado para distribuir estruturas e funcionalidades
//// de controle para nossos elementos de UI.
////
//// São comportamentos que se repetem na aplicação para os elementos em geral.
////
//// control.gleam = Vocabulário de Interação (Como o elemento se comporta).

import gleam/option.{type Option}

import gbr/ui/image

/// Representa um controle binário (Ligado/Desligado, Aberto/Fechado).
/// Junta o estado atual temos a mensagem que deve ser disparada ao interagir.
///
pub type Toggle(msg) {
  Toggle(is_active: Bool, on_toggle: msg)
}

/// Representa um clique simples em uma imagem com um opcional de
/// texto seguindo esta imagem obrigatória.
///
pub type Image(msg) {
  Image(image: image.UIImage, label: Option(String), on_click: Option(msg))
}
