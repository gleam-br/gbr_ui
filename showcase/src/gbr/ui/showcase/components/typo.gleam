////
////
////

import gleam/option.{type Option, Some}

import lustre/attribute as a
import lustre/element as el
import lustre/element/html as h

import gbr/ui/theme
import gbr/ui/theme/lustre
import gbr/ui/theme/lustre/tailwind/token
import gbr/ui/theme/lustre/typo

pub opaque type Model {
  Model(typo: typo.UITypography, theme: theme.UITheme(lustre.UILustre))
}

pub type Title(msg) {
  Title(
    title: Model,
    subtitle: Option(Model),
    title_attributes: List(a.Attribute(msg)),
    subtitle_attributes: List(a.Attribute(msg)),
  )
}

//
// Construtor
//

pub fn new_theme(is_header) {
  let size_to_text = token.size_text_to_classes(is_header)
  theme.new()
  |> theme.with_size_to_tokens(fn(size) { [size_to_text(size)] })
  |> theme.with_elevation_to_tokens(token.elevation_to_text_shadow_tokens)
}

pub fn new(typo) {
  let is_header = typo.is_header(typo)

  Model(typo:, theme: new_theme(is_header))
}

pub fn with_shadow(typo, elevation) {
  Model(
    ..typo,
    theme: typo.theme
      |> theme.with_elevation(Some(elevation)),
  )
}

//
// -- API
//

pub fn view(model, a, e) {
  let Model(typo:, theme:) = model

  case typo {
    typo.H1 -> typo.h1(theme, a, e)
    typo.H2 -> typo.h2(theme, a, e)
    typo.H3 -> typo.h3(theme, a, e)
    typo.H4 -> typo.h4(theme, a, e)
    typo.H5 -> typo.h5(theme, a, e)
    typo.H6 -> typo.h6(theme, a, e)
    typo.Pre(size:) -> typo.pre(theme, size, a, e)
    typo.Span(size:) -> typo.span(theme, size, a, e)
    typo.Label(size:) -> typo.label(theme, size, a, e)
    typo.Paragraph(size:) -> typo.p(theme, size, a, e)
  }
}

pub fn h1() {
  new(typo.H1)
}

pub fn h2() {
  new(typo.H2)
}

pub fn h3() {
  new(typo.H3)
}

pub fn h4() {
  new(typo.H4)
}

pub fn h5() {
  new(typo.H5)
}

pub fn h6() {
  new(typo.H6)
}

pub fn p(size) {
  new(typo.Paragraph(size))
}

pub fn pre(size) {
  new(typo.Pre(size))
}

pub fn span(size) {
  new(typo.Span(size))
}

pub fn label(size) {
  new(typo.Label(size))
}

pub fn title(title, a, e) {
  let Title(title:, subtitle:, title_attributes:, subtitle_attributes:) = title
  let title = view(title, title_attributes, [])
  let subtitle =
    subtitle
    |> option.map(view(_, subtitle_attributes, []))
    |> option.unwrap(el.none())
  h.div(a, [title, subtitle, ..e])
}
