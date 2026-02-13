////
//// ⚉ Gleam UI button super element.
////
//// Supose button text and svg at left side:
////
////```gleam
//// import gbr/ui/button
////
//// import gbr/ui/svg
//// import gbr/ui/svg/icons
////
//// import gbr/ui/core/model.{type UIRender, uilabel}
////
//// fn render(id: String) -> UIRender(a) {
////   label = uilabel("Button w/ icon back!", [])
////   let inner = [
////     svg.new("button-svg", 20, 20)
////       |> icons.back()
////       |> svg.view()
////     ]
////   ]
////   button.new(id)
////     |> button.label(label)
////     |> button.render_left(inner)
////     |> button.on_click(onclick)
////     |> button.view()
//// }
////```
////
//// ### Roadmap
////
//// 🚧 **Work in progress**
////
//// - [ ] group behavior
//// - [ ] loading behavior
//// - [ ] contrast accessibilty 4:5:1
////

import gleam/list
import gleam/option.{type Option, None, Some}

import lustre/attribute
import lustre/element/html
import lustre/event

import gbr/ui/core/el
import gbr/ui/core/model.{type UIRender, type UIRenders, type UISwitches}
import gbr/ui/core/render

// Alias
//

type El =
  el.UIEl

type Size {
  Sm
  Md
  Lg
}

type Button =
  UIButton

type Render(a) =
  UIButtonRender(a)

/// Button super element.
///
pub opaque type UIButton {
  UIButton(el: El, disabled: Bool, text: Option(String), size: Option(Size))
}

/// Button render type.
///
pub type UIButtonRender(a) {
  UIButtonRender(in: Button, render: render.UIElRender(a))
}

/// New button super element.
///
pub fn new(id: String) -> Button {
  UIButton(el: el.new(id), size: None, disabled: False, text: None)
}

/// Set button label.
///
pub fn label(in: Button, text: String) -> Button {
  UIButton(..in, text: Some(text))
}

/// Set html type attribute
///
pub fn kind(in: Button, kind: String) -> Button {
  let el = el.att(in.el, [#("type", kind)])

  UIButton(..in, el:)
}

/// Set button disabled.
///
pub fn disabled(in: Button, disabled: Bool) -> Button {
  UIButton(..in, disabled:)
}

/// Set button class.
///
pub fn class(in: Button, class: String) -> Button {
  let el = el.class(in.el, class)

  UIButton(..in, el:)
}

pub fn class_append(in: Button, class: String) -> Button {
  let el = el.class_append(in.el, class)

  UIButton(..in, el:)
}

/// Set button classes.
///
pub fn classes(in: Button, classes: UISwitches) -> Button {
  let el = el.classes(in.el, classes)

  UIButton(..in, el:)
}

/// Set button size to medium
///
pub fn sm(in: Button) -> Button {
  UIButton(..in, size: Some(Sm))
}

/// Set button size to medium
///
pub fn md(in: Button) -> Button {
  UIButton(..in, size: Some(Md))
}

/// Set button size to large
///
pub fn lg(in: Button) -> Button {
  UIButton(..in, size: Some(Lg))
}

/// New button render at right inner and onclick event.
///
pub fn render_left(in: Button, inner: UIRenders(a)) -> Render(a) {
  let UIButton(text:, ..) = in

  let inner = case text {
    Some(text) -> list.append(inner, [html.text(text)])
    None -> inner
  }
  let render =
    render.new(in.el)
    |> render.elements(inner)

  UIButtonRender(in:, render:)
}

/// New button render at left inner and onclick event.
///
pub fn render_right(in: Button, inner: UIRenders(a)) -> Render(a) {
  let UIButton(text:, ..) = in
  let inner = case text {
    Some(text) -> [html.text(text), ..inner]
    None -> inner
  }
  let render =
    render.new(in.el)
    |> render.elements(inner)

  UIButtonRender(in:, render:)
}

/// New button render at default.
///
pub fn render(in: Button, inner: UIRenders(a)) -> Render(a) {
  let UIButton(text:, ..) = in
  let inner = case text {
    Some(text) -> [html.text(text), ..inner]
    None -> inner
  }
  let render =
    render.new(in.el)
    |> render.elements(inner)

  UIButtonRender(in:, render:)
}

/// Set button render onclick event.
///
pub fn onclick(at: Render(a), onclick: Option(a)) -> Render(a) {
  let render =
    render.attributes_opt(at.render, onclick, fn(evt) { [event.on_click(evt)] })

  UIButtonRender(..at, render:)
}

/// Render button super element to `lustre/element.{type Element}`.
///
pub fn view(at: Render(a)) -> UIRender(a) {
  let UIButtonRender(in:, render:) = at
  let UIButton(disabled:, size:, ..) = in

  let #(attrs, inner) =
    render
    |> render.attributes([
      attribute.disabled(disabled),
      attribute.classes([
        #("px-4 py-3", size == Some(Md)),
        #("px-5 py-3.5", size == Some(Lg)),
        #("px-0 py-0", size == Some(Sm)),
      ]),
    ])
    |> render.views()

  html.button(attrs, inner)
}
