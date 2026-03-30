////
//// 🕹️ UI core control module
////
//// Olá, aqui estamos no módulo usado para distribuir estruturas e funcionalidades
//// de controle para nossos elementos de UI.
////
//// São comportamentos que se repetem na aplicação para os elementos em geral.
////
//// control.gleam = Vocabulário de Interação (Como o elemento se comporta).

import gleam/option.{type Option}

import gbr/ui/image
import gbr/ui/input

/// Representa um controle binário (Ligado/Desligado, Aberto/Fechado).
/// Junta o estado atual temos a mensagem que deve ser disparada ao interagir.
///
pub type Toggle(msg) {
  Toggle(is_active: Bool, label: Option(String), on_toggle: msg)
}

/// Representa um clique simples em uma imagem com um opcional de
/// texto seguindo esta imagem obrigatória.
///
pub type Image(msg) {
  Image(image: image.UIImage, label: Option(String), on_click: Option(msg))
}

/// Representa um input contendo valor, uma nota opicional e o evento para
/// capturar as alterações de valor no input (FP two-way-data-bind).
pub type Input(msg) {
  Input(input: input.UIInput, on_input: fn(String) -> msg)
}
