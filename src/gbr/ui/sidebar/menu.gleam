////
//// Gleam UI sidebar menu super element
////

import gleam/bool
import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/event

import lustre/attribute as a
import lustre/element
import lustre/element/html
import lustre/element/keyed

import gbr/ui/svg
import gbr/ui/svg/icons as svg_icons

import gbr/ui/core/model.{type UIKeyed, type UIRender}

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

/// Render sidebar menu element
///
/// - in: Sidebar info
/// - onclick: Sidebar menu on click event
///
pub opaque type UISidebarMenuRender(a) {
  UISidebarMenuRender(in: UISidebarMenu, onclick: a)
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

/// New render sidebar menu element
///
pub fn at(in: UISidebarMenu, onclick: a) -> UISidebarMenuRender(a) {
  UISidebarMenuRender(in:, onclick:)
}

/// Render sidebar menu element
///
pub fn render(
  at: UISidebarMenuRender(a),
  open: Bool,
  selected: Option(String),
) -> UIRender(a) {
  let UISidebarMenuRender(in:, onclick:) = at
  let UISidebarMenu(id:, text:, root:, inner:, ..) = in

  // not root return none
  use <- bool.guard(!root, element.none())

  case inner {
    [] -> element.none()
    inner ->
      html.div([], [
        html.h3(
          [
            // "mb-4 text-xs uppercase leading-[20px] text-gray-400"
            a.class(menu_class),
          ],
          [
            html.span(
              [
                a.class("menu-group-title"),
                a.classes([#("lg:hidden", !open)]),
              ],
              [html.text(text)],
            ),

            svg.new(id <> "sidebar-icon", 24, 24)
              |> svg_icons.reticence()
              // TODO use a.classes
              |> svg.classes([
                "menu-group-icon mx-auto fill-current sm:hidden",
                ..case open {
                  False -> ["lg:block", "hidden"]
                  True -> ["hidden"]
                }
              ])
              |> svg.render(),
          ],
        ),
        html.ul(
          [
            a.id(id <> "sidebar-menu"),
            a.class(menu_item_class),
          ],
          [
            menu_inner(inner, open, selected, onclick)
            |> keyed.fragment(),
          ],
        ),
      ])
  }
}

// PRIVATE
//

fn menu_inner(menus: Inner, open, selected, onclick) -> List(UIKeyed(a)) {
  use menu <- list.map(menus)
  let UISidebarMenu(id, text, _, inner, _) = menu

  case inner {
    [] -> menu_item(id, text, selected, onclick)
    _ -> menu_group(menu, open, selected, onclick)
  }
}

fn menu_group(menu: Menu, open, selected, onclick: a) {
  let UISidebarMenu(id, text, _, inner, svg) = menu
  let name = id <> "sidebar-menu-group"

  let is_selected = case selected {
    None -> False
    Some(selected) ->
      id == selected || option.is_some(selected_(inner, selected))
  }

  #(
    name,
    html.li([a.id(id)], [
      html.a(
        [
          event.on_click(onclick),
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
            [a.class("menu-item-text"), a.classes([#("lg:hidden", !open)])],
            [html.text(text)],
          ),
          html.div(
            [
              a.classes([
                #("menu-item-arrow-active", is_selected),
                #("menu-item-arrow-inactive", !is_selected),
                #("menu-item-arrow", !list.is_empty(inner)),
                #("hidden", list.is_empty(inner)),
                #("lg:hidden", !open),
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
                    !open,
                  ),
                  #("menu-dropdown mt-2 flex flex-col gap-1 pl-9", open),
                ]),
              ],
              [
                menu_inner(inner, open, selected, onclick)
                |> keyed.fragment(),
              ],
            ),
          ]
        },
      ),
    ]),
  )
}

/// Render menu item
///
/// - menu_id: curr menu id
/// - text: menu item title
/// - selected: menu item is selected
/// - onclick: menu item onclick event
///
fn menu_item(menu_id, text, selected, onclick) -> UIKeyed(a) {
  let name = menu_id <> "sidebar-menu-item"
  let is_selected = case selected {
    Some(selected) -> menu_id == selected
    None -> False
  }

  #(
    name,
    html.li([a.id(menu_id)], [
      html.a(
        [
          a.class("menu-dropdown-item group"),
          a.classes([
            #("menu-dropdown-item-active", is_selected),
            #("menu-dropdown-item-inactive", !is_selected),
          ]),
          option.map(onclick, fn(on) {
            on(menu_id)
            |> event.on_click()
          })
            |> option.unwrap(a.none()),
        ],
        [html.text(text)],
      ),
    ]),
  )
}

fn selected_(menu_list: Inner, current: String) {
  let values = {
    use menu <- list.map(menu_list)
    let UISidebarMenu(id, _, root, _, _) = menu

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

const menu_class = "mb-4 text-xs uppercase leading-[20px] text-gray-400"

const menu_item_class = "mb-6 flex flex-col gap-4"
