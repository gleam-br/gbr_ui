////
////
////

import gleam/function
import gleam/list
import gleam/option.{type Option, Some}

import gbr/ui/svg

pub type Icon =
  Option(svg.Identity)

type Item {
  Item(id: String, text: String, icon: Icon)
}

type Callback(a) =
  fn(String, String, Icon) -> a

pub opaque type UIDropdown {
  UIDropdown(visible: Bool, menus: List(Item), buttons: List(Item))
}

pub fn new(visible: Bool) {
  UIDropdown(visible:, menus: [], buttons: [])
}

pub fn add_menu_icon(
  in: UIDropdown,
  id: String,
  text: String,
  icon: svg.Identity,
) -> UIDropdown {
  let UIDropdown(menus:, ..) = in
  let menu = Item(id:, text:, icon: Some(icon))

  UIDropdown(..in, menus: [menu, ..menus])
}

pub fn add_menu(in: UIDropdown, id: String, text: String) -> UIDropdown {
  add_menu_icon(in, id, text, function.identity)
}

pub fn is_visible(in: UIDropdown) -> Bool {
  in.visible
}

pub fn in_menus(in: UIDropdown, callback: Callback(a)) -> List(a) {
  use menu <- list.map(in.menus)
  let Item(id, text:, icon:) = menu

  callback(id, text, icon)
}

pub fn in_buttons(in: UIDropdown, callback: Callback(a)) -> List(a) {
  use btn <- list.map(in.buttons)
  let Item(id:, text:, icon:) = btn

  callback(id, text, icon)
}
