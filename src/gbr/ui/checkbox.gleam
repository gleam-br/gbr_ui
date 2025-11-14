////
//// ✅ Gleam UI input type checkbox super element.
////

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
  UICheckboxRender(onclick: Option(a))
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

/// Render checkbox super element to `lustre/element.{type Element}`.
///
pub fn render(in: Checkbox, render: Render(a)) -> Element(a) {
  let UICheckbox(id:, label:, checked:, att:) = in
  let UICheckboxRender(onclick:) = render
  let to_render = case onclick {
    Some(onclick) -> input.at_none() |> input.onclick(onclick)
    None -> input.at_none()
  }
  let el =
    html.div([a.class("relative")], [
      input.checkbox(id)
        |> input.attrs(att)
        |> input.sr_only()
        |> input.render(to_render),
      decorator(checked),
    ])

  case label {
    None -> html.div([], [el])
    Some(UILabel(text:, att:)) ->
      html.label([a.class(class_label), ..attrs_to_lustre(att)], [
        el,
        html.text(text),
      ])
  }
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
