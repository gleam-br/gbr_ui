////
////
////

import gleam/list
import gleam/option.{type Option, None, Some}

import lustre/attribute as a
import lustre/element
import lustre/element/html

import gbr/ui/link
import gbr/ui/svg
import gbr/ui/svg/icons

import gbr/ui/core/model.{type UIRender}

// Alias
//

type Dropdown =
  UIDropdown

type Item =
  UIDropdownItem

type Items =
  List(Item)

type Render(a) =
  UIDropdownRender(a)

/// Dropdown item element type
///
/// - link: Link element type
/// - text: Optional text to item
/// - svg: Optional icon to item
///
/// or uses separator between items
///
pub opaque type UIDropdownItem {
  Link(link: link.UILink, text: Option(String), svg: Option(svg.Identity))
  Separator
}

/// Dropdown element type
///
/// - title: Dropdown title
/// - open: If open or not
/// - items: Dropdown items
///
pub opaque type UIDropdown {
  UIDropdown(title: String, open: Bool, items: Items)
}

/// Dropdown render element type
///
/// - in: Dropdown element info
/// - ontoggle: Dropdown on toggle open
/// - onclick: Dropdown item on click
///
pub opaque type UIDropdownRender(a) {
  UIDropdownRender(
    in: UIDropdown,
    ontoggle: Option(a),
    onclick: Option(fn(String) -> a),
  )
}

/// New dropdown element
///
/// - title: Dropdown title text
///
pub fn new(title: String) -> Dropdown {
  UIDropdown(title:, open: False, items: [])
}

/// Set dropdown is open or not
///
/// - in: Dropdown element info
/// - open: True open, False closed
///
pub fn open(in: Dropdown, open: Bool) -> Dropdown {
  UIDropdown(..in, open:)
}

/// Toggle dropdown open
///
/// - in: Dropdown element info
///
pub fn toggle(in: Dropdown) -> Dropdown {
  open(in, !in.open)
}

/// Set dropdown items <ul>...</ul>
///
/// - in: Dropdown element info
///
pub fn items(in: Dropdown, items: Items) -> Dropdown {
  UIDropdown(..in, items:)
}

/// New dropdown item <li>
///
/// - id: Item identification
///
pub fn item(id: String) -> Item {
  let link =
    link.new(id)
    |> link.class(
      "flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium "
      <> "text-gray-700 hover:bg-gray-50 dark:text-gray-300 dark:hover:bg-white/5",
    )

  Link(link:, text: None, svg: None)
}

///
///
pub fn item_href(in: Item, href: String) -> Item {
  case in {
    Link(..) -> Link(..in, link: link.href(in.link, href))
    _ -> in
  }
}

/// Set dropdown item text
///
/// - in: Dropdown item element info
/// - text: Item text to show
///
pub fn item_text(in: Item, text: String) -> Item {
  case in {
    Link(..) -> Link(..in, text: Some(text))
    _ -> in
  }
}

/// Set dropdown item svg element
///
/// - in: Dropdown item element info
/// - svg: Transform svg function
///
pub fn item_svg(in: Item, svg: svg.Identity) -> Item {
  case in {
    Link(..) -> Link(..in, svg: Some(svg))
    _ -> in
  }
}

/// New dropdown separator item
///
pub fn separator() {
  Separator
}

/// New dropdown render element
///
/// - in: Dropdown element info
///
pub fn at(in: Dropdown) -> Render(a) {
  UIDropdownRender(in:, ontoggle: None, onclick: None)
}

/// Set dropdown on open toggle event
///
pub fn ontoggle(at: Render(a), ontoggle: a) -> Render(a) {
  UIDropdownRender(..at, ontoggle: Some(ontoggle))
}

/// Set dropdown on click item event
///
pub fn onclick(at: Render(a), onclick: fn(String) -> a) -> Render(a) {
  UIDropdownRender(..at, onclick: Some(onclick))
}

///
///
pub fn render(at: Render(a)) -> UIRender(a) {
  let UIDropdownRender(in:, ontoggle:, onclick:) = at
  let UIDropdown(title:, open:, items:) = in

  html.div([a.class("relative inline-block")], [
    link.new("#")
      |> link.class(
        "inline-flex items-center gap-2 rounded-lg bg-brand-500 px-4 "
        <> "py-3 text-sm font-medium text-white hover:bg-brand-600",
      )
      |> link.at([
        html.text(title),
        svg.new(20, 20)
          |> svg.classes([#("rotate-180", open)])
          |> icons.arrow_small()
          |> svg.class("stroke-current duration-200 ease-in-out")
          |> svg.render(),
      ])
      |> link.onclick_opt(
        ontoggle
        |> option.map(fn(ontoggle) { fn(_) { ontoggle } }),
      )
      |> link.render(),
    html.div(
      [
        a.classes([#("hidden", !open)]),
        a.class(
          "absolute left-0 top-full z-40 mt-2 w-full min-w-[260px] rounded-2xl border "
          <> "border-gray-200 bg-white p-3 shadow-theme-lg dark:border-gray-800 dark:bg-[#1E2635]",
        ),
      ],
      [html.ul([a.class("flex flex-col gap-1")], render_items(items, onclick))],
    ),
  ])
}

//PRIVATE
//

fn render_items(items, onclick) {
  use item <- list.map(items)

  let inner = case item {
    Link(link:, text:, svg:) -> render_link(link, text, svg, onclick)
    Separator -> render_sep()
  }

  html.li([], [inner])
}

fn render_link(link, text, svg, onclick) {
  let text =
    text
    |> option.map(html.text)
    |> option.unwrap(element.none())
  let svg =
    svg
    |> option.map(fn(svg) {
      svg.new(24, 24)
      |> svg()
      |> svg.render()
    })
    |> option.unwrap(element.none())

  link
  |> link.at([svg, text])
  |> link.onclick_opt(onclick)
  |> link.render()
}

fn render_sep() {
  html.span(
    [a.class("my-1.5 block h-px w-full bg-gray-200 dark:bg-[#353C49]")],
    [],
  )
}
