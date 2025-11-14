////
//// ✅ Gleam UI input type checkbox super element.
////

import gleam/bool
import gleam/option.{type Option, None, Some}

import lustre/attribute as a
import lustre/element.{type Element}
import lustre/element/html

import gbr/ui/core.{type UIAttrs, type UILabel, UILabel, attrs_to_lustre, to_id}
import gbr/ui/input
import gbr/ui/svg
import gbr/ui/svg/form as svg_form

type Checkbox =
  UICheckbox

type Render(a) =
  UICheckboxRender(a)

type Label =
  UILabel

type Attrs =
  UIAttrs

/// Checkbox super element.
///
pub opaque type UICheckbox {
  UICheckbox(
    id: String,
    att: Attrs,
    checked: Option(Bool),
    label: Option(Label),
  )
}

/// Checkbox render type.
///
pub type UICheckboxRender(a) {
  UICheckboxRender(in: Checkbox, onclick: Option(a))
}

/// New checkbox super element.
///
pub fn new(id: String) -> Checkbox {
  UICheckbox(id: to_id(id), att: [], checked: None, label: None)
}

/// Set checkbox checked or not.
///
pub fn checked(in: Checkbox, checked: Bool) -> Checkbox {
  UICheckbox(..in, checked: Some(checked))
}

/// Set checkbox label.
///
pub fn label(in: Checkbox, label: Label) -> Checkbox {
  UICheckbox(..in, label: Some(label))
}

/// New checkbox render.
///
pub fn at(in: Checkbox) -> Render(a) {
  UICheckboxRender(in:, onclick: None)
}

/// Set checkbox render onclick event.
///
pub fn on_click_opt(in: Render(a), onclick: Option(a)) -> Render(a) {
  UICheckboxRender(..in, onclick:)
}

pub fn on_click(in: Render(a), onclick: a) -> Render(a) {
  on_click_opt(in, Some(onclick))
}

/// Render checkbox super element to `lustre/element.{type Element}`.
///
pub fn render(at: Render(a)) -> Element(a) {
  let UICheckboxRender(in:, onclick:) = at
  let UICheckbox(id:, label:, checked:, att:) = in
  let checkbox =
    input.checkbox(id)
    |> input.attrs(att)
    |> input.sr_only()
    |> input.at()
  let inner =
    html.div([a.class("relative")], [
      case onclick {
        Some(onclick) ->
          input.on_click(checkbox, onclick)
          |> input.render()
        None -> input.render(checkbox)
      },
      decorator(checked),
    ])

  use <- bool.guard(option.is_none(label), html.div([], [inner]))
  let assert Some(UILabel(text:, att:)) = label

  html.label([a.class(class_label), ..attrs_to_lustre(att)], [
    inner,
    html.text(text),
  ])
}

// PRIVATE
//

const class_label = "flex items-center text-sm font-normal text-gray-700 cursor-pointer select-none dark:text-gray-400"

const class_decorator = "mr-3 flex h-5 w-5 items-center justify-center rounded-md border-[1.25px]"

fn decorator(checked) {
  let checked = option.unwrap(checked, False)
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
      svg.new("checkbox-icon", 14, 14)
      |> svg_form.checkbox()
      |> svg.render(),
    ]),
  ])
}
