////
//// ⌨ Gleam UI typography super element.
////

import gleam/list

import lustre/attribute as a
import lustre/element
import lustre/element/html

import gbr/ui/core/el
import gbr/ui/core/model.{type UIRender, type UIRenders}

/// List of typos grouped.
///
type Behavior {
  H1
  H2
  H3
  H4
  Text
  Paragraph
  Label(String)
}

pub type UITypos =
  List(UITypo)

/// Typo super element.
///
pub opaque type UITypo {
  UITypo(el: el.UIEl, text: String, behavior: Behavior)
}

/// Text super element.
///
pub fn span(text: String) -> UITypo {
  UITypo(el.new("span"), text:, behavior: Text)
}

/// Text super element.
///
pub fn h1(text: String) -> UITypo {
  UITypo(el.new("h1"), text:, behavior: H1)
}

/// Text super element.
///
pub fn h2(text: String) -> UITypo {
  UITypo(el.new("h2"), text:, behavior: H2)
}

/// Text super element.
///
pub fn h3(text: String) -> UITypo {
  UITypo(el.new("h3"), text:, behavior: H3)
}

/// Text super element.
///
pub fn h4(text: String) -> UITypo {
  UITypo(el.new("h4"), text:, behavior: H4)
}

/// Paragraph super element.
///
/// - text: Text of paragraph
///
pub fn p(text: String) -> UITypo {
  UITypo(el.new("text-p"), text:, behavior: Paragraph)
}

/// Paragraph super element.
///
pub fn label(for: String, text: String) -> UITypo {
  UITypo(el.new("text-label"), text:, behavior: Label(for))
}

/// Replace text string in typo element
///
/// - text: Text to replace
///
/// > For construct see `span` or `p` or `h4`
///
pub fn text(in: UITypo, text: String) -> UITypo {
  UITypo(..in, text:)
}

/// Set typo class attribute
///
/// - class: Class attribute value
///
pub fn class(in: UITypo, class: String) -> UITypo {
  let el = el.class(in.el, class)

  UITypo(..in, el:)
}

/// Set typo class attribute
///
/// - class: Class attribute value
///
pub fn classes(in: UITypo, classes: model.UISwitches) -> UITypo {
  let el = el.classes(in.el, classes)

  UITypo(..in, el:)
}

/// Render inline typos layout.
///
pub fn inline(in: UITypos) -> UIRender(a) {
  case group_reduce(in) {
    Ok(inline) -> view(inline)
    Error(Nil) -> element.none()
  }
}

/// Render horizontal typos layout.
///
pub fn styled(in: UITypos, class: String) -> UIRender(a) {
  html.span([a.class(class)], grouped(in))
}

/// Render grouped typos layout.
///
pub fn grouped(in: UITypos) -> UIRenders(a) {
  use typo <- list.map(in)

  view(typo)
}

/// Render typo super element to `lustre/element.{type Element}`.
///
pub fn view(in: UITypo) -> UIRender(a) {
  render_inner(in, [html.text(in.text)])
}

pub fn render_right(in: UITypo, inner: UIRenders(a)) -> UIRender(a) {
  let inner = [html.text(in.text), ..inner]

  render_inner(in, inner)
}

pub fn render_left(in: UITypo, inner: UIRenders(a)) -> UIRender(a) {
  let inner = list.append(inner, [html.text(in.text)])

  render_inner(in, inner)
}

// PRIVATE
//

fn render_inner(in: UITypo, inner: UIRenders(a)) -> UIRender(a) {
  let UITypo(el:, behavior:, ..) = in

  let attrs = el.attrs(el)

  case behavior {
    H1 -> html.h1(attrs, inner)
    H2 -> html.h2(attrs, inner)
    H3 -> html.h3(attrs, inner)
    H4 -> html.h4(attrs, inner)
    Text -> html.span(attrs, inner)
    Paragraph -> html.p(attrs, inner)
    Label(id) -> html.label([a.for(id), ..attrs], inner)
  }
}

fn group_reduce(in: UITypos) -> Result(UITypo, Nil) {
  use typo, acc <- list.reduce(in)

  UITypo(..acc, text: typo.text <> " " <> acc.text)
}
