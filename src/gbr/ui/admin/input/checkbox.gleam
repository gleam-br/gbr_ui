////
//// ✅ Gleam UI input type checkbox super element.
////

import gbr/ui/core/el
import gleam/option.{type Option, None}

import lustre/attribute as a
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

import gbr/ui/svg
import gbr/ui/svg/form as svg_form
import gbr/ui/typo

type Checkbox =
  UICheckbox

type Render(a) =
  UICheckboxRender(a)

type Text =
  typo.UITypo

/// Checkbox super element.
///
pub opaque type UICheckbox {
  UICheckbox(el: el.UIEl, label: Text, checked: Bool)
}

/// Checkbox render type.
///
pub type UICheckboxRender(a) {
  UICheckboxRender(in: Checkbox, onclick: Option(fn(Bool) -> a), checked: Bool)
}

/// New checkbox super element.
///
pub fn new(id: String) -> Checkbox {
  let el = el.new(id)
  let label =
    typo.label(id, "")
    |> typo.class(
      "flex cursor-pointer items-center text-sm text-gray-700 select-none dark:text-gray-400",
    )

  UICheckbox(el:, label:, checked: False)
}

/// Set checkbox checked or not.
///
pub fn checked(in: Checkbox, checked: Bool) -> Checkbox {
  let value = case checked {
    True -> "true"
    False -> "false"
  }
  let el = el.att(in.el, [#("value", value)])

  UICheckbox(..in, el:, checked:)
}

pub fn get(in: Checkbox) -> Bool {
  in.checked
}

/// Toggle checkbox checked or not.
///
pub fn toggle(in: Checkbox) -> Checkbox {
  checked(in, !in.checked)
}

/// Set checkbox label.
///
pub fn label(in: Checkbox, label: String) -> Checkbox {
  let label = typo.text(in.label, label)

  UICheckbox(..in, label:)
}

/// New checkbox render.
///
pub fn render(in: Checkbox) -> Render(a) {
  let checked = in.checked

  UICheckboxRender(in:, checked:, onclick: None)
}

/// Set checkbox render onclick event.
///
pub fn onclick(at: Render(a), onclick: Option(fn(Bool) -> a)) -> Render(a) {
  UICheckboxRender(..at, onclick:)
}

/// Render checkbox super element to `lustre/element.{type Element}`.
///
pub fn view(at: Render(a)) -> Element(a) {
  let UICheckboxRender(in:, onclick:, checked:) = at
  let UICheckbox(el:, label:, ..) = in

  let onclick =
    onclick
    |> option.map(fn(myonclick) {
      myonclick(!checked)
      |> event.on_click()
    })
    |> option.unwrap(a.none())

  let id = el.id_get(el)
  let value =
    el.att_get(in.el, "value")
    |> option.unwrap("false")
  html.div([], [
    typo.render_left(label, [
      html.div([a.class("relative")], [
        html.input([
          a.id(id),
          a.name(id),
          a.class("sr-only"),
          a.type_("checkbox"),
          a.value(value),
          a.checked(checked),
          onclick,
        ]),
        html.div(
          [
            a.classes([
              #("border-brand-500 bg-brand-500", checked),
              #("bg-transparent border-gray-300 dark:border-gray-700", !checked),
            ]),
            a.class(
              "mr-3 flex h-5 w-5 items-center justify-center rounded-md border-[1.25px]",
            ),
          ],
          [
            html.span([a.classes([#("opacity-0", !checked)])], [
              svg.new(14, 14)
              |> svg_form.checkbox()
              |> svg.view(),
            ]),
          ],
        ),
      ]),
    ]),
  ])
}
