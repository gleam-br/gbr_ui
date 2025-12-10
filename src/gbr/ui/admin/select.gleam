////
//// Gleam UI select super element.
////

import gleam/list
import gleam/option

import lustre/attribute as a
import lustre/element
import lustre/element/html
import lustre/event

import gbr/ui/svg
import gbr/ui/svg/icons as svg_icons

import gbr/ui/core/el

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

pub const render = model.render

pub const onchange = model.onchange

pub const ontoggle = model.ontoggle

/// Render select super element to `lustre/element.{type Element}`.
///
pub fn view(at: Render(a)) -> element.Element(a) {
  case at.in.multi {
    True -> multi.view(at)
    False -> view_unique(at)
  }
}

// PRIVATE
//

fn view_unique(at) {
  let UISelectRender(in:, onchange:, ontoggle:) = at
  let UISelect(el:, items:, label:, open:, ..) = in

  let evt_onchange =
    onchange
    |> option.map(event.on_change)
    |> option.unwrap(a.none())
  let evt_oninput =
    onchange
    |> option.map(event.on_input)
    |> option.unwrap(a.none())
  let evt_ontoggle =
    ontoggle
    |> option.map(fn(ontoggle) { event.on_click(ontoggle(False)) })
    |> option.unwrap(a.none())
  let attrs =
    el
    |> el.class(
      "dark:bg-dark-900 shadow-theme-xs focus:border-brand-300 focus:ring-brand-500/10 "
      <> "dark:focus:border-brand-800 h-11 w-full appearance-none rounded-lg border border-gray-300 "
      <> "bg-transparent bg-none px-4 py-2.5 pr-11 text-sm text-gray-800 placeholder:text-gray-400 "
      <> "focus:ring-3 focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30",
    )
    |> el.attrs()
    |> list.append([evt_ontoggle, evt_onchange, evt_oninput])

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
          svg.new(24, 24)
          |> svg_icons.arrow()
          |> svg.classes([#("rotate-180", open)])
          |> svg.class(
            "h-5 w-5 shrink-0 text-gray-500 transition-transform dark:text-gray-400 stroke-current",
          )
          |> svg.view(),
          //
        // svg.new(20, 20)
        // |> svg_icons.arrow()
        // |> svg.class("stroke-current")
        // |> svg.view(),
        ],
      ),
    ]),
  ])
}
