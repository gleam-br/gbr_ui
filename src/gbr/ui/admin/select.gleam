////
//// Gleam UI select super element.
////

import gleam/bool
import gleam/list
import gleam/option

import lustre/attribute as a
import lustre/element
import lustre/element/html
import lustre/event

import gbr/ui/svg
import gbr/ui/svg/icons as svg_icons

import gbr/ui/core/el
import gbr/ui/core/model.{type UIRender} as _core_model

import gbr/ui/admin/select/model.{UISelect, UISelectRender}
import gbr/ui/admin/select/multi

// Alias
//

type Render(a) =
  model.UISelectRender(a)

pub const new = model.new

pub const label = model.label

pub const open = model.open

pub const multi = model.multi

pub const placeholder = model.placeholder

pub const items = model.items

pub const selected = model.selected

pub const at = model.at

pub const onchange = model.onchange

pub const ontoggle = model.ontoggle

/// Render select super element to `lustre/element.{type Element}`.
///
pub fn render(at: Render(a)) -> UIRender(a) {
  let UISelectRender(in:, onchange:, ..) = at
  let UISelect(el:, items:, multi:, label:, open:) = in

  use <- bool.guard(multi, multi.render(at))

  let evt_onchange =
    onchange
    |> option.map(event.on_change)
    |> option.unwrap(a.none())
  let evt_oninput =
    onchange
    |> option.map(event.on_input)
    |> option.unwrap(a.none())
  let attrs =
    el
    |> el.class(
      "dark:bg-dark-900 shadow-theme-xs focus:border-brand-300 focus:ring-brand-500/10 "
      <> "dark:focus:border-brand-800 h-11 w-full appearance-none rounded-lg border border-gray-300 "
      <> "bg-transparent bg-none px-4 py-2.5 pr-11 text-sm focus:ring-3 focus:outline-hidden "
      <> "dark:border-gray-700 dark:bg-gray-900 text-gray-800 dark:text-white/90",
    )
    |> el.attrs()
    |> list.append([evt_onchange, evt_oninput])

  let transform = fn(placeholder) {
    html.option(
      [
        a.class("text-gray-600 dark:text-white/60"),
        a.disabled(!open),
        a.selected(True),
        a.hidden(!open),
        a.value(""),
      ],
      placeholder,
    )
  }

  let id = el.get_id(el)
  let label = model.new_label(id, label)
  let options = model.new_options(items)
  let placeholder =
    el.att_get(el, "placeholder")
    |> option.map(transform)
    |> option.unwrap(element.none())

  html.div([], [
    label,
    html.div([a.class("relative z-20 bg-transparent")], [
      html.select(attrs, [placeholder, ..options]),
      html.span(
        [
          a.class(
            "pointer-events-none absolute top-1/2 right-4 z-30 -translate-y-1/2 text-gray-700 dark:text-gray-400",
          ),
        ],
        [
          svg.new(20, 20)
          |> svg_icons.arrow()
          |> svg.class("stroke-current")
          |> svg.render(),
        ],
      ),
    ]),
  ])
}
