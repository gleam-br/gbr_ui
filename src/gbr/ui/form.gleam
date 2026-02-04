////
//// Gleam UI form super element.
////

import gleam/option.{type Option}

import lustre/element/html
import lustre/event

import gbr/ui/core/el
import gbr/ui/core/render

import gbr/ui/core/model.{type UIProperties, type UIRender, type UIRenders}

// Alias
//

type El =
  el.UIEl

type Form =
  UIForm

type Render(a) =
  UIFormRender(a)

type OnSubmit(a) =
  fn(UIProperties) -> a

/// Form super element.
///
pub opaque type UIForm {
  UIForm(el: El)
}

/// Form render element.
///
/// - in: Form type instance (stateless).
/// - render: Form render type instance (statefull).
///
pub opaque type UIFormRender(a) {
  UIFormRender(in: Form, render: render.UIElRender(a))
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

/// Set form autocomplete attribute.
///
pub fn autocomplete(in: Form, autofill: Bool) -> Form {
  let el =
    el.att(in.el, [
      #("autocomplete", case autofill {
        True -> "on"
        False -> "off"
      }),
    ])

  UIForm(el:)
}

/// New form render at inline behavior.
///
pub fn render(in: Form, inner: UIRenders(a)) -> Render(a) {
  let render =
    render.new(in.el)
    |> render.elements(inner)

  UIFormRender(in:, render:)
}

/// Set form render on submit event.
///
pub fn onsubmit(at: Render(a), onsubmit: Option(OnSubmit(a))) -> Render(a) {
  let render =
    at.render
    |> render.attributes_opt(onsubmit, fn(evt) {
      [event.on_submit(evt) |> event.prevent_default()]
    })

  UIFormRender(..at, render:)
}

/// Render form super element to `lustre/element/html.{form}`.
///
pub fn view(at: Render(a)) -> UIRender(a) {
  let #(attrs, inner) = render.views(at.render)

  html.form(attrs, inner)
}
