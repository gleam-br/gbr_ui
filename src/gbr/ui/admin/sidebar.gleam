////
//// ☰ Gleam UI sidebar super element
////

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result

import lustre/attribute as a
import lustre/element
import lustre/element/html

import gbr/ui/core/el
import gbr/ui/core/model.{type UIRender}

import gbr/ui/logo.{type UILogo}

import gbr/ui/admin/sidebar/menu

type Sidebar =
  UISidebar

type Render(a) =
  UISidebarRender(a)

type Menu =
  menu.UISidebarMenu

type Logo =
  UILogo

type OnClick(a) =
  menu.UISidebarMenuOnClick(a)

/// Sidebar super element
///
/// - id: html id
/// - logo: Sidebar head logo
/// - menu: Sidebar root list menus
/// - open: Sidebar is open (expanded)
/// - selected: Sidebar menu id selected
///
pub opaque type UISidebar {
  UISidebar(
    el: el.UIEl,
    open: Bool,
    root: List(Menu),
    selected: Option(String),
    logo: Option(Logo),
  )
}

/// Render sidebar element.
///
pub opaque type UISidebarRender(a) {
  UISidebarRender(in: Sidebar, onclick: OnClick(a))
}

/// New sidebar element
///
/// - id: Element id
///
pub fn new(id: String) -> Sidebar {
  let el =
    el.new(id)
    |> el.class(sidebar_class)

  UISidebar(el:, root: [], selected: None, logo: None, open: True)
}

/// Set root menu list
///
/// - in: Sidebar element
/// - menus: Root list of menus
///
pub fn root(in: Sidebar, menus: List(Menu)) -> Sidebar {
  UISidebar(..in, root: set_root(menus) |> echo)
}

/// Set logo sidebar head
///
/// - in: Sidebar element
/// - logo: Logo element
///
pub fn logo(in: Sidebar, logo: Logo) -> Sidebar {
  UISidebar(..in, logo: Some(logo))
}

/// Set open sidebar visibility
///
pub fn open(in: Sidebar, open: Bool) -> Sidebar {
  UISidebar(..in, open:)
}

/// Toggle open sidebar visibility
///
pub fn toggle(in: Sidebar) -> Sidebar {
  UISidebar(..in, open: !in.open)
}

pub fn selected(in: Sidebar, select_to: String) -> Sidebar {
  let UISidebar(selected:, root:, ..) = in
  let selected = case selected {
    None -> Some(select_to)
    Some(selected) -> do_selected(root, selected, select_to)
  }

  UISidebar(..in, selected:)
}

fn do_selected(menus, selected, to) {
  // is equals
  let is_equals = selected == to
  // is menu group?
  let menu_to = menu.get_menu_group(menus, to)
  let is_menu_group = result.is_ok(menu_to)
  // is 'to menu' child in menu group?
  let menu_group_child = result.map(menu_to, menu.get_menu_child(_, selected))
  let is_menu_group_child = result.is_ok(menu_group_child)

  case is_equals, is_menu_group, is_menu_group_child {
    True, True, _ -> option.None
    False, True, True -> option.None
    _, _, _ -> option.Some(to)
  }
}

/// New render sidebar element
///
pub fn at(in: Sidebar, onclick: OnClick(a)) -> Render(a) {
  UISidebarRender(in:, onclick:)
}

/// Render sidebar element into lustre.element
///
pub fn render(at: Render(a)) -> UIRender(a) {
  let UISidebarRender(in:, onclick:) = at
  let UISidebar(el:, root:, logo:, open:, selected:) = in
  let logo =
    option.map(logo, logo.icon_only(_, !open))
    |> option.map(logo.render)
    |> option.unwrap(element.none())

  // menu root
  let root_menus = menu_roots(root, open, selected, onclick)
  // and nav
  let menu_nav = [html.nav([], root_menus)]
  // and sidebar inner
  let inner_classes = [#("justify-center", !open), #("justify-between", open)]
  let inner = [
    html.div(
      [
        a.class("sidebar-header flex items-center gap-2 pb-7 pt-8"),
        a.classes(inner_classes),
      ],
      [logo],
    ),
    html.div([a.class(sidebar_main_class)], menu_nav),
  ]

  let classes = classes_open(open)
  let attrs = [classes, ..el.attrs(el)]

  html.aside(attrs, inner)
}

// PRIVATE
//

fn set_root(root) {
  use root <- list.map(root)

  menu.root(root, True)
}

fn menu_roots(root, open, selected, onclick) {
  use root <- list.map(root)

  menu.at(root, onclick)
  |> menu.render(open, selected)
}

fn classes_open(open: Bool) {
  [
    #("lg:w-[90px] translate-x-0", !open),
    #("-translate-x-full", open),
  ]
  |> a.classes()
}

const sidebar_class = "sidebar fixed left-0 top-0 z-9999 flex h-screen w-[290px] flex-col"
  <> " overflow-y-hidden border-r border-gray-200 bg-white px-5 duration-300"
  <> " ease-linear dark:border-gray-800 dark:bg-black lg:static lg:translate-x-0"

const sidebar_main_class = "no-scrollbar flex flex-col overflow-y-auto duration-300 ease-linear"
