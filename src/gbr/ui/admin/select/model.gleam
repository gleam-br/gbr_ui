////
//// Gleam UI admin multi select element
////

import gleam/list
import gleam/option.{type Option, None, Some}

import lustre/attribute as a
import lustre/element
import lustre/element/html

import gbr/ui/core/el
import gbr/ui/typo

// Alias
//

type Select =
  UISelect

type Render(a) =
  UISelectRender(a)

type Item =
  UISelectItem

type Items =
  List(Item)

type Text =
  typo.UITypo

type OnChange(a) =
  fn(String) -> a

type OnToggle(a) =
  fn(Bool) -> a

/// Select super element
///
/// - el: Element info type
/// - items: List of options
/// - label: Option label for select
/// - multi: Is multi select
/// - open: If is open multi select dropdown
///
pub type UISelect {
  UISelect(
    el: el.UIEl,
    items: Items,
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
pub type UISelectRender(a) {
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
pub type UISelectItem {
  UISelectItem(value: String, label: String, selected: Bool)
}

/// Constructor of select super element
///
pub fn new(id: String) -> Select {
  UISelect(el: el.new(id), items: [], multi: False, open: False, label: None)
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

/// Set select items (options)
///
pub fn items(in: Select, items) -> Select {
  UISelect(..in, items:)
}

/// Set select multi items can selected
///
pub fn multi(in: Select, multi: Bool) -> Select {
  UISelect(..in, multi:)
}

/// Set select open mulit select items
///
pub fn open(in: Select, open: Bool) -> Select {
  UISelect(..in, open:)
}

/// Update select based by event occurs.
///
pub fn selected(in: Select, value: String) -> Select {
  let UISelect(items:, multi:, ..) = in
  let items = items_select(items, value, multi)

  UISelect(..in, items:)
}

/// New select render type
///
/// - in: Select element info type
///
pub fn at(in: Select) -> Render(a) {
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

pub fn new_options(items: List(Item)) {
  use item <- list.map(items)

  let UISelectItem(value:, label:, selected:) = item

  html.option(
    [
      a.value(value),
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
      [typo.render(label)],
    )
  }

  label
  |> option.map(transform)
  |> option.unwrap(element.none())
}

/// Filter select items, options, by selected
///
/// - items: List of items (options)
/// - selected: True or False
///
pub fn items_filter_by_selected(items: List(Item), selected: Bool) -> List(Item) {
  use item <- list.filter(items)

  item.selected == selected
}

/// If items is empty filter by selected or not
///
/// - items: List of options
/// - selected: True or False
///
pub fn items_filter_by_selected_is_empty(
  items: List(Item),
  selected: Bool,
) -> Bool {
  items_filter_by_selected(items, selected)
  |> list.is_empty()
}

// PRIVATE
//

fn items_select(items: Items, value, multi) {
  use item <- list.map(items)
  let is_equals = item.value == value

  case is_equals, multi {
    _, False -> UISelectItem(..item, selected: is_equals)
    True, True -> UISelectItem(..item, selected: !item.selected)
    False, True -> item
  }
}
