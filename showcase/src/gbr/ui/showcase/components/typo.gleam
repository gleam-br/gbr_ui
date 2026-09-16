////
////
////

import gleam/option

import lustre/attribute as a
import lustre/element as el
import lustre/element/html as h

import gbr/ui/theme as ui
import gbr/ui/theme/lustre
import gbr/ui/theme/lustre/typo

import gbr/ui/showcase/components/theme

pub type Model {
  Model(typo: typo.UITypography, theme: ui.UITheme(lustre.UILustre))
}

pub fn h1(a, e) {
  theme.new_typo_theme(True)
  |> typo.h1(a, e)
}

pub fn h2(a, e) {
  typo.h2(theme.new_typo_theme(True), a, e)
}

pub fn h3(a, e) {
  typo.h3(theme.new_typo_theme(True), a, e)
}

pub fn h4(a, e) {
  typo.h4(theme.new_typo_theme(True), a, e)
}

pub fn h5(a, e) {
  typo.h5(theme.new_typo_theme(True), a, e)
}

pub fn h6(a, e) {
  typo.h6(theme.new_typo_theme(True), a, e)
}

pub fn p(size, a, e) {
  typo.p(theme.new_typo_theme(False), size, a, e)
}

pub fn pre(size, a, e) {
  typo.pre(theme.new_typo_theme(False), size, a, e)
}

pub fn span(size, a, e) {
  typo.span(theme.new_typo_theme(False), size, a, e)
}

pub fn label(size, a, e) {
  typo.label(theme.new_typo_theme(False), size, a, e)
}

pub fn title(title, subtitle, a, e) {
  let title = h1([a.class("mb-1")], [h.text(title)])
  let subtitle =
    subtitle
    |> option.map(fn(subtitle) { p(ui.SizeSm, [], [h.text(subtitle)]) })
    |> option.unwrap(el.none())

  theme.new_layout_flow_items(ui.SpaceBetween, ui.Start)
  |> lustre.div(a, [
    h.div([a.class("mb-5 sm:mb-8")], [
      title,
      subtitle,
    ]),
    ..e
  ])
}
