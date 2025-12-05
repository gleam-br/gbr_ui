////
//// Gleam UI separator super element.
////

import gleam/option.{type Option, None, Some}

import lustre/attribute.{class}
import lustre/element
import lustre/element/html

import gbr/ui/core/model.{type UIRender}

type Separator =
  UISeparator

/// Separator super element.
///
pub opaque type UISeparator {
  Default(label: Option(String))
}

/// New separator super element default.
///
pub fn new() {
  Default(label: None)
}

/// Set separator label.
///
pub fn label(_in: Separator, label: String) -> Separator {
  Default(label: Some(label))
}

/// Render separator super element to `lustre/element/html.{div}`.
///
pub fn render(in: Separator) -> UIRender(a) {
  let transform = fn(label) {
    html.span(
      [class("bg-white p-2 text-gray-400 sm:px-5 sm:py-2 dark:bg-gray-900")],
      [html.text(label)],
    )
  }
  let label =
    in.label
    |> option.map(transform)
    |> option.unwrap(element.none())

  html.div([class("relative py-3 sm:py-5")], [
    html.div([class("absolute inset-0 flex items-center")], [
      html.div(
        [class("w-full border-t border-gray-200 dark:border-gray-800")],
        [],
      ),
    ]),
    html.div([class("relative flex justify-center text-sm")], [label]),
  ])
}
