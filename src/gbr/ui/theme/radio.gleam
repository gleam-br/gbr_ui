////
//// GBR: UI Theme Radio Module
////

import gleam/option.{type Option, None, Some}

import lustre/attribute as a

import gbr/ui/theme/input

/// Dados de controle do radio button.
///
pub type UIRadio {
  UIRadio(input: input.UIInput, checked: Option(Bool))
}

/// Cria um novo radio button com identificador único e utiliza o nome do grupo
/// de radio buttons ele pertence.
///
/// - id: Identificador único do radio button.
/// - name: Nome do grupo que este radio button faz parte.
///
pub fn new(id, name) {
  let input =
    input.new(id)
    |> input.with_name(name)
    |> input.with_type(input.Radio)

  UIRadio(input:, checked: None)
}

/// Altera se radio está checado ou não.
///
pub fn with_checked(radio, checked) {
  UIRadio(..radio, checked: Some(checked))
}

/// Altera o radio para intocado, útil para limpar fomulários.
///
pub fn without_checked(radio) {
  UIRadio(..radio, checked: None)
}

pub fn view(radio, theme, attributes) {
  let UIRadio(input:, checked:) = radio

  let checked =
    checked
    |> option.map(a.checked)
    |> option.unwrap(a.none())

  input.view(input, theme, [checked, ..attributes])
}
