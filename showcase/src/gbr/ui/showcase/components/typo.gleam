////
////
////

import gleam/option.{type Option}

import lustre/attribute as a
import lustre/element as el
import lustre/element/html as h

import gbr/ui/theme as ui
import gbr/ui/theme/lustre
import gbr/ui/theme/lustre/typo

import gbr/ui/showcase/components/theme

pub opaque type Model {
  Model(typo: typo.UITypography, theme: ui.UITheme(lustre.UILustre))
}

pub fn new(typo) {
  let is_header = typo.is_header(typo)

  Model(typo:, theme: theme.new_typo_theme(is_header))
}

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

pub fn h1(a, e) {
  new(typo.H1)
  |> view(a, e)
}

pub fn h2(a, e) {
  new(typo.H2)
  |> view(a, e)
}

pub fn h3(a, e) {
  new(typo.H3)
  |> view(a, e)
}

pub fn h4(a, e) {
  new(typo.H4)
  |> view(a, e)
}

pub fn h5(a, e) {
  new(typo.H5)
  |> view(a, e)
}

pub fn h6(a, e) {
  new(typo.H6)
  |> view(a, e)
}

pub fn p(size, a, e) {
  new(typo.Paragraph(size))
  |> view(a, e)
}

pub fn pre(size, a, e) {
  new(typo.Pre(size))
  |> view(a, e)
}

pub fn span(size, a, e) {
  new(typo.Span(size))
  |> view(a, e)
}

pub fn label(size, a, e) {
  new(typo.Label(size))
  |> view(a, e)
}

pub type Title(msg) {
  Title(
    title: String,
    subtitle: Option(String),
    title_attributes: List(a.Attribute(msg)),
    subtitle_attributes: List(a.Attribute(msg)),
  )
}

pub fn title(title, a, e) {
  let Title(title:, subtitle:, title_attributes:, subtitle_attributes:) = title
  let title = h1(title_attributes, [h.text(title)])
  let subtitle =
    subtitle
    |> option.map(h.text)
    |> option.map(fn(e) { [e] })
    |> option.map(p(ui.SizeMd, subtitle_attributes, _))
    |> option.unwrap(el.none())

  h.div(a, [title, subtitle, ..e])
}
