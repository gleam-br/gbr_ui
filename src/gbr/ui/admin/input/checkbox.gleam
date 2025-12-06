////
//// ✅ Gleam UI input type checkbox super element.
////

import gleam/option.{type Option, None, Some}
import lustre/event

import lustre/attribute as a
import lustre/element.{type Element}
import lustre/element/html

import gbr/ui/input
import gbr/ui/typo

import gbr/ui/svg
import gbr/ui/svg/form as svg_form

type Checkbox =
  UICheckbox

type Render(a) =
  UICheckboxRender(a)

type Text =
  typo.UITypo

/// Checkbox super element.
///
pub opaque type UICheckbox {
  UICheckbox(id: String, label: Text, checked: Bool)
}

/// Checkbox render type.
///
pub type UICheckboxRender(a) {
  UICheckboxRender(in: Checkbox, onclick: Option(a), checked: Bool)
}

/// New checkbox super element.
///
pub fn new(id: String) -> Checkbox {
  let label =
    typo.label(id, "")
    |> typo.class(
      "flex cursor-pointer items-center text-sm font-normal text-gray-700 select-none dark:text-gray-400",
    )

  UICheckbox(id:, label:, checked: False)
}

/// Set checkbox checked or not.
///
pub fn checked(in: Checkbox, checked: Bool) -> Checkbox {
  UICheckbox(..in, checked:)
}

/// Set checkbox label.
///
pub fn label(in: Checkbox, label: String) -> Checkbox {
  let label = typo.text(in.label, label)

  UICheckbox(..in, label:)
}

/// New checkbox render.
///
pub fn at(in: Checkbox) -> Render(a) {
  let checked = in.checked

  UICheckboxRender(in:, checked:, onclick: None)
}

/// Set checkbox render onclick event.
///
pub fn on_click_opt(at: Render(a), onclick: Option(a)) -> Render(a) {
  UICheckboxRender(..at, onclick:)
}

pub fn on_click(in: Render(a), onclick: a) -> Render(a) {
  on_click_opt(in, Some(onclick))
}

/// Render checkbox super element to `lustre/element.{type Element}`.
///
pub fn render(at: Render(a)) -> Element(a) {
  let UICheckboxRender(in:, onclick:, checked:) = at
  let UICheckbox(id:, label:, ..) = in

  let onclick =
    onclick
    |> option.map(event.on_click)
    |> option.unwrap(a.none())

  typo.at_left(label, [
    html.div([onclick, a.class("relative")], [
      html.input([
        a.id(id),
        a.type_("checkbox"),
        a.class("sr-only"),
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
            |> svg.render(),
          ]),
        ],
      ),
    ]),
  ])
}
