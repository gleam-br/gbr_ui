////
//// 📝 Gleam UI core description super element.
////

import gleam/option.{type Option, None}

import lustre/element
import lustre/element/html

import gbr/ui/core/el
import gbr/ui/core/model.{type UIRender}

import gbr/ui/link

type El =
  el.UIEl

type Desc =
  UIDesc

type Render(a) =
  UIDescRender(a)

type Link(a) =
  Option(link.UILinkRender(a))

/// Text with a description
///
/// - text: Like a title of something
/// - desc: Description of this text/title.
///
pub opaque type UIDesc {
  UIDesc(el: El, text: String, desc: String)
}

/// Desc render element
///
/// - in: Description info
///
pub opaque type UIDescRender(a) {
  UIDescRender(in: Desc, link: Link(a))
}

/// New description super element
///
/// - el: Element info
///
pub fn new(el: El) -> Desc {
  UIDesc(el:, text: "", desc: "")
}

/// Replace text description
///
/// - text: Like a title of something
///
pub fn text(in: Desc, text: String) -> Desc {
  UIDesc(..in, text:)
}

/// Replace desc
///
/// - desc: Description of text/title.
///
pub fn desc(in: Desc, desc: String) -> Desc {
  UIDesc(..in, desc:)
}

/// Replace class attribute
///
pub fn class(in: Desc, class: String) -> Desc {
  let el = el.class(in.el, class)

  UIDesc(..in, el:)
}

/// Replace text class attribute
///
pub fn class_text(in: Desc, class: String) -> Desc {
  let el = el.class_key(in.el, "text", class)

  UIDesc(..in, el:)
}

/// Replace description class attribute
///
pub fn class_desc(in: Desc, class: String) -> Desc {
  let el = el.class_key(in.el, "desc", class)

  UIDesc(..in, el:)
}

/// new desc render element
///
/// - in: Desc info
///
pub fn at(in: Desc) -> Render(a) {
  UIDescRender(in:, link: None)
}

/// Replace link
///
/// - desc: Description of text/title.
///
pub fn link(in: Render(a), link: Link(a)) -> Render(a) {
  UIDescRender(..in, link:)
}

pub fn render(at: Render(a)) -> UIRender(a) {
  let UIDescRender(in:, link:) = at
  let UIDesc(el:, text:, desc:) = in

  let attrs = el.attrs(el)
  let text_attrs = el.attrs_key(el, "text")
  let desc_attrs = el.attrs_key(el, "desc")

  let text = html.span(text_attrs, [html.text(text)])
  let desc = html.p(desc_attrs, [html.text(desc)])
  let link =
    option.map(link, link.render)
    |> option.unwrap(element.none())

  html.div(attrs, [
    text,
    desc,
    link,
  ])
}
