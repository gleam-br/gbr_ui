////
//// Gleam UI multi select element
////

import gleam/bool
import gleam/list
import gleam/option.{type Option}
import gleam/string

import lustre/attribute as a
import lustre/element
import lustre/element/html
import lustre/event

import gbr/ui/core/el
import gbr/ui/svg
import gbr/ui/svg/icons as svg_icons

import gbr/ui/admin/select/model

// Alias
//

type Render(a) =
  model.UISelectRender(a)

type Item =
  model.UISelectItem

/// Render multi select
///
pub fn view(at: Render(a)) {
  let model.UISelectRender(in:, onchange:, ontoggle:) = at
  let model.UISelect(el:, items:, label:, open:, ..) = in

  let id = el.get_id(el)
  let label = model.new_label(id, label)
  let items_selected_empty =
    model.items_filter_by_selected_is_empty(items, True)
  let placeholder =
    el.att_get(el, "placeholder")
    |> new_placeholder(items_selected_empty)
  let options = model.new_options(items)

  let ontoggleclick =
    ontoggle
    |> option.map(fn(ontoggle) { event.on_click(ontoggle(False)) })
    |> option.unwrap(a.none())
  let onmouseleave =
    ontoggle
    |> option.map(fn(ontoggle) {
      event.on_mouse_leave(ontoggle(True)) |> event.stop_propagation()
    })
    |> option.unwrap(a.none())

  // TODO
  // let attrs = el.attrs(el)

  let values =
    items
    |> model.items_filter_by_selected(True)
    |> list.map(fn(item) { item.value })
    |> string.join(",")

  html.div([], [
    label,
    html.div([a.class("relative"), onmouseleave], [
      // form select hidden values
      //
      html.select(
        [
          a.id(id),
          a.value(values),
          a.class("hidden"),
          a.name("select-multi-values"),
        ],
        options,
      ),
      // bag with remove icon to selected options
      html.div(
        [
          a.class(
            "shadow-theme-xs flex min-h-11 cursor-pointer gap-2 rounded-lg border border-gray-300 bg-white px-3 py-2 transition dark:border-gray-700 dark:bg-gray-900",
          ),
          // toggle dropdown open/close
          ontoggleclick,
        ],
        [
          //list of options selected
          html.div(
            [
              a.class("flex flex-1 flex-wrap items-center gap-2"),
            ],
            [
              // if empty show input placeholde
              placeholder,
              // else list of selected options
              ..items_selected(items, onchange)
            ],
          ),
          // arrow dropdown
          html.div([a.class("flex items-start pt-1.5")], [
            svg.new(24, 24)
            |> svg_icons.arrow()
            |> svg.classes([#("rotate-180", open)])
            |> svg.class(
              "h-5 w-5 shrink-0 text-gray-500 transition-transform dark:text-gray-400 stroke-current",
            )
            |> svg.view(),
          ]),
        ],
      ),
      // dropdown not selected options
      html.div(
        [
          a.class(
            "absolute z-50 w-full overflow-hidden rounded-lg border border-gray-200 bg-white dark:border-gray-700 dark:bg-gray-900",
          ),
          a.style("max-height", "16rem"),
          a.classes([#("hidden", !open)]),
        ],
        [
          html.div(
            [a.class("overflow-y-auto"), a.style("max-height", "16rem")],
            items_not_selected(items, onchange),
          ),
        ],
      ),
    ]),
  ])
}

// PRIVATE
//

fn items_selected(
  items: List(Item),
  onchange: Option(fn(String) -> a),
) -> List(element.Element(a)) {
  use item <- list.map(model.items_filter_by_selected(items, True))

  let onchange =
    onchange
    |> option.map(fn(onchange) { onchange(item.value) })

  let onclick =
    onchange
    |> option.map(event.on_click)
    |> option.unwrap(a.none())

  html.div(
    [
      a.class(
        "group flex items-center justify-center rounded-full border-[0.7px] border-transparent bg-gray-100 "
        <> "py-1 pr-2 pl-2.5 text-sm text-gray-800 hover:border-gray-200 dark:bg-gray-800 dark:text-white/90 dark:hover:border-gray-800",
      ),
    ],
    [
      // option title, value
      html.span([], [html.text(item.label)]),
      // option tag to removed
      // remove icon
      html.button(
        [
          a.class(
            "ml-1 text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-300",
          ),
          onclick
            |> event.stop_propagation(),
        ],
        [
          svg.new(14, 14)
          |> svg_icons.close()
          |> svg.view(),
        ],
      ),
    ],
  )
}

fn items_not_selected(
  items: List(Item),
  onchange: Option(fn(String) -> a),
) -> List(element.Element(a)) {
  use item <- list.map(model.items_filter_by_selected(items, False))

  let onchange =
    onchange
    |> option.map(fn(onchange) { onchange(item.value) })

  let onclick =
    onchange
    |> option.map(event.on_click)
    |> option.unwrap(a.none())

  html.div(
    [
      a.class(
        "cursor-pointer border-b border-gray-200 px-4 py-3 text-sm transition last:border-b-0 dark:border-gray-800",
      ),
      onclick,
    ],
    [
      html.span(
        [
          a.class("text-gray-800 dark:text-white/90"),
        ],
        [html.text(item.label)],
      ),
    ],
  )
}

fn new_placeholder(placeholder: Option(String), items_selected_empty: Bool) {
  // x-show=selected == 0
  use <- bool.guard(!items_selected_empty, element.none())

  let transform = fn(placeholder) {
    html.span([a.class("text-sm text-gray-500 dark:text-gray-400")], [
      html.text(placeholder),
    ])
  }

  placeholder
  |> option.map(transform)
  |> option.unwrap(element.none())
}
