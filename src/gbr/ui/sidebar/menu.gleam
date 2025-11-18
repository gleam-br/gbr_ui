////
//// Gleam UI sidebar menu super element
////

import gleam/option.{type Option}

import gbr/ui/svg

type Menu =
  UISidebarMenu

type Inner =
  List(UISidebarMenu)

pub opaque type UISidebarMenu {
  UISidebarMenu(
    id: String,
    text: String,
    root: Bool,
    inner: Option(Inner),
    svg: Option(svg.Svg),
  )
}

pub fn in(
  in: Menu,
  callback: fn(String, String, Bool, Option(Inner), Option(svg.Svg)) -> a,
) -> a {
  let UISidebarMenu(id:, text:, root:, inner:, svg:) = in

  callback(id, text, root, inner, svg)
}
