////
//// ☰ Gleam UI sidebar super element
////

import gleam/bool
import gleam/list
import gleam/option.{type Option, None, Some}

import lustre/attribute as a
import lustre/element
import lustre/element/html
import lustre/element/keyed

import gbr/ui/logo.{type UILogo}
import gbr/ui/svg
import gbr/ui/svg/icons as svg_icons

import gbr/ui/sidebar/menu.{type UISidebarMenu}

import gbr/ui/core/model.{type UIKeyed, type UIRender, random_str}

type Sidebar =
  UISidebar

type Render(a) =
  UISidebarRender(a)

type Menu =
  UISidebarMenu

type Inner =
  List(UISidebarMenu)

type Logo =
  UILogo

/// Sidebar super element
///
/// - id: html id
/// - logo: Sidebar logo head
/// - menu: Sidebar menu root
/// - visible: Sidebar is visible (expanded)
/// - selected: Sidebar menu id selected
///
pub opaque type UISidebar {
  UISidebar(
    id: String,
    logo: Logo,
    root: Menu,
    visible: Bool,
    selected: Option(String),
  )
}

/// Render sidebar element.
///
pub opaque type UISidebarRender(a) {
  UISidebarRender(in: Sidebar)
}

/// New sidebar element
///
/// - id: html id
/// - logo_img: Logotype image path
///
pub fn new(id: String, logo: Logo, root: Menu) -> Sidebar {
  UISidebar(id: random_str(id), logo:, root:, selected: None, visible: True)
}

/// New render sidebar element
///
pub fn at(in: Sidebar) -> Render(a) {
  UISidebarRender(in:)
}

/// Render sidebar element into lustre.element
///
pub fn render(at: Render(a)) -> UIRender(a) {
  let UISidebarRender(in:) = at
  let UISidebar(id:, logo:, visible:, ..) = in

  html.aside(
    [
      a.id(id),
      a.class(sidebar_class),
      a.classes([
        #("lg:w-[90px]", !visible),
        #("translate-x-0", !visible),
        #("-translate-x-full", visible),
      ]),
    ],
    [
      logo.icon_only(logo, visible)
        |> logo.render(),
      html.div([a.class(sidebar_main_class)], [html.nav([], [menu_root(in)])]),
    ],
  )
}

pub fn visible(in: Sidebar, visible: Bool) {
  UISidebar(..in, visible:)
}

/// Set sidebar head logo
///
/// - logo: Logo info
///
pub fn logo(in: Sidebar, logo: Logo) -> Sidebar {
  UISidebar(..in, logo:)
}

/// Toggle sidebar visibility
///
pub fn toggle_visible(in: Sidebar) {
  UISidebar(..in, visible: !in.visible)
}

/// Get all sidebar menus
///
pub fn menus(in: Sidebar) -> List(Menu) {
  do_menus(in.root, [])
}

// PRIVATE
//

fn do_menus(menu, acc) -> List(Menu) {
  use _, _, _, inner, _ <- menu.in(menu)

  case inner {
    [] -> acc
    inner -> list.append(acc, inner)
  }
}

fn menu_root(in: Sidebar) -> UIRender(a) {
  let UISidebar(visible:, root:, ..) = in

  let menu_group_icon_class = case visible {
    False -> ["lg:block", ":hidden"]
    True -> ["hidden"]
  }

  use id, text, root, inner, _svg <- menu.in(root)
  use <- bool.guard(!root, element.none())
  let id = random_str(id)

  case inner {
    [] -> element.none()
    inner ->
      html.div([a.id(id <> "sidebar-root")], [
        html.h3(
          [
            a.class(menu_class),
          ],
          [
            html.span(
              [
                a.class("menu-group-title"),
                a.classes([#("lg:hidden", !visible)]),
              ],
              [html.text(text)],
            ),
            svg.new(id <> "sidebar-icon", 24, 24)
              |> svg_icons.reticence()
              // TODO use a.classes
              |> svg.classes([
                "menu-group-icon mx-auto fill-current sm:hidden",
                ..menu_group_icon_class
              ])
              |> svg.render(),
          ],
        ),
        html.ul(
          [
            a.id(id <> "sidebar-menu"),
            a.class(menu_item_class),
          ],
          [keyed.fragment(menu_inner(in, inner))],
        ),
      ])
  }
}

fn menu_inner(in: Sidebar, menus: Inner) -> List(UIKeyed(a)) {
  use menu <- list.map(menus)
  use id, text, _, inner, svg <- menu.in(menu)

  case inner {
    [] -> menu_item(in, text, id)
    inner -> menu_group(in, id, text, svg, inner)
  }
}

fn menu_group(in: Sidebar, id, title, svg, inner) -> UIKeyed(a) {
  let UISidebar(visible:, selected:, ..) = in
  let name = random_str(id) <> "sidebar-menu-group"

  let is_selected = case selected {
    None -> False
    Some(selected) ->
      id == selected || option.is_some(selected_(inner, selected))
  }

  #(
    name,
    html.li(
      [
        a.id(random_str(id)),
      ],
      [
        html.a(
          [
            // TODO: onclick
            a.href(id),
            a.class("menu-item group"),
            a.classes([
              #("menu-item-active", is_selected),
              #("menu-item-inactive", !is_selected),
            ]),
          ],
          [
            case svg {
              None -> element.none()
              Some(svg) ->
                html.div(
                  [
                    a.classes([
                      #(
                        "[&>*]:fill-brand-500 [&>*]:dark:fill-brand-400",
                        is_selected,
                      ),
                      #(
                        "[&>*]:fill-gray-500 [&>*]:group-hover:fill-gray-700 [&>*]:dark:fill-gray-400 [&>*]:dark:group-hover:fill-gray-300",
                        !is_selected,
                      ),
                    ]),
                  ],
                  [svg.render(svg)],
                )
            },
            html.span(
              [a.class("menu-item-text"), a.classes([#("lg:hidden", !visible)])],
              [html.text(title)],
            ),
            html.div(
              [
                a.classes([
                  #("menu-item-arrow-active", is_selected),
                  #("menu-item-arrow-inactive", !is_selected),
                  #("menu-item-arrow", !list.is_empty(inner)),
                  #("hidden", list.is_empty(inner)),
                  #("lg:hidden", !visible),
                ]),
              ],
              [
                svg.new("sidebar-menu-item-icon-arrow", 20, 20)
                |> svg_icons.arrow()
                |> svg.render(),
              ],
            ),
          ],
        ),
        html.div(
          [
            a.class("translate transform overflow-hidden"),
            a.classes([#("block", is_selected)]),
            a.classes([#("hidden", is_selected)]),
          ],
          // TODO: improve inner code
          case inner {
            [] -> []
            inner -> [
              html.ul(
                [
                  a.class("menu-dropdown mt-2 flex flex-col gap-1 pl-9"),
                  a.classes([
                    #(
                      "menu-dropdown mt-2 flex flex-col gap-1 pl-9 lg:hidden",
                      !visible,
                    ),
                    #("menu-dropdown mt-2 flex flex-col gap-1 pl-9", visible),
                  ]),
                ],
                [keyed.fragment(menu_inner(in, inner))],
              ),
            ]
          },
        ),
      ],
    ),
  )
}

fn menu_item(model: Sidebar, title, id) -> UIKeyed(a) {
  let name = random_str(id) <> "sidebar-menu-item-" <> title
  let is_selected = case model.selected {
    Some(selected) -> id == selected
    None -> False
  }
  let menu_item_dropdown_class = case is_selected {
    True -> "menu-dropdown-item-active"
    False -> "menu-dropdown-item-inactive"
  }

  #(
    name,
    html.li(
      [
        a.id(random_str(id)),
      ],
      [
        html.a(
          [
            a.class("menu-dropdown-item group " <> menu_item_dropdown_class),
            // TODO: onsubmit
            a.href(id),
          ],
          [html.text(title)],
        ),
      ],
    ),
  )
}

fn selected_(menu_list: Inner, current: String) {
  let values = {
    use menu <- list.map(menu_list)
    use id, _, root, _, _ <- menu.in(menu)

    case root {
      True -> None
      False -> Some(id)
    }
  }
  let filtered =
    list.filter(values, option.is_some)
    |> list.map(option.unwrap(_, ""))

  list.find(filtered, fn(t) { t == current })
  |> option.from_result()
}

const sidebar_class = "sidebar fixed left-0 top-0 z-9999 flex h-screen w-[290px] flex-col overflow-y-hidden border-r border-gray-200 bg-white px-5 duration-300 ease-linear dark:border-gray-800 dark:bg-black lg:static lg:translate-x-0"

const menu_class = "mb-4 text-xs uppercase leading-[20px] text-gray-400"

const menu_item_class = "mb-6 flex flex-col gap-4"

const sidebar_main_class = "no-scrollbar flex flex-col overflow-y-auto duration-300 ease-linear"
