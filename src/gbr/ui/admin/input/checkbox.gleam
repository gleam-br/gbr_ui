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

/// Checkbox super element.
///
pub opaque type UICheckbox {
  UICheckbox(el: Input, checked: Bool)
}

/// Checkbox render type.
///
pub type UICheckboxRender(a) {
  UICheckboxRender(in: InputRender(a), checked: Bool)
}

/// New checkbox super element.
///
pub fn new(id: String) -> Checkbox {
  UICheckbox(el: input.checkbox(id), checked: False)
}

/// Set checkbox checked or not.
///
pub fn checked(in: Checkbox, checked: Bool) -> Checkbox {
  UICheckbox(..in, checked:)
}

/// Set checkbox label.
///
pub fn label(in: Checkbox, label: String) -> Checkbox {
  let el =
    input.label(in.el, label)
    |> input.label_class(class_label)

  UICheckbox(..in, el:)
}

/// New checkbox render.
///
pub fn at(in: Checkbox) -> Render(a) {
  let checked = in.checked
  let in = input.at(in.el, [], [])

  UICheckboxRender(in:, checked:)
}

/// Set checkbox render onclick event.
///
pub fn on_click_opt(at: Render(a), onclick: Option(a)) -> Render(a) {
  let in = input.on_click_opt(at.in, onclick)

  UICheckboxRender(..at, in:)
}

pub fn on_click(in: Render(a), onclick: a) -> Render(a) {
  on_click_opt(in, Some(onclick))
}

/// Render checkbox super element to `lustre/element.{type Element}`.
///
pub fn render(at: Render(a)) -> Element(a) {
  let UICheckboxRender(in:, checked:) = at

  html.div([a.class("relative")], [
    input.render(in),
    decorator(checked),
  ])
}

// PRIVATE
//

const class_label = "flex items-center text-sm font-normal text-gray-700 cursor-pointer select-none dark:text-gray-400"

const class_decorator = "mr-3 flex h-5 w-5 items-center justify-center rounded-md border-[1.25px]"

fn decorator(checked) {
  let class_checked = case checked {
    True -> " border-brand-500 bg-brand-500"
    False -> " bg-transparent border-gray-300 dark:border-gray-700"
  }

  let class_span = case checked {
    False -> "opacity-0"
    _ -> ""
  }

  html.div([a.class(class_decorator <> class_checked)], [
    html.span([a.class(class_span)], [
      svg.new(14, 14)
      |> svg_form.checkbox()
      |> svg.render(),
    ]),
  ])
}
