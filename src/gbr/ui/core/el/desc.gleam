////
//// 📝 Gleam UI core description super element.
////

import lustre/element/html

import gbr/ui/core/el
import gbr/ui/core/model.{type UIRender, type UIRenders}

type El =
  el.UIEl

type Desc =
  UIDesc

type Render(a) =
  UIDescRender(a)

/// Text with a description
///
/// - text: Like a title of something
/// - desc: Description of this text/title.
///
pub opaque type UIDesc {
  UIDesc(el: El, text_: String, desc_: String)
}

/// Desc render element
///
/// - in: Description info
///
pub opaque type UIDescRender(a) {
  UIDescRender(in: Desc, inner: UIRenders(a))
}

/// New description super element
///
/// - el: Element info
///
pub fn new(el: El) -> Desc {
  UIDesc(el:, text_: "", desc_: "")
}

/// Replace text description
///
/// - text: Like a title of something
///
pub fn text(in: Desc, text_: String) -> Desc {
  UIDesc(..in, text_:)
}

/// Replace desc
///
/// - desc: Description of text/title.
///
pub fn desc(in: Desc, desc_: String) -> Desc {
  UIDesc(..in, desc_:)
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
  UIDescRender(in:, inner: [])
}

/// Replace link
///
/// - desc: Description of text/title.
///
pub fn inner(in: Render(a), inner: UIRenders(a)) -> Render(a) {
  UIDescRender(..in, inner:)
}

/// Render description element
///
pub fn render(at: Render(a)) -> UIRender(a) {
  let UIDescRender(in:, inner:) = at
  let UIDesc(el:, text_:, desc_:) = in

  let attrs = el.attrs(el)
  let text_attrs = el.attrs_key(el, "text")
  let desc_attrs = el.attrs_key(el, "desc")

  let text_ = html.span(text_attrs, [html.text(text_)])
  let desc_ = html.p(desc_attrs, [html.text(desc_)])

  html.div(attrs, [text_, desc_, ..inner])
}
