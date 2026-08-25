////
//// GBR: UI Theme Checkbox Module
////

import gleam/option.{type Option, None, Some}

import lustre/attribute as a

import gbr/ui/theme/input

/// Dados de controle do checkbox.
///
pub type UICheckbox {
  UICheckbox(input: input.UIInput, checked: Option(Bool))
}

/// Cria novo checkbox com identificador único.
///
pub fn new(id) {
  UICheckbox(
    input: input.new(id)
      |> input.with_type(input.Checkbox),
    checked: None,
  )
}

/// Altera o nome do checkbox.
///
pub fn with_name(checkbox, name) {
  UICheckbox(..checkbox, input: input.with_name(checkbox.input, name))
}

/// Altera o valor do checkbox.
///
pub fn with_value(checkbox, value) {
  UICheckbox(..checkbox, input: input.with_value(checkbox.input, value))
}

/// Altera o valor de checado ou não.
///
pub fn with_checked(checkbox, checked) {
  UICheckbox(..checkbox, checked: Some(checked))
}

/// Visualiza o checkbox com os dados carregados no modelo.
///
/// - checkbox: Modelo de dados.
/// - theme: Tema utilizado.
/// - attributes: Atributos html, adicionais.
///
pub fn view(checkbox, theme, attributes) {
  let UICheckbox(input:, checked:) = checkbox

  let checked =
    checked
    |> option.map(a.checked)
    |> option.unwrap(a.none())

  let attributes = [checked, ..attributes]

  input.view(input, theme, attributes)
}
