////
//// ☰ Gleam UI sidebar super element
////

import gleam/list
import gleam/option.{type Option, None}

import lustre/attribute as a
import lustre/element/html

import gbr/ui/logo.{type UILogo}

import gbr/ui/sidebar/menu.{type UISidebarMenuRender}

import gbr/ui/core/model.{type UIRender, random_str}

type Sidebar =
  UISidebar

type Render(a) =
  UISidebarRender(a)

type Menu(a) =
  UISidebarMenuRender(a)

type Logo =
  UILogo

/// Sidebar super element
///
/// - id: html id
/// - logo: Sidebar head logo
/// - menu: Sidebar root list menus
/// - open: Sidebar is open (expanded)
/// - selected: Sidebar menu id selected
///
pub opaque type UISidebar {
  UISidebar(id: String, open: Bool, selected: Option(String))
}

/// Render sidebar element.
///
pub opaque type UISidebarRender(a) {
  UISidebarRender(in: Sidebar, logo: Logo, root: List(Menu(a)))
}

/// New sidebar element
///
/// - id: html id
/// - logo_img: Logotype image path
///
pub fn new(id: String) -> Sidebar {
  UISidebar(id: random_str(id), selected: None, open: True)
}

/// Set open sidebar visibility
///
pub fn open(in: Sidebar, open: Bool) -> Sidebar {
  UISidebar(..in, open:)
}

/// Toggle open sidebar visibility
///
pub fn toggle_open(in: Sidebar) -> Sidebar {
  UISidebar(..in, open: !in.open)
}

/// New render sidebar element
///
pub fn at(in: Sidebar, logo: Logo, root: List(Menu(a))) -> Render(a) {
  UISidebarRender(in:, logo:, root: menu.roots(root))
}

/// Render sidebar element into lustre.element
///
pub fn render(at: Render(a)) -> UIRender(a) {
  let UISidebarRender(in:, root:, logo:) = at
  let UISidebar(id:, open:, selected:) = in

  // menu root
  let root_menus = menu_roots(root, open, selected)
  // and nav
  let menu_nav = [html.nav([], root_menus)]
  // and sidebar inner
  let inner = [
    html.div(
      [
        a.class("sidebar-header flex items-center gap-2 pb-7 pt-8"),
        a.classes([#("justify-center", open), #("justify-between", !open)]),
      ],
      [
        logo.icon_only(logo, open) |> logo.render(),
      ],
    ),
    html.div(
      [
        // "no-scrollbar flex flex-col overflow-y-auto duration-300 ease-linear"
        a.class(sidebar_main_class),
      ],
      menu_nav,
    ),
  ]
  // with sidebar attributes
  let attr = [
    a.id(id),
    a.class(
      //"sidebar fixed left-0 top-0 z-9999 flex h-screen w-[290px] flex-col overflow-y-hidden border-r border-gray-200 bg-white px-5 duration-300 ease-linear dark:border-gray-800 dark:bg-black lg:static lg:translate-x-0",
      sidebar_class,
    ),
    a.classes([
      #("lg:w-[90px]", !open),
      #("translate-x-0", !open),
      #("-translate-x-full", open),
    ]),
  ]

  // render sidebar in `html.aside`
  html.aside(attr, inner)
}

// PRIVATE
//

fn menu_roots(root, open, selected) {
  use root <- list.map(root)

  menu.render(root, open, selected)
}

const sidebar_class = //
"sidebar fixed left-0 top-0 z-9999 flex h-screen w-[290px] flex-col overflow-y-hidden border-r border-gray-200 bg-white px-5 duration-300 ease-linear dark:border-gray-800 dark:bg-black lg:static lg:translate-x-0"

const sidebar_main_class = "no-scrollbar flex flex-col overflow-y-auto duration-300 ease-linear"
