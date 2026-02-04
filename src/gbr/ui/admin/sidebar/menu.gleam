////
//// Gleam UI sidebar menu super element
////

import gleam/bool
import gleam/list
import gleam/option.{type Option, None, Some}

import lustre/attribute as a
import lustre/element
import lustre/element/html
import lustre/element/keyed
import lustre/event

import gbr/ui/svg
import gbr/ui/svg/icons as svg_icons

import gbr/ui/core/model.{type UIKeyed, type UIRender}

type Menu =
  UISidebarMenu

type Render(a) =
  UISidebarMenuRender(a)

type Inner =
  List(UISidebarMenu)

type OnClick(a) =
  UISidebarMenuOnClick(a)

/// On click sidebar menu
///
/// - id: Menu id
/// - menu: Menu info element
///
/// Returns:
/// - Generic lustre event
///
pub type UISidebarMenuOnClick(a) =
  fn(String, Menu) -> a

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
    inner: Inner,
    parent: Option(String),
    svg: Option(svg.Identity),
  )
}

/// Render sidebar menu element
///
/// - in: Sidebar info
/// - onclick: Sidebar menu on click event
///
pub opaque type UISidebarMenuRender(a) {
  UISidebarMenuRender(in: UISidebarMenu, onclick: Option(OnClick(a)))
}

/// New sidebar menu super element
///
/// - id: htmlid
///
pub fn new(id: String) -> Menu {
  UISidebarMenu(id:, text: "", parent: None, inner: [], svg: None)
}

/// Set title menu
///
/// - text: Title to menu
///
pub fn title(in: Menu, text: String) -> Menu {
  UISidebarMenu(..in, text:)
}

/// Set icon to menu
///
/// - svg: Icon to menu
///
pub fn icon(in: Menu, svg: svg.Identity) -> Menu {
  UISidebarMenu(..in, svg: Some(svg))
}

/// Set list of menus inner parent menu
///
/// - inner: List of menus inner parent menu
///
pub fn inner(in: Menu, inner: List(Menu)) -> Menu {
  let inner = set_parent(in, inner)

  UISidebarMenu(..in, inner:)
}

/// Get parent menu id, if exits
///
pub fn parent(in: Menu) -> Option(String) {
  in.parent
}

/// Is menu group menu witch contains inner
///
pub fn is_menu_group(menu: Menu) -> Bool {
  !list.is_empty(menu.inner)
}

/// Is menu child that is parent menu
///
pub fn is_menu_child(menu: Menu, id: String) -> Bool {
  is_menu_child_inner(menu.inner, id)
}

/// Find menu by id
///
pub fn find_menu(menus: List(Menu), id) -> Option(Menu) {
  all_(menus)
  |> list.find(fn(m) { m.id == id })
  |> option.from_result()
}

/// New render sidebar menu element
///
pub fn render(in: Menu, onclick: Option(OnClick(a))) -> Render(a) {
  UISidebarMenuRender(in:, onclick:)
}

/// Render sidebar menu element
///
pub fn view(at: Render(a), open: Bool, selected: Option(String)) -> UIRender(a) {
  let UISidebarMenuRender(in:, onclick:) = at
  let UISidebarMenu(id:, text:, parent:, inner:, ..) = in

  // has parent return none
  use <- bool.guard(option.is_some(parent), element.none())

  case inner {
    [] -> element.none()
    inner ->
      html.div([], [
        html.h3(
          [
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

            svg.new(24, 24)
              |> svg.class(
                "menu-group-icon mx-auto fill-current sm:hidden "
                <> case open {
                  False -> "lg:block hidden"
                  True -> "hidden"
                },
              )
              |> svg_icons.reticence()
              |> svg.view(),
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

fn all_(menus: List(Menu)) {
  use m <- list.flat_map(menus)

  [m, ..all_(m.inner)]
}

fn is_menu_child_inner(inner: List(Menu), id: String) -> Bool {
  use menu <- list.any(inner)

  use <- bool.guard(menu.id == id, True)

  case menu.inner {
    [] -> False
    inner -> is_menu_child_inner(inner, id)
  }
}

fn render_icon(svg, is_selected) {
  case svg {
    None -> element.none()
    Some(transform) ->
      html.div(
        [
          a.classes([
            #("[&>*]:fill-brand-500 [&>*]:dark:fill-brand-400", is_selected),
            #(
              "[&>*]:fill-gray-500 [&>*]:group-hover:fill-gray-700 [&>*]:dark:fill-gray-400 [&>*]:dark:group-hover:fill-gray-300",
              !is_selected,
            ),
          ]),
        ],
        [svg.new(24, 24) |> transform() |> svg.view()],
      )
  }
}

fn set_parent(in: Menu, inner: List(Menu)) -> List(Menu) {
  use menu <- list.map(inner)

  UISidebarMenu(..menu, parent: Some(in.id))
}

fn menu_inner(menus: Inner, open, selected, onclick) -> List(UIKeyed(a)) {
  use menu <- list.map(menus)

  case menu.inner {
    [] -> menu_item(menu, open, selected, onclick)
    _ -> menu_group(menu, open, selected, onclick)
  }
}

fn menu_group(menu: Menu, open, selected, onclick) {
  let UISidebarMenu(id:, text:, inner:, svg:, ..) = menu

  let is_selected = case selected {
    None -> False
    Some(selected) -> id == selected || is_menu_child(menu, selected)
  }

  #(
    id,
    html.li([a.id(id)], [
      html.a(
        [
          a.href(id),
          a.class("menu-item group cursor-pointer"),
          a.classes([
            #("menu-item-active", is_selected),
            #("menu-item-inactive", !is_selected),
          ]),
          onclick
            |> option.map(fn(onclick) { event.on_click(onclick(id, menu)) })
            |> option.unwrap(a.none()),
        ],
        [
          render_icon(svg, is_selected),
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
              svg.new(20, 20)
              |> svg_icons.arrow_small()
              |> svg.view(),
            ],
          ),
        ],
      ),
      html.div(
        [
          a.class("translate transform overflow-hidden"),
          a.classes([#("block", is_selected)]),
          a.classes([#("hidden", !is_selected)]),
        ],
        // TODO: improve inner code
        case inner {
          [] -> []
          inner -> [
            html.ul(
              [
                a.class(
                  "menu-dropdown mt-2 flex flex-col gap-1 pl-9 cursor-pointer",
                ),
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
/// - menu: current menu element
/// - text: menu item title
/// - selected: menu item is selected
/// - onclick: menu item onclick event
///
fn menu_item(menu, open, selected, onclick) -> UIKeyed(a) {
  let UISidebarMenu(id:, text:, svg:, ..) = menu
  let is_selected = case selected {
    Some(selected) -> id == selected
    None -> False
  }

  #(
    id,
    html.li([a.id(id)], [
      html.a(
        [
          a.href(id),
          a.class("menu-dropdown-item group cursor-pointer"),
          a.classes([
            #("menu-dropdown-item-active", is_selected),
            #("menu-dropdown-item-inactive", !is_selected),
          ]),
          onclick
            |> option.map(fn(onclick) { event.on_click(onclick(id, menu)) })
            |> option.unwrap(a.none()),
        ],
        [
          render_icon(svg, is_selected),
          html.span(
            [a.class("menu-item-text"), a.classes([#("lg:hidden", !open)])],
            [html.text(text)],
          ),
        ],
      ),
    ]),
  )
}

const menu_class = "mb-4 text-xs uppercase leading-[20px] text-gray-400"

const menu_item_class = "mb-6 flex flex-col gap-4"
