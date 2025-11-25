////
//// Gleam UI form super element.
////

import gleam/option.{type Option, None, Some}

import lustre/attribute as a
import lustre/element/html
import lustre/event

import gbr/ui/svg
import gbr/ui/svg/form

import gbr/ui/core/el
import gbr/ui/core/model.{type UIProperties, type UIRender, type UIRenders}

type Form =
  UIForm

type Render(a) =
  UIFormRender(a)

type El =
  el.UIEl

type OnSubmit(a) =
  fn(UIProperties) -> a

/// Form super element.
///
pub opaque type UIForm {
  UIForm(el: El)
}

/// Form render element.
///
pub opaque type UIFormRender(a) {
  UIFormRender(in: Form, inner: UIRenders(a), onsubmit: Option(OnSubmit(a)))
}

/// New form super element.
///
pub fn new(id: String) -> Form {
  UIForm(el: el.new(id))
}

/// Set form class styles.
///
pub fn class(in: Form, class: String) -> Form {
  let el = el.class(in.el, class)

  UIForm(el:)
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
  let UIForm(el:) = in

  let attrs = el.attrs(el)
  let onsubmit =
    onsubmit
    |> option.map(event.on_submit)
    |> option.unwrap(a.none())

  html.form([onsubmit, ..attrs], inner)
}

/// Render form input icon eye to password fields.
/// - open: True is open or close.
/// - attributes: `lustre/attribute.{*}` | `lustre.event.{*}`
///
pub fn eye(open: Bool, attributes: model.UIAttrs(a)) {
  let transform = case open {
    True -> form.eye_open
    False -> form.eye_close
  }

  html.span(attributes, [
    svg.new(20, 20)
    |> transform()
    |> svg.render(),
  ])
}
