////
//// GBR: UI Storybook Module
////

import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/option
import gleam/result
import gleam/string

import lustre
import lustre/element.{type Element}

/// Função para renderizar um elemento lustre no storybook.
///
pub fn render(view) {
  let renderer = ffi_do_render(mount)
  fn(args, context) { renderer(args, context, view) }
}

/// Função auxiliar para decodificar os argumentos vindos do storybook
///
pub fn decode(args, field, fallback, to_decode) {
  do_decode(field, fallback, to_decode)
  |> decode.run(args, _)
  |> result.unwrap(fallback)
}

/// Decodifica um campo de um objeto `Dynamic`, retornando um `Result`.
///
pub fn decode_field_try(args, field, decoder) {
  let decoder = {
    use field <- decode.field(field, decoder)
    decode.success(field)
  }

  decode.run(args, decoder)
}

/// Decodifica um campo opcional; caso falhe ou não exista, retorna o valor `fallback`.
///
pub fn decode_field(args, field, fallback, decoder) {
  decode(args, field, "", decode.string)
  |> string.to_option
  |> option.map(decoder)
  |> option.unwrap(fallback)
}

/// Decodifica um campo de texto opcional, retornando um `Option(String)`.
///
pub fn decode_field_optional(args, field) {
  decode(args, field, "", decode.string)
  |> string.to_option
}

//
// -- Interno
//

/// Tipo opaco que representa o retorno da função do_render ffi.
///
type Render(args, context, view, element) =
  fn(args, context, view) -> element

@external(javascript, "../../storybook_ffi.mjs", "do_render")
fn ffi_do_render(mount: f) -> Render(args, context, view, element)

/// Função que monta o componente lustre no storybook.
///
fn mount(
  selector: String,
  args: Dynamic,
  story_view: fn(Dynamic) -> Element(any_msg),
  on_action: fn(String) -> Nil,
) {
  let app =
    lustre.simple(
      init: fn(_) { Nil },
      update: fn(_model, msg_str) {
        // Repassa a string formatada para o wrapper do NPM (Storybook Actions)
        on_action(msg_str)
        Nil
      },
      view: fn(_model) {
        // 1. Injeta os argumentos (Dynamic) na função view da story
        // 2. Converte qualquer Tipo Customizado (Msg) em String
        story_view(args)
        |> element.map(string.inspect)
      },
    )

  // Inicia a aplicação no seletor injetado pelo DOM Observer em js/*
  case lustre.start(app, selector, Nil) {
    Ok(_) -> Nil
    Error(_) -> panic as "Erro ao montar o Lustre no DOM do Storybook"
  }
}

fn do_decode(field, fallback, to_decode) {
  use value <- decode.optional_field(field, fallback, to_decode)

  value
  |> decode.success()
}
