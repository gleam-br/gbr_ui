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
pub fn h4(text: String) -> UITypo {
  UITypo(el.new("h4"), text:, behavior: H4)
}

/// Paragraph super element.
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

/// Render inline typos layout.
///
pub fn inline(in: UITypos) -> UIRender(a) {
  case group_reduce(in) {
    Ok(inline) -> render(inline)
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

  render(typo)
}

/// Render typo super element to `lustre/element.{type Element}`.
///
pub fn render(in: UITypo) -> UIRender(a) {
  let UITypo(el:, text:, behavior:) = in

  let attrs = el.attrs(el)

  case behavior {
    H4 -> html.h4(attrs, [html.text(text)])
    Text -> html.span(attrs, [html.text(text)])
    Paragraph -> html.p(attrs, [html.text(text)])
    Label(id) -> html.label([a.for(id), ..attrs], [html.text(text)])
  }
}

// PRIVATE
//

fn group_reduce(in: UITypos) -> Result(UITypo, Nil) {
  use typo, acc <- list.reduce(in)

  UITypo(..acc, text: typo.text <> " " <> acc.text)
}
