////
////
////
////

// function dropdown() {
//   return {
//     options: [],
//     selected: [],
//     show: false,
//     open() {
//       this.show = true;
//     },
//     close() {
//       this.show = false;
//     },
//     isOpen() {
//       return this.show === true;
//     },
//     select(index, event) {
//       if (!this.options[index].selected) {
//         this.options[index].selected = true;
//         this.options[index].element = event.target;
//         this.selected.push(index);
//       } else {
//         this.selected.splice(this.selected.lastIndexOf(index), 1);
//         this.options[index].selected = false;
//       }
//     },
//     remove(index, option) {
//       this.options[option].selected = false;
//       this.selected.splice(index, 1);
//     },
//     loadOptions() {
//       const options = document.getElementById("select").options;
//       for (let i = 0; i < options.length; i++) {
//         this.options.push({
//           value: options[i].value,
//           text: options[i].innerText,
//           selected:
//             options[i].getAttribute("selected") != null
//               ? options[i].getAttribute("selected")
//               : false,
//         });
//       }
//     },
//     selectedValues() {
//       return this.selected.map((option) => {
//         return this.options[option].value;
//       });
//     },
//   };
// }

import gleam/bool
import gleam/list
import gleam/option.{type Option}

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
pub fn render(at: Render(a)) {
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

  let onclick =
    ontoggle
    |> option.map(event.on_click)
    |> option.unwrap(a.none())
  let onmouseleave =
    ontoggle
    |> option.map(event.on_mouse_leave)
    |> option.unwrap(a.none())

  let attrs = el.attrs(el)

  html.div([], [
    label,
    html.div([], [
      // html select wrapper hidden
      // NAO PRECISA DISSO AQUI NAO
      //
      html.select([a.id(id), a.class("hidden")], options),
      //
      // dropdown
      html.div([a.class("flex flex-col items-center")], [
        //
        html.div([a.class("relative z-20 inline-block w-full")], [
          // dropdown selected
          html.div([a.class("relative flex flex-col items-center")], [
            // btn icon to open dropdown
            html.div([a.class("w-full")], [
              html.div(
                [
                  a.class(
                    "shadow-theme-xs focus:border-brand-300 focus:shadow-focus-ring dark:focus:border-brand-300 mb-2 flex h-11 rounded-lg border border-gray-300 py-1.5 pr-3 pl-3 outline-hidden transition dark:border-gray-700 dark:bg-gray-900",
                  ),
                ],
                [
                  //list of options selected
                  html.div([a.class("flex flex-auto flex-wrap gap-2")], [
                    // if empty show input placeholde
                    placeholder,
                    // else list of selected options
                    ..items_selected(items, onchange)
                  ]),
                  html.div([a.class("flex w-7 items-center py-1 pr-1 pl-1")], [
                    // toggle show not selected options
                    html.button(
                      [
                        a.class(
                          "h-5 w-5 cursor-pointer text-gray-700 outline-hidden focus:outline-hidden dark:text-gray-400",
                        ),
                        // is open rotate
                        a.classes([#("rotate-180", open)]),
                        // toggle is open
                        onclick,
                      ],
                      [
                        svg.new(20, 20)
                        |> svg_icons.arrow()
                        |> svg.class("stroke-current")
                        |> svg.render(),
                      ],
                    ),
                  ]),
                ],
              ),
            ]),
            html.div([a.class("w-full px-4")], [
              // dropdown list of not selected options
              html.div(
                [
                  a.class(
                    "max-h-select absolute top-full left-0 z-40 w-full overflow-y-auto rounded-lg bg-white shadow-sm dark:bg-gray-900",
                  ),
                  // is open rotate
                  a.classes([#("hidden", !open)]),
                  // close on mouse leave
                // onmouseleave,
                ],
                [
                  // list of not selected options
                  html.div(
                    [a.class("flex w-full flex-col")],
                    items_not_selected(items, onchange),
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
        "group flex items-center justify-center rounded-full border-[0.7px] border-transparent bg-gray-100 py-1 pr-2 pl-2.5 text-sm text-gray-800 hover:border-gray-200 dark:bg-gray-800 dark:text-white/90 dark:hover:border-gray-800",
      ),
    ],
    [
      // option title, value
      html.div([a.class("max-w-full flex-initial"), a.value(item.value)], [
        html.text(item.label),
      ]),
      // option tag to removed
      html.div([a.class("flex flex-auto flex-row-reverse")], [
        // remove icon
        html.div(
          [
            a.class(
              "cursor-pointer pl-2 text-gray-500 group-hover:text-gray-400 dark:text-gray-400",
            ),
            onclick,
          ],
          [
            svg.new(14, 14)
            |> svg_icons.close()
            |> svg.render(),
          ],
        ),
      ]),
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

  html.div([], [
    html.div(
      [
        a.class(
          "hover:bg-primary/5 w-full cursor-pointer rounded-t border-b border-gray-200 dark:border-gray-800",
        ),
        onclick,
      ],
      [
        html.div(
          [
            a.class(
              "relative flex w-full items-center border-l-2 border-transparent p-2 pl-2",
            ),
            // is selected
            a.classes([#("border-primary", True)]),
          ],
          [
            html.div([a.class("flex w-full items-center")], [
              html.div(
                [
                  a.class("mx-2 leading-6 text-gray-800 dark:text-white/90"),
                  a.value(item.value),
                ],
                [html.text(item.label)],
              ),
            ]),
          ],
        ),
      ],
    ),
  ])
}

fn new_placeholder(placeholder: Option(String), items_selected_empty: Bool) {
  // early return
  use <- bool.guard(!items_selected_empty, element.none())

  let transform = fn(placeholder) {
    // x-show=selected == 0
    html.div([a.class("flex-1")], [
      // input
      // placeholder
      // :values=selectedValues ??
      // TODO auto complete
      html.input([
        a.id("gbr-ui-select-placeholder"),
        a.placeholder(placeholder),
        a.class(
          "h-full w-full appearance-none border-0 bg-transparent p-1 pr-2 text-sm outline-hidden text-gray-800 dark:text-gray-100 "
          <> "placeholder:text-gray-600 dark:placeholder:text-white/60 focus:border-0 focus:ring-0 focus:outline-hidden",
        ),
      ]),
    ])
  }

  placeholder
  |> option.map(transform)
  |> option.unwrap(element.none())
}
