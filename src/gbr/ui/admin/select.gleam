////
//// Gleam UI select super element.
////
////
//// Gleam UI admin multi select element
////

import gleam/bool
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string

import lustre/attribute as a
import lustre/element
import lustre/element/html
import lustre/event

import gbr/ui/svg
import gbr/ui/svg/icons as svg_icons
import gbr/ui/typo

import gbr/ui/core/el
import gbr/ui/core/model.{type UIRender}

// Alias
//

type Select =
  UISelect

type Render(a) =
  UISelectRender(a)

type Item =
  UISelectOption

type Options =
  List(Item)

type Text =
  typo.UITypo

type OnChange(a) =
  fn(String, String) -> a

type OnToggle(a) =
  fn(Bool) -> a

/// Select super element
///
/// - el: Element info type
/// - options: List of options
/// - label: Option label for select
/// - multi: Is multi select
/// - open: If is open multi select dropdown
///
pub opaque type UISelect {
  UISelect(
    el: el.UIEl,
    options: Options,
    label: Option(Text),
    multi: Bool,
    open: Bool,
  )
}

/// Select render type
///
/// - in: Select type info
/// - onchange: Option on change event
/// - ontoggle: Option on toggle event (only to multi select)
///
pub opaque type UISelectRender(a) {
  UISelectRender(
    in: Select,
    onchange: Option(OnChange(a)),
    ontoggle: Option(OnToggle(a)),
  )
}

/// Select item (option) type
///
/// - value: Value of option
/// - label: Label of option
/// - selected: If is selected or not
///
pub type UISelectOption {
  UISelectOption(value: String, label: String, selected: Bool)
}

/// Constructor of select super element
///
pub fn new(id: String) -> Select {
  let el =
    el.new(id)
    |> el.name(id)
  UISelect(el:, options: [], multi: False, open: False, label: None)
}

/// New selection option item
///
/// - value: Select option value
/// - text: Select option inner text
///
pub fn option(value: String, text: String) -> Item {
  UISelectOption(value:, label: text, selected: False)
}

/// Set select title
///
pub fn label(in: Select, label: Text) -> Select {
  UISelect(..in, label: Some(label))
}

/// Set placeholder to multi-select
///
/// > Only multi-select support
///
pub fn placeholder(in: Select, placeholder: String) -> Select {
  let el = el.att(in.el, [#("placeholder", placeholder)])

  UISelect(..in, el:)
}

/// Set select options (options)
///
pub fn options(in: Select, options) -> Select {
  UISelect(..in, options:)
}

/// Set select multi options can selected
///
pub fn multi(in: Select, multi: Bool) -> Select {
  UISelect(..in, multi:)
}

/// Set select open mulit select options
///
pub fn open(in: Select, open: Bool) -> Select {
  UISelect(..in, open:)
}

/// Toggle select open multi select options
///
pub fn toggle(in: Select) -> Select {
  UISelect(..in, open: !in.open)
}

/// Set selected option by value
///
///
pub fn selected(in: Select, value: Option(String)) -> Select {
  let UISelect(options:, multi:, ..) = in
  let value = option.unwrap(value, "")
  let options = options_select(options, value, multi)

  UISelect(..in, options:)
}

pub fn diselected(in: Select, value: String) -> Select {
  let options = {
    use opt <- list.filter_map(in.options)

    case opt.value == value {
      False -> Ok(opt)
      True -> Ok(UISelectOption(..opt, selected: False))
    }
  }

  UISelect(..in, options:)
}

pub fn reset_options(in: Select) -> Select {
  let options = {
    use opt <- list.map(in.options)

    UISelectOption(..opt, selected: False)
  }

  UISelect(..in, options:)
}

/// Get selected options.
///
/// - in: Select type instance.
///
pub fn selected_get_one(in: Select) -> Option(Item) {
  case selected_get(in) {
    [] -> None
    [head] | [head, ..] -> Some(head)
  }
}

pub fn selected_get_map(in: Select, map: fn(Item) -> a) -> Option(a) {
  in
  |> selected_get_one
  |> option.map(map)
}

/// Get selected options.
///
/// - in: Select type instance.
///
pub fn selected_get(in: Select) -> List(Item) {
  use opt <- list.filter_map(in.options)

  case opt.selected {
    True -> Ok(opt)
    False -> Error(Nil)
  }
}

/// New select render type
///
/// - in: Select element info type
///
pub fn render(in: Select) -> Render(a) {
  UISelectRender(in:, onchange: None, ontoggle: None)
}

/// Set select element event onchange and oninput
///
/// - at: Select render elemment info
/// - onchange: Select event
///
pub fn onchange(at: Render(a), onchange: OnChange(a)) -> Render(a) {
  UISelectRender(..at, onchange: Some(onchange))
}

/// Set multi select event on dropdown open toggle
///
/// - at: Select render elemment info
/// - onchange: Select event
///
/// In multi select element behavior has a dropdown list of not selected options.
///
pub fn ontoggle(at: Render(a), ontoggle: OnToggle(a)) -> Render(a) {
  UISelectRender(..at, ontoggle: Some(ontoggle))
}

pub fn new_options(options: Options) {
  use item <- list.map(options)

  let UISelectOption(value:, label:, selected:) = item

  html.option(
    [
      a.value(value),
      a.selected(selected),
      a.class("text-gray-700 dark:bg-gray-900 dark:text-gray-400"),
      a.classes([
        #("text-gray-800 dark:text-white/90", selected),
      ]),
    ],
    label,
  )
}

pub fn new_label(id, label) {
  let transform = fn(label) {
    html.label(
      [
        a.for(id),
        a.class(
          "mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-400",
        ),
      ],
      [typo.view(label)],
    )
  }

  label
  |> option.map(transform)
  |> option.unwrap(element.none())
}

/// Filter select options, options, by selected
///
/// - options: List of options (options)
/// - selected: True or False
///
pub fn options_filter_by_selected(options: Options, selected: Bool) -> Options {
  use option <- list.filter(options)

  option.selected == selected
}

/// If options is empty filter by selected or not
///
/// - options: List of options
/// - selected: True or False
///
pub fn options_filter_by_selected_is_empty(
  options: Options,
  selected: Bool,
) -> Bool {
  options_filter_by_selected(options, selected)
  |> list.is_empty()
}

/// Render select super element to `lustre/element.{type Element}`.
///
pub fn view(at: Render(a)) -> UIRender(a) {
  case at.in.multi {
    True -> view_multi(at)
    False -> view_unique(at)
  }
}

// PRIVATE
//

fn view_unique(at) {
  let UISelectRender(in:, onchange:, ontoggle:) = at
  let UISelect(el:, options:, label:, open:, ..) = in
  let id = el.id_get(el)
  let evt_onchange =
    onchange
    |> option.map(fn(onchange) {
      onchange(id, _)
      |> event.on_change()
    })
    |> option.unwrap(a.none())
  let evt_ontoggle =
    ontoggle
    |> option.map(fn(ontoggle) { event.on_click(ontoggle(False)) })
    |> option.unwrap(a.none())
  let attrs =
    el
    |> el.class(
      "dark:bg-dark-900 shadow-theme-xs focus:border-brand-300 focus:ring-brand-500/10 "
      <> "dark:focus:border-brand-800 h-10 w-full appearance-none rounded-lg border border-gray-300 "
      <> "bg-transparent bg-none px-4 py-2.5 pr-11 text-sm text-gray-800 placeholder:text-gray-400 "
      <> "focus:ring-3 focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30",
    )
    |> el.attrs()
    |> list.append([evt_ontoggle, evt_onchange])
  //todo 2x calls evt_oninput])

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

  let id = el.id_get(el)
  let label = new_label(id, label)
  let options = new_options(options)
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
          |> svg.class(
            "h-5 w-5 shrink-0 text-gray-500 transition-transform dark:text-gray-400 stroke-current",
          )
          |> svg.view(),
        ],
      ),
    ]),
  ])
}

fn options_select(options: Options, value, multi) {
  use option <- list.map(options)
  let is_equals = option.value == value

  case is_equals, multi {
    _, False -> UISelectOption(..option, selected: is_equals)
    True, True -> UISelectOption(..option, selected: !option.selected)
    False, True -> option
  }
}

/// Render multi select
///
fn view_multi(at: Render(a)) {
  let UISelectRender(in:, onchange:, ontoggle:) = at
  let UISelect(el:, options:, label:, open:, ..) = in

  let id = el.id_get(el)
  let label = new_label(id, label)
  let options_selected_empty =
    options_filter_by_selected_is_empty(options, True)
  let placeholder =
    el.att_get(el, "placeholder")
    |> new_placeholder(options_selected_empty)
  let view_options = new_options(options)

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
    options
    |> options_filter_by_selected(True)
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
        view_options,
      ),
      // bag with remove icon to selected options
      html.div(
        [
          a.class(
            "shadow-theme-xs flex min-h-10 cursor-pointer gap-2 rounded-lg border border-gray-300 bg-white px-3 py-2 transition dark:border-gray-700 dark:bg-gray-900",
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
              ..options_selected(id, options, onchange)
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
            "absolute z-999 w-full overflow-hidden rounded-lg border border-gray-200 bg-white dark:border-gray-700 dark:bg-gray-900",
          ),
          a.style("max-height", "16rem"),
          a.classes([#("hidden", !open)]),
        ],
        [
          html.div(
            [a.class("overflow-y-auto"), a.style("max-height", "16rem")],
            options_not_selected(id, options, onchange),
          ),
        ],
      ),
    ]),
  ])
}

// PRIVATE
//

fn options_selected(
  id,
  options: Options,
  onchange: Option(fn(String, String) -> a),
) -> List(element.Element(a)) {
  use item <- list.map(options_filter_by_selected(options, True))

  let onchange =
    onchange
    |> option.map(fn(onchange) { onchange(id, item.value) })

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

fn options_not_selected(
  id,
  options: Options,
  onchange: Option(fn(String, String) -> a),
) -> List(element.Element(a)) {
  use item <- list.map(options_filter_by_selected(options, False))

  let onchange =
    onchange
    |> option.map(fn(onchange) { onchange(id, item.value) })

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

fn new_placeholder(placeholder: Option(String), options_selected_empty: Bool) {
  // x-show=selected == 0
  use <- bool.guard(!options_selected_empty, element.none())

  let transform = fn(placeholder) {
    html.span([a.class("text-sm text-gray-500 dark:text-gray-400")], [
      html.text(placeholder),
    ])
  }

  placeholder
  |> option.map(transform)
  |> option.unwrap(element.none())
}
