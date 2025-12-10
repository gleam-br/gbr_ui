////
//// 📝 Gleam UI core description super element.
////

import gbr/ui/typo
import lustre/element/html

import gbr/ui/core/el
import gbr/ui/core/model.{type UIRender, type UIRenders}

type El =
  el.UIEl

type Desc =
  UIDesc

type Typo =
  typo.UITypo

type Render(a) =
  UIDescRender(a)

/// Text with a description
///
/// - text: Like a title of something
/// - desc: Description of this text/title.
///
pub opaque type UIDesc {
  UIDesc(el: El, title: Typo, content: Typo)
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
/// - title: Title of description
/// - content: Content of description
///
pub fn new(title: String, content: String) -> Desc {
  UIDesc(el: el.new("desc"), title: typo.h4(title), content: typo.p(content))
}

pub fn title(in: Desc, title: String) -> Desc {
  let title = typo.text(in.title, title)

  UIDesc(..in, title:)
}

pub fn content(in: Desc, content: String) -> Desc {
  let content = typo.text(in.content, content)

  UIDesc(..in, content:)
}

/// Replace class attribute
///
pub fn class(in: Desc, class: String) -> Desc {
  let el = el.class(in.el, class)

  UIDesc(..in, el:)
}

/// Replace text class attribute
///
pub fn class_title(in: Desc, class: String) -> Desc {
  let title = typo.class(in.title, class)

  UIDesc(..in, title:)
}

/// Replace description class attribute
///
pub fn class_content(in: Desc, class: String) -> Desc {
  let content = typo.class(in.content, class)

  UIDesc(..in, content:)
}

/// new desc render element
///
/// - in: Desc info
///
pub fn render(in: Desc, inner: UIRenders(a)) -> Render(a) {
  UIDescRender(in:, inner:)
}

/// Render description element
///
pub fn view(at: Render(a)) -> UIRender(a) {
  let UIDescRender(in:, inner:) = at
  let UIDesc(el:, title:, content:) = in

  let attrs = el.attrs(el)
  let title = typo.view(title)
  let content = typo.view(content)

  html.div(attrs, [title, content, ..inner])
}
