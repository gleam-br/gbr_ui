////
//// Gleam UI input select super element.
////

import gleam/bool
import gleam/list

import lustre/attribute as a
import lustre/element/html
import lustre/event

import gbr/ui/core.{type UIRender, to_id}
import gbr/ui/svg
import gbr/ui/svg/icons as svg_icons

type Item =
  UISelectItem

type Items =
  List(Item)

type Select =
  UISelect

type Render(a) =
  UISelectRender(a)

/// Select super element.
///
pub opaque type UISelect {
  Select(id: String, multi: Bool, title: String, items: Items)
}

/// Select render type.
///
pub type UISelectRender(a) {
  UISelectRender(onchange: fn(String) -> a)
}

/// Select item (option) type.
///
pub type UISelectItem {
  UISelectItem(value: String, label: String, selected: Bool)
}

/// Constructor of select super element.
///
pub fn new(id: String) -> Select {
  Select(id: to_id(id), title: "", multi: False, items: [])
}

/// Set select title.
///
pub fn title(in: Select, title: String) -> Select {
  Select(..in, title:)
}

/// Set select items (options).
///
pub fn items(in: Select, items) -> Select {
  Select(..in, items:)
}

/// Set select multi items can selected.
///
pub fn multi(in: Select, multi: Bool) -> Select {
  Select(..in, multi:)
}

/// Update select based by event occurs.
///
pub fn selected(in: Select, value: String) -> Select {
  let Select(items:, ..) = in
  let items = items_toggle(value, items)

  Select(..in, items:)
}

/// Render select super element to `lustre/element.{type Element}`.
///
pub fn render(in: Select, render: Render(a)) -> UIRender(a) {
  let Select(id:, multi:, title:, items:) = in
  let UISelectRender(onchange:) = render

  use <- bool.guard(multi, do_multi(in))

  html.div([], [
    html.label(
      [
        a.for("falcon-admin-select-" <> id),
        a.class(title_class),
      ],
      [html.text(title)],
    ),
    html.div([a.class(container_class)], [
      html.select(
        [
          a.id("falcon-admin-select-" <> title),
          a.class(select_class),
          event.on_change(onchange),
        ],
        do_items(items),
      ),
      html.span([a.class(icon_class)], [
        svg.new("select-icon-arrow", 20, 20)
        |> svg_icons.arrow()
        |> svg.classes(["stroke-current"])
        |> svg.render(),
      ]),
    ]),
  ])
}

// PRIVATE
//

fn items_toggle(value, items: Items) {
  use item <- list.map(items)

  use <- bool.guard(item.value != value, item)

  UISelectItem(..item, selected: True)
}

fn do_multi(in: Select) -> UIRender(a) {
  let Select(id:, title:, items:, ..) = in
  html.div([], [
    html.label(
      [
        a.for("falcon-admin-select-" <> id),
        a.class(title_class),
      ],
      [html.text(title)],
    ),
    html.div([], [
      html.select(
        [
          a.id("falcon-admin-select-" <> id),
          a.class("hidden"),
        ],
        do_items(items),
      ),
      html.div([a.class("flex flex-col items-center")], [
        html.input([a.type_("hidden"), a.name("values")]),
        html.div([a.class("relative z-20 inline-block w-full")], [
          html.div([a.class("relative flex flex-col items-center")], [
            html.div([a.class("w-full")], [
              html.div(
                [
                  a.class(
                    "shadow-theme-xs focus:border-brand-300 focus:shadow-focus-ring dark:focus:border-brand-300 mb-2 flex h-11 rounded-lg border border-gray-300 py-1.5 pr-3 pl-3 outline-hidden transition dark:border-gray-700 dark:bg-gray-900",
                  ),
                ],
                [
                  html.div(
                    [a.class("flex flex-auto flex-wrap gap-2")],
                    list.append(do_items_selected_multi(items), [
                      html.div([], [
                        html.input([
                          a.class(case list.is_empty(items) {
                            True -> "block"
                            False -> "hidden"
                          }),
                          a.placeholder("Selecionar..."),
                          a.class(
                            "h-full w-full appearance-none border-0 bg-transparent p-1 pr-2 text-sm outline-hidden placeholder:text-gray-800 focus:border-0 focus:ring-0 focus:outline-hidden dark:placeholder:text-white/90",
                          ),
                        ]),
                      ]),
                    ]),
                  ),
                  html.div([a.class("flex w-7 items-center py-1 pr-1 pl-1")], [
                    html.button(
                      [
                        a.class(
                          "h-5 w-5 cursor-pointer text-gray-700 outline-hidden focus:outline-hidden dark:text-gray-400",
                        ),
                      ],
                      [
                        svg.new("select-icon-arrow-mult", 20, 20)
                        |> svg_icons.arrow()
                        |> svg.classes(["stroke-current"])
                        |> svg.render(),
                      ],
                    ),
                  ]),
                ],
              ),
            ]),
            html.div([a.class("w-full px-4")], [
              html.div(
                [
                  a.class(
                    "max-h-select absolute top-full left-0 z-40 w-full overflow-y-auto rounded-lg bg-white shadow-sm dark:bg-gray-900",
                  ),
                ],
                [
                  html.div(
                    [a.class("flex w-full flex-col")],
                    do_items_multi(items),
                  ),
                ],
              ),
            ]),
          ]),
        ]),
      ]),
    ]),
  ])
}

fn do_items(items) {
  use option <- list.map(items)

  let UISelectItem(value:, label:, selected:) = option
  let classes = case selected {
    True -> option_class <> " " <> option_selected_class
    False -> option_class
  }

  html.option(
    [
      a.class(classes),
      a.value(value),
      a.selected(selected),
    ],
    label,
  )
}

fn do_items_multi(items) {
  use option <- list.map(filter_items_selected(items, False))
  html.div([], [
    html.div(
      [
        a.class(
          "hover:bg-primary/5 w-full cursor-pointer rounded-t border-b border-gray-200 dark:border-gray-800",
        ),
      ],
      [
        html.div(
          [
            a.class(
              "relative flex w-full items-center border-l-2 border-transparent p-2 pl-2",
            ),
          ],
          [
            html.div([a.class("flex w-full items-center")], [
              html.div(
                [
                  a.class("mx-2 leading-6 text-gray-800 dark:text-white/90"),
                  a.value(option.value),
                ],
                [html.text(option.label)],
              ),
            ]),
          ],
        ),
      ],
    ),
  ])
}

fn do_items_selected_multi(items) {
  use option <- list.map(filter_items_selected(items, True))

  html.div(
    [
      a.class(
        "group flex items-center justify-center rounded-full border-[0.7px] border-transparent bg-gray-100 py-1 pr-2 pl-2.5 text-sm text-gray-800 hover:border-gray-200 dark:bg-gray-800 dark:text-white/90 dark:hover:border-gray-800",
      ),
    ],
    [
      html.div(
        [
          a.class("max-w-full flex-initial"),
          a.value(option.value),
        ],
        [
          html.text(option.label),
        ],
      ),
      html.div([a.class("flex flex-auto flex-row-reverse")], [
        html.div(
          [
            a.class(
              "cursor-pointer pl-2 text-gray-500 group-hover:text-gray-400 dark:text-gray-400",
            ),
          ],
          [
            svg.new("select-icon-close-multi", 14, 14)
            |> svg_icons.close()
            |> svg.render(),
          ],
        ),
      ]),
    ],
  )
}

fn filter_items_selected(options, is_selected) {
  use opt <- list.filter(options)
  let UISelectItem(selected:, ..) = opt

  selected == is_selected
}

const title_class = "mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-400"

const container_class = "relative z-20 bg-transparent"

const select_class = "dark:bg-dark-900 shadow-theme-xs focus:border-brand-300 focus:ring-brand-500/10 dark:focus:border-brand-800 h-11 w-full appearance-none rounded-lg border border-gray-300 bg-transparent bg-none px-4 py-2.5 pr-11 text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30"

const option_class = "text-gray-700 dark:bg-gray-900 dark:text-gray-400"

const option_selected_class = "text-gray-800 dark:text-white/90"

const icon_class = "pointer-events-none absolute top-1/2 right-4 z-30 -translate-y-1/2 text-gray-700 dark:text-gray-400"
