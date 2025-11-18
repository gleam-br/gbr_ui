////
//// Gleam UI sidebar menu super element
////

import gleam/option.{type Option, None, Some}

import gbr/ui/svg

type Menu =
  UISidebarMenu

type Inner =
  List(UISidebarMenu)

/// Sidebar super element
///
/// - id: html id
/// - text: Title to show
/// - root: Is root menu, without parent
/// - inner: Inner menus or None
/// - svg: Icon menu or None
///
pub opaque type UISidebarMenu {
  UISidebarMenu(
    id: String,
    text: String,
    root: Bool,
    inner: Inner,
    svg: Option(svg.Svg),
  )
}

/// New sidebar menu super element
///
/// - id: htmlid
///
pub fn new(id: String) -> Menu {
  UISidebarMenu(id:, text: "", root: False, inner: [], svg: None)
}

/// Set title menu
///
/// - text: Title to menu
///
pub fn title(in: Menu, text: String) -> Menu {
  UISidebarMenu(..in, text:)
}

/// Set root menu
///
/// - root: If is root menu
///
pub fn root(in: Menu, root: Bool) -> Menu {
  UISidebarMenu(..in, root:)
}

/// Set icon to menu
///
/// - svg: Icon to menu
///
pub fn icon(in: Menu, svg: svg.Svg) -> Menu {
  UISidebarMenu(..in, svg: Some(svg))
}

/// Push one more inner menu
///
/// - menu: Menu to push in menus
///
pub fn inner(in: Menu, menu: Menu) -> Menu {
  let menu = root(menu, False)

  UISidebarMenu(..in, inner: [menu, ..in.inner])
}

/// Walk in menu infos
///
/// - in: In menu with
/// - callback: (id, text, root, inner, svg) -> a
///
pub fn in(
  in: Menu,
  callback: fn(String, String, Bool, Inner, Option(svg.Svg)) -> a,
) -> a {
  let UISidebarMenu(id:, text:, root:, inner:, svg:) = in

  callback(id, text, root, inner, svg)
}
