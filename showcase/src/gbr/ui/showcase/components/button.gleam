////
////
////

import gleam/option.{Some}

import gbr/ui/theme
import gbr/ui/theme/lustre
import gbr/ui/theme/lustre/button
import gbr/ui/theme/lustre/tailwind/token

import gbr/ui/showcase/components/button/button_token

pub fn new_theme() {
  theme.new()
  |> theme.with_base_to_tokens(fn() { [] })
  |> theme.with_design_to_tokens(button_token.button_design_tokens)
  |> theme.with_shape_to_tokens(token.shape_rounded_to_tokens)
  |> theme.with_size_to_tokens(button_token.button_size_tokens)
  |> theme.with_stacking_to_tokens(token.stack_to_zindex_tokens)
  |> theme.with_elevation_to_tokens(token.elevation_to_border_tokens)
}

pub opaque type Model {
  Model(button: button.UIButton, theme: theme.UITheme(lustre.UILustre))
}

pub fn normal() {
  Model(button: button.Normal, theme: new_theme())
}

pub fn submit() {
  Model(button: button.Submit, theme: new_theme())
}

pub fn reset() {
  Model(button: button.Reset, theme: new_theme())
}

pub fn link(href, target) {
  Model(button: button.Link(href:, target:), theme: new_theme())
}

pub fn view(model, a, e) {
  let Model(button:, theme:) = model

  button.view(button, theme, a, e)
}

pub fn primary(model) {
  with_variant(model, theme.VariantPrimary)
}

pub fn secondary(model) {
  with_variant(model, theme.VariantSecondary)
}

pub fn tertiary(model) {
  with_variant(model, theme.VariantTertiary)
}

pub fn filled(model) {
  with_appearance(model, theme.AppearanceFilled)
}

pub fn light(model) {
  with_appearance(model, theme.AppearanceLight)
}

pub fn ghost(model) {
  with_appearance(model, theme.AppearanceGhost)
}

pub fn with_variant(model, variant) {
  Model(
    ..model,
    theme: model.theme
      |> theme.with_variant(variant),
  )
}

pub fn with_appearance(model, appearance) {
  Model(
    ..model,
    theme: model.theme
      |> theme.with_appearance(appearance),
  )
}

pub fn with_shape(model, shape) {
  Model(
    ..model,
    theme: model.theme
      |> theme.with_shape(Some(shape)),
  )
}

pub fn with_size(model, size) {
  Model(
    ..model,
    theme: model.theme
      |> theme.with_size(Some(size)),
  )
}

pub fn with_elevation(model, elevation) {
  Model(
    ..model,
    theme: model.theme
      |> theme.with_elevation(Some(elevation)),
  )
}
