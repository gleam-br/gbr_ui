////
//// Gleam UI form super element.
////

import gleam/string
import lustre/event

import lustre/attribute as a
import lustre/element/html

import gbr/ui/core.{
  type UIAttrs, type UIRender, type UIRenders, attrs_to_lustre, to_id,
}

type Form =
  UIForm

type Render(a) =
  UIFormRender(a)

type Attrs =
  UIAttrs

/// Form super element.
///
pub opaque type UIForm {
  UIForm(id: String, att: Attrs)
}

/// Form render element.
///
pub type UIFormRender(a) {
  UIFormRender(onsubmit: fn(Attrs) -> a, inner: UIRenders(a))
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

/// Render form super element to `lustre/element/html.{form}`.
///
pub fn render(form: Form, render: Render(a)) -> UIRender(a) {
  let UIForm(id:, att:) = form
  let UIFormRender(inner:, onsubmit:) = render
  let att = attrs_to_lustre(att)

  html.form([a.id(id), event.on_submit(onsubmit)], [html.div(att, inner)])
}
