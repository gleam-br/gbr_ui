////
//// Sidebar component module
////

// IMPORTS ---------------------------------------------------------------------
//
import gleam/bool
import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/element

import lustre/attribute as a
import lustre/element/html
import lustre/element/keyed

import gbr/ui/logo.{type UILogo}
import gbr/ui/svg
import gbr/ui/svg/icons as svg_icons

import gbr/ui/sidebar/menu.{type UISidebarMenu}

import gbr/ui/core/model.{type UIKeyed, type UIRender, to_id}

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

type Head =
  Option(Logo)

pub opaque type UISidebar {
  UISidebar(
    id: String,
    head: Head,
    visible: Bool,
    menu: Option(Menu),
    selected: Option(String),
  )
}

pub opaque type UISidebarRender(a) {
  UISidebarRender(in: Sidebar)
}

pub fn new(id: String) -> Sidebar {
  UISidebar(
    id: to_id(id),
    head: None,
    menu: None,
    selected: None,
    visible: True,
  )
}

// UPDATE > RENDER -------------------------------------------------------------
//
pub fn render(at: Render(a)) -> UIRender(a) {
  let UISidebarRender(in:) = at
  let UISidebar(head:, visible:, ..) = in
  let toggle_class = case visible {
    False -> "translate-x-0 lg:w-[90px]"
    True -> "-translate-x-full"
  }

  html.aside(
    [
      a.id("falcon-ui-sidebar"),
      a.class(sidebar_class),
      a.class(toggle_class),
    ],
    [
      menu_head(head, visible),
      html.div(
        [
          a.class(
            "no-scrollbar flex flex-col overflow-y-auto duration-300 ease-linear",
          ),
        ],
        [html.nav([], [menu_main(in)])],
      ),
    ],
  )
}

// PUBLICS ---------------------------------------------------------------------
//
pub fn visible(in: Sidebar, visible: Bool) {
  UISidebar(..in, visible:)
}

pub fn head(in: Sidebar, head: Head) -> Sidebar {
  UISidebar(..in, head:)
}

pub fn menu(in: Sidebar, menu: Menu) -> Sidebar {
  UISidebar(..in, menu: Some(menu))
}

pub fn toggle_visible(in: Sidebar) {
  UISidebar(..in, visible: !in.visible)
}

pub fn get_all(in: Sidebar) -> List(Menu) {
  let UISidebar(menu:, ..) = in
  do_all(menu, [])
}

// PRIVATES --------------------------------------------------------------------
//
fn do_all(menu, acc) -> List(Menu) {
  use <- bool.guard(option.is_none(menu), [])
  let assert Some(menu) = menu

  use _, _, _, inner, _ <- menu.in(menu)

  case inner {
    Some(inner) -> list.append(acc, inner)
    None -> acc
  }
}

fn menu_head(head, visible) -> UIRender(a) {
  use <- bool.guard(option.is_none(head), element.none())

  let assert Some(logo) = head
  let logo.UILogo(id:, img:, img_dark:, icon:, href:, alt:) = logo
  let href = option.unwrap(href, "_blank")
  let alt = option.unwrap(alt, "logo")
  let icon = option.unwrap(icon, img)
  let img_dark = option.unwrap(img_dark, img)

  let logo_class = case visible {
    False -> "hidden"
    True -> ""
  }
  let logo_icon_class = case visible {
    False -> "lg:block"
    True -> "hidden"
  }

  html.div([a.id(to_id(id)), a.class(head_class)], [
    html.a([a.href(href)], [
      html.span(
        [
          a.class("logo"),
          a.class(logo_class),
        ],
        [
          html.img([
            a.class("dark:hidden"),
            a.src(img),
            a.alt(alt),
          ]),
          html.img([
            a.class("hidden dark:block"),
            a.src(img_dark),
            a.alt(alt),
          ]),
        ],
      ),
      html.img([
        a.class("logo-icon"),
        a.class(logo_icon_class),
        a.src(icon),
        a.alt(alt),
      ]),
    ]),
  ])
}

fn menu_main(in: Sidebar) -> UIRender(a) {
  let UISidebar(visible:, menu:, ..) = in

  use <- bool.guard(option.is_none(menu), element.none())
  let assert Some(menu) = menu

  let menu_group_title_class = case visible {
    False -> "lg:hidden"
    True -> ""
  }
  let menu_group_icon_class = case visible {
    False -> ["lg:block", ":hidden"]
    True -> ["hidden"]
  }

  use id, text, root, inner, _svg <- menu.in(menu)

  case root, inner {
    True, Some(inner) ->
      html.div([a.id(to_id(id))], [
        html.h3(
          [
            a.id("falcon-ui-sidebar-menu-title-" <> text),
            a.class(menu_class),
          ],
          [
            html.span(
              [
                a.class("menu-group-title"),
                a.class(menu_group_title_class),
              ],
              [html.text(text)],
            ),
            svg.new("sidebar-menu-group-icon", 24, 24)
              |> svg_icons.reticence()
              |> svg.classes([
                "menu-group-icon mx-auto fill-current sm:hidden",
                ..menu_group_icon_class
              ])
              |> svg.render(),
          ],
        ),
        html.ul(
          [
            a.id("falcon-ui-sidebar-menu-" <> text),
            a.class(menu_item_class),
          ],
          [keyed.fragment(menu_inner(in, inner))],
        ),
      ])
    _, _ -> element.none()
  }
}

fn menu_inner(in: Sidebar, menus: Inner) -> List(UIKeyed(a)) {
  use menu <- list.map(menus)
  use id, text, _, inner, svg <- menu.in(menu)

  case inner {
    Some(inner) -> menu_group(in, id, text, svg, inner)
    None -> menu_item(in, text, id)
  }
}

fn menu_group(in: Sidebar, id, title, svg, inner) -> UIKeyed(a) {
  let UISidebar(visible:, selected:, ..) = in
  let name = "falcon-ui-sidebar-menu-group-" <> title
  let is_selected = case selected {
    None -> False
    Some(selected) ->
      id == selected || option.is_some(selected_(inner, selected))
  }
  let menu_item_class = case is_selected {
    True -> "menu-item-active"
    False -> "menu-item-inactive"
  }
  let menu_item_icon_class = case is_selected {
    True -> "[&>*]:fill-brand-500 [&>*]:dark:fill-brand-400"
    False ->
      "[&>*]:fill-gray-500 [&>*]:group-hover:fill-gray-700 [&>*]:dark:fill-gray-400 [&>*]:dark:group-hover:fill-gray-300"
  }
  let menu_item_dropdown_class = case is_selected {
    True -> "block"
    False -> "hidden"
  }
  let menu_item_arrow_class = case is_selected {
    True -> "menu-item-arrow-active"
    False -> "menu-item-arrow-inactive"
  }
  let menu_item_arrow_display = case inner {
    [] -> "hidden"
    _ -> "menu-item-arrow"
  }
  let menu_item_arrow_toggle = case visible {
    False -> "lg:hidden"
    True -> ""
  }

  #(
    name,
    html.li(
      [
        a.id(to_id(id)),
      ],
      [
        html.a(
          [
            // TODO: onclick
            a.href(id),
            a.class("menu-item group"),
            a.class(menu_item_class),
          ],
          [
            html.div(
              [
                a.class(menu_item_icon_class),
              ],
              [
                case svg {
                  Some(svg) -> svg.render(svg)
                  None -> element.none()
                },
              ],
            ),
            html.span(
              [
                a.class("menu-item-text"),
                case visible {
                  True -> a.none()
                  False -> a.class("lg:hidden")
                },
              ],
              [html.text(title)],
            ),
            html.div(
              [
                a.class(menu_item_arrow_class),
                a.class(menu_item_arrow_display),
                a.class(menu_item_arrow_toggle),
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
            a.class(menu_item_dropdown_class),
          ],
          case inner {
            [] -> []
            _ -> [
              html.ul(
                [
                  a.class("menu-dropdown mt-2 flex flex-col gap-1 pl-9"),
                  case visible {
                    False -> a.class("lg:hidden")
                    True -> a.none()
                  },
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
  let name = "falcon-ui-sidebar-menu-item-" <> title
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
        a.id(to_id(id)),
      ],
      [
        html.a(
          [
            a.class("menu-dropdown-item group"),
            a.class(menu_item_dropdown_class),
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

//removed -> "sidebar-header",
const head_class = "flex items-center gap-2 pb-7 pt-8 justify-center"

const menu_class = "mb-4 text-xs uppercase leading-[20px] text-gray-400"

const menu_item_class = "mb-6 flex flex-col gap-4"
