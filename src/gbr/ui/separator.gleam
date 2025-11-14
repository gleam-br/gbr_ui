////
//// Gleam UI separator super element.
////

import lustre/attribute.{class}
import lustre/element
import lustre/element/html

import gbr/ui/core.{type UIRender}

type Separator =
  UISeparator

/// Separator super element.
///
pub opaque type UISeparator {
  Default
  Label(String)
}

/// New separator super element default.
///
pub fn new() {
  Default
}

/// Set separator label.
///
pub fn label(_in: Separator, label: String) -> Separator {
  Label(label)
}

/// Render separator super element to `lustre/element/html.{div}`.
///
pub fn render(in: Separator) -> UIRender(a) {
  html.div([class("relative py-3 sm:py-5")], [
    html.div([class("absolute inset-0 flex items-center")], [
      html.div(
        [class("w-full border-t border-gray-200 dark:border-gray-800")],
        [],
      ),
    ]),
    html.div([class("relative flex justify-center text-sm")], [
      case in {
        Default -> element.none()
        Label(text) ->
          html.span(
            [
              class(
                "p-2 text-gray-400 bg-white dark:bg-gray-900 sm:px-5 sm:py-2",
              ),
            ],
            [html.text(text)],
          )
      },
    ]),
  ])
}
