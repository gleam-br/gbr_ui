////
//// ✅ Gleam UI input type checkbox super element.
////

import gleam/option.{type Option, Some}

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

type Input =
  input.UIInput

type InputRender(a) =
  input.UIInputRender(a)

type Text =
  typo.UITypo

/// Checkbox super element.
///
pub opaque type UICheckbox {
  UICheckbox(el: Input, label: Text, checked: Bool)
}

/// Checkbox render type.
///
pub type UICheckboxRender(a) {
  UICheckboxRender(in: Checkbox, input: InputRender(a), checked: Bool)
}

/// New checkbox super element.
///
pub fn new(id: String) -> Checkbox {
  let label =
    typo.label(id, "")
    |> typo.class(
      "flex cursor-pointer items-center text-sm font-normal text-gray-700 select-none dark:text-gray-400",
    )
  let el =
    input.checkbox(id)
    |> input.class(
      "mr-3 flex h-5 w-5 items-center justify-center rounded-md border-[1.25px] bg-transparent border-gray-300 dark:border-gray-700",
    )

  UICheckbox(el:, label:, checked: False)
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
  let input = input.at(in.el, [], [])

  UICheckboxRender(in:, input:, checked:)
}

/// Set checkbox render onclick event.
///
pub fn on_click_opt(at: Render(a), onclick: Option(a)) -> Render(a) {
  let input = input.on_click_opt(at.input, onclick)

  UICheckboxRender(..at, input:)
}

pub fn on_click(in: Render(a), onclick: a) -> Render(a) {
  on_click_opt(in, Some(onclick))
}

/// Render checkbox super element to `lustre/element.{type Element}`.
///
pub fn render(at: Render(a)) -> Element(a) {
  let UICheckboxRender(in:, input:, checked:) = at
  let UICheckbox(label:, ..) = in

  typo.at_left(label, [
    html.div([a.class("relative")], [
      input.render(input),
      html.div(
        [
          a.classes([
            #("border-brand-500 bg-brand-500", checked),
            #("bg-transparent border-gray-300 dark:border-gray-700", !checked),
          ]),
          a.class(
            "mr-3 flex h-5 w-5 items-center justify-center rounded-md border-[1.25px] bg-transparent border-gray-300 dark:border-gray-700",
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
