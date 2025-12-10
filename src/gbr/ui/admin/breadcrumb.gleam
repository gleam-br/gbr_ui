////
//// 🍞 Gleam UI breadcrumb super element.
////
//// ### Roadmap
////
//// - [ ] Parent -> List(Parent) -> Parent(name, href, icon)
////

import gbr/ui/core/el
import gleam/bool
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/element

import lustre/attribute as a
import lustre/element/html

import gbr/ui/core/model.{type UIRender}
import gbr/ui/svg
import gbr/ui/svg/icons as svg_icons

type Breadcrumb =
  UIBreadcrumb

type Parent {
  Parent(href: String, name: String)
}

/// Breadcrumb super element.
///
pub opaque type UIBreadcrumb {
  UIBreadcrumb(el: el.UIEl, current: String, parent: Option(Parent))
}

/// New breadcrumb super element with:
///
/// - id (id element)
/// - current (curent name)
///
pub fn new(id: String, current: String) {
  let el =
    el.new(id)
    |> el.class(content_class)

  UIBreadcrumb(el:, current:, parent: None)
}

/// Set breadcrumb parent
///
pub fn parent(in: Breadcrumb, href: String, name: String) -> Breadcrumb {
  let parent = Some(Parent(href:, name:))

  UIBreadcrumb(..in, parent:)
}

/// Render breadcrumb super element to `lustre/element/html.{div}`.
///
pub fn view(in: Breadcrumb) -> UIRender(a) {
  let UIBreadcrumb(el:, current:, parent:) = in
  let attrs = el.attrs(el)

  html.div(attrs, [
    html.h2([a.class(head_class)], [
      format(current)
      |> html.text(),
    ]),
    html.nav([], [
      html.ol([a.class(group_class)], [
        html.li([], [render_parent(current, parent)]),
        html.li([a.class(crumb_class)], [
          format(current)
          |> html.text(),
        ]),
      ]),
    ]),
  ])
}

// PRIVATE
//

fn render_parent(current, parent: Option(Parent)) {
  use <- bool.guard(option.is_none(parent), element.none())
  let assert Some(Parent(href:, name:)) = parent

  html.a([a.href(href), a.class(link_class)], [
    format(name)
      |> html.text(),

    case current {
      "" -> element.none()
      _ ->
        svg.new(16, 17)
        |> svg_icons.greater()
        |> svg.view()
    },
  ])
}

fn format(in) {
  in
  |> string.replace("-", " ")
  |> string.capitalise()
}

const content_class = "mb-6 flex flex-wrap items-center justify-between gap-3"

const crumb_class = "text-sm text-gray-800 dark:text-white/90"

const group_class = "flex items-center gap-1.5"

const head_class = "text-xl font-semibold text-gray-800 dark:text-white/90"

const link_class = "inline-flex items-center gap-1.5 text-sm text-gray-500 dark:text-gray-400"
