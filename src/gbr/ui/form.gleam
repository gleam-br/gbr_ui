////
//// Gleam UI form super element.
////

import gleam/option.{type Option, None, Some}
import gleam/string

import lustre/attribute as a
import lustre/element/html
import lustre/event

import gbr/ui/svg
import gbr/ui/svg/form

import gbr/ui/core.{
  type UIAttributes, type UIAttrs, type UIRender, type UIRenders,
  attrs_to_lustre, to_id,
}

type Form =
  UIForm

type Render(a) =
  UIFormRender(a)

type Att =
  UIAttrs

/// Form super element.
///
pub opaque type UIForm {
  UIForm(id: String, att: Att)
}

type OnSubmit(a) =
  fn(Att) -> a

/// Form render element.
///
pub opaque type UIFormRender(a) {
  UIFormRender(in: Form, inner: UIRenders(a), onsubmit: Option(OnSubmit(a)))
}

/// New form super element.
///
pub fn new(id: String) -> Form {
  UIForm(id: to_id(id), att: [])
}

/// Set form class styles.
///
pub fn classes(in: Form, classes: List(String)) -> Form {
  UIForm(..in, att: [#("class", string.join(classes, " ")), ..in.att])
}

/// New form render at default behavior.
///
pub fn at(in: Form) -> Render(a) {
  UIFormRender(in:, inner: [], onsubmit: None)
}

/// New form render at inline behavior.
///
pub fn at_inline(in: Form, inner: UIRenders(a)) -> Render(a) {
  UIFormRender(in:, inner:, onsubmit: None)
}

/// Set form render on submit event.
///
pub fn on_submit(in: Render(a), onsubmit: OnSubmit(a)) -> Render(a) {
  UIFormRender(..in, onsubmit: Some(onsubmit))
}

/// Render form super element to `lustre/element/html.{form}`.
///
pub fn render(at: Render(a)) -> UIRender(a) {
  let UIFormRender(in:, inner:, onsubmit:) = at
  let UIForm(id:, att:) = in
  let att = attrs_to_lustre(att)
  let onsubmit =
    option.map(onsubmit, event.on_submit)
    |> option.unwrap(a.none())

  html.form([a.id(id), onsubmit], [html.div(att, inner)])
}

/// Render form input icon eye to password fields.
/// - open: True is open or close.
/// - attributes: `lustre/attribute.{*}` | `lustre.event.{*}`
///
pub fn eye(open: Bool, attributes: UIAttributes(a)) {
  let #(id, transform) = case open {
    True -> #("form-icon-eye-open", form.eye_open)
    False -> #("form-icon-eye-close", form.eye_close)
  }

  html.span(attributes, [
    svg.new(id, 20, 20)
    |> transform()
    |> svg.render(),
  ])
}
