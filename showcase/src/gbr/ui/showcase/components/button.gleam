////
////
////

import gleam/option.{Some}

import gbr/ui/theme as ui
import gbr/ui/theme/lustre
import gbr/ui/theme/lustre/button

import gbr/ui/showcase/components/theme

pub opaque type Model {
  Model(button: button.UIButton, theme: ui.UITheme(lustre.UILustre))
}

pub fn normal() {
  Model(button: button.Normal, theme: theme.new_button_theme())
}

pub fn submit() {
  Model(button: button.Submit, theme: theme.new_button_theme())
}

pub fn reset() {
  Model(button: button.Reset, theme: theme.new_button_theme())
}

pub fn link(href, target) {
  Model(button: button.Link(href:, target:), theme: theme.new_button_theme())
}

pub fn view(model, a, e) {
  let Model(button:, theme:) = model

  button.view(button, theme, a, e)
}

pub fn primary(model) {
  Model(
    ..model,
    theme: model.theme
      |> ui.with_variant(ui.VariantPrimary),
  )
}

pub fn secondary(model) {
  Model(
    ..model,
    theme: model.theme
      |> ui.with_variant(ui.VariantSecondary),
  )
}

pub fn tertiary(model) {
  Model(
    ..model,
    theme: model.theme
      |> ui.with_variant(ui.VariantTertiary),
  )
}

pub fn filled(model) {
  Model(
    ..model,
    theme: model.theme
      |> ui.with_appearance(ui.AppearanceFilled),
  )
}

pub fn light(model) {
  Model(
    ..model,
    theme: model.theme
      |> ui.with_appearance(ui.AppearanceLight),
  )
}

pub fn ghost(model) {
  Model(
    ..model,
    theme: model.theme
      |> ui.with_appearance(ui.AppearanceGhost),
  )
}

pub fn size(model, size) {
  Model(
    ..model,
    theme: model.theme
      |> ui.with_size(Some(size)),
  )
}
