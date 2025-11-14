////
//// ⌨ Gleam UI typography super element.
////

import gleam/list

import lustre/attribute as a
import lustre/element
import lustre/element/html

import gbr/ui/core.{
  type UIAttrs, type UILabel, type UIRender, type UIRenders, UILabel,
  attrs_to_lustre, uilabel,
}

type Label =
  UILabel

/// List of typos grouped.
///
pub type UITypos =
  List(UITypo)

/// Typo super element.
///
pub opaque type UITypo {
  H1(Label)
  H2(Label)
  H3(Label)
  H4(Label)
  H5(Label)
  Text(Label)
  Paragraph(Label)
  Mark
}

/// H1 super element.
///
pub fn h1(text: String) -> UITypo {
  H1(
    uilabel(text:, att: [#("class", text_color_class), #("class", "text-9xl")]),
  )
}

/// H1 super element.
///
pub fn h2(text: String) -> UITypo {
  H2(
    uilabel(text:, att: [#("class", text_color_class), #("class", "text-8xl")]),
  )
}

/// H3 super element.
///
pub fn h3(text: String) -> UITypo {
  H3(
    uilabel(text:, att: [#("class", text_color_class), #("class", "text-7xl")]),
  )
}

/// H4 super element.
///
pub fn h4(text: String) -> UITypo {
  H4(
    uilabel(text:, att: [#("class", text_color_class), #("class", "text-6xl")]),
  )
}

/// H5 super element.
///
pub fn h5(text: String) -> UITypo {
  H5(
    uilabel(text:, att: [#("class", text_color_class), #("class", "text-5xl")]),
  )
}

/// Text super element.
///
pub fn text(text: String) -> UITypo {
  Text(uilabel(text:, att: [#("class", text_color_class)]))
}

/// Paragraph super element.
///
pub fn p(text: String) -> UITypo {
  Paragraph(uilabel(text:, att: [#("class", text_color_class)]))
}

/// Mark super element.
///
pub fn mark() {
  Mark
}

/// Set primary behavior to typo.
///
pub fn primary(in: UITypo) -> UITypo {
  text_attr(in, #("class", "font-semibold"))
}

/// Set size behavior to typo.
///
pub fn xs(in: UITypo) -> UITypo {
  text_attr(in, #("class", "text-xs"))
}

/// Set size behavior to typo.
///
pub fn sm(in: UITypo) -> UITypo {
  text_attr(in, #("class", "text-sm"))
}

/// Set size behavior to typo.
///
pub fn md(in: UITypo) -> UITypo {
  text_attr(in, #("class", "text-md"))
}

/// Set size behavior to typo.
///
pub fn lg(in: UITypo) -> UITypo {
  text_attr(in, #("class", "text-lg"))
}

/// Set size behavior to typo.
///
pub fn xl(in: UITypo) -> UITypo {
  text_attr(in, #("class", "text-xl"))
}

/// Set style behavior to typo.
///
pub fn bold(in: UITypo) -> UITypo {
  text_attr(in, #("class", "font-medium"))
}

/// Set style behavior to typo.
///
pub fn strong(in: UITypo) -> UITypo {
  text_attr(in, #("class", "font-semibold"))
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
pub fn horizontal(in: UITypos) -> UIRender(a) {
  styled(in, "flex items-center gap-2 text-gray-500 dark:text-gray-400")
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
  case in {
    Text(UILabel(text:, att:)) -> render_text(text, att)
    Paragraph(UILabel(text:, att:)) -> render_p(text, att)
    H1(UILabel(text:, att:)) -> render_h1(text, att)
    H2(UILabel(text:, att:)) -> render_h2(text, att)
    H3(UILabel(text:, att:)) -> render_h3(text, att)
    H4(UILabel(text:, att:)) -> render_h4(text, att)
    H5(UILabel(text:, att:)) -> render_h5(text, att)
    Mark -> render_mark()
  }
}

// PRIVATE
//

fn render_mark() {
  html.span([a.class("h-1 w-1 rounded-full bg-gray-400")], [])
}

fn render_text(text, att) {
  html.span(attrs_to_lustre(att), [html.text(text)])
}

fn render_p(text, att) {
  html.p(attrs_to_lustre(att), [html.text(text)])
}

fn render_h1(text, att) {
  html.h1(attrs_to_lustre(att), [html.text(text)])
}

fn render_h2(text, att) {
  html.h2(attrs_to_lustre(att), [html.text(text)])
}

fn render_h3(text, att) {
  html.h3(attrs_to_lustre(att), [html.text(text)])
}

fn render_h4(text, att) {
  html.h4(attrs_to_lustre(att), [html.text(text)])
}

fn render_h5(text, att) {
  html.h5(attrs_to_lustre(att), [html.text(text)])
}

fn text_attr(in: UITypo, new_att: #(String, String)) -> UITypo {
  case in {
    Mark -> in
    Text(UILabel(text:, att:)) -> Text(UILabel(text:, att: [new_att, ..att]))
    H1(UILabel(text:, att:)) -> H1(UILabel(text:, att: [new_att, ..att]))
    H2(UILabel(text:, att:)) -> H2(UILabel(text:, att: [new_att, ..att]))
    H3(UILabel(text:, att:)) -> H3(UILabel(text:, att: [new_att, ..att]))
    H4(UILabel(text:, att:)) -> H4(UILabel(text:, att: [new_att, ..att]))
    H5(UILabel(text:, att:)) -> H5(UILabel(text:, att: [new_att, ..att]))
    Paragraph(UILabel(text:, att:)) ->
      Paragraph(UILabel(text:, att: [new_att, ..att]))
  }
}

fn group_reduce(in: UITypos) -> Result(UITypo, Nil) {
  use typo, acc <- list.reduce(in)

  case typo {
    Text(UILabel(l, a)) ->
      text_apply(acc, fn(label, att) {
        Text(UILabel(label <> " " <> l, list.append(att, a)))
      })
    Paragraph(UILabel(l, a)) ->
      text_apply(acc, fn(label, att) {
        Paragraph(UILabel(label <> " " <> l, list.append(att, a)))
      })
    H1(UILabel(l, a)) ->
      text_apply(acc, fn(label, att) {
        H1(UILabel(label <> " " <> l, list.append(att, a)))
      })
    H2(UILabel(l, a)) ->
      text_apply(acc, fn(label, att) {
        H2(UILabel(label <> " " <> l, list.append(att, a)))
      })
    H3(UILabel(l, a)) ->
      text_apply(acc, fn(label, att) {
        H3(UILabel(label <> " " <> l, list.append(att, a)))
      })
    H4(UILabel(l, a)) ->
      text_apply(acc, fn(label, att) {
        H4(UILabel(label <> " " <> l, list.append(att, a)))
      })
    H5(UILabel(l, a)) ->
      text_apply(acc, fn(label, att) {
        H5(UILabel(label <> " " <> l, list.append(att, a)))
      })
    Mark -> acc
  }
}

fn text_apply(in: UITypo, apply: fn(String, UIAttrs) -> UITypo) -> UITypo {
  case in {
    Mark -> in
    Paragraph(UILabel(text:, att:))
    | Text(UILabel(text:, att:))
    | H1(UILabel(text:, att:))
    | H2(UILabel(text:, att:))
    | H3(UILabel(text:, att:))
    | H4(UILabel(text:, att:))
    | H5(UILabel(text:, att:)) -> apply(text, att)
  }
}

const text_color_class = "text-gray-800 dark:text-white"
