////
////
////

import gleam/option.{type Option, None, Some}

import gbr/ui/button
import gbr/ui/svg
import gbr/ui/svg/icons as svg_icons

import gbr/ui/core/model.{type UIRender, type UIRenders}

// Alias
//

pub const new = button.new

pub const kind = button.kind

pub const sm = button.sm

pub const md = button.md

pub const lg = button.lg

pub const label = button.label

pub const disabled = button.disabled

pub const class = button.class

pub const class_append = button.class_append

pub const classes = button.classes

pub const render = button.render

pub const render_left = button.render_left

pub const render_right = button.render_right

pub const onclick = button.onclick

pub const view = button.view

pub type UIButton =
  button.UIButton

pub type UIButtonRender(a) =
  button.UIButtonRender(a)

type Button =
  UIButton

type Render(a) =
  UIButtonRender(a)

/// Set button primary behavior.
///
pub fn primary(in: Button) -> Button {
  class(in, const_primary_class)
}

/// Set button secondary behavior.
///
pub fn secondary(in: Button) -> Button {
  class(in, secondary_class)
}

/// Set button secondary behavior.
///
pub fn tertiary(in: Button) -> Button {
  class(in, const_tertiary_class)
}

/// View button refresh with icon and animation.
///
/// - id: Id button.
/// - loading: If is loading or not (animete or not).
/// - onclick: Evento onclick uses with `loading` param.
///
pub fn refresh(id: String, loading: Bool, onclick_: a) -> UIRender(a) {
  let inner =
    svg.new(20, 20)
    |> svg_icons.refresh()
    |> svg.class("group-active:rotate-180 transition-transform duration-500")
    |> svg.classes([#("animate-spin", loading)])
    |> svg.view()
  let class_ =
    "flex h-10 w-full max-w-10 items-center justify-center rounded-lg border "
    <> "border-gray-200 text-gray-500 transition-colors hover:bg-gray-100 "
    <> "hover:text-gray-700 dark:border-gray-800 dark:text-gray-400 "
    <> "dark:hover:bg-gray-800 dark:hover:text-white"

  new(id)
  |> disabled(loading)
  |> class(class_)
  |> render([inner])
  |> onclick(Some(onclick_))
  |> view()
}

pub fn close(id: String, onclick_: a) -> UIRender(a) {
  let inner =
    svg.new(24, 24)
    |> svg_icons.cross()
    |> svg.view()
  let class_ =
    "absolute right-3 top-3 z-999 flex h-9.5 w-9.5 items-center justify-center "
    <> "rounded-full bg-gray-100 text-gray-400 transition-colors hover:bg-gray-200 "
    <> "hover:text-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:hover:bg-gray-700 "
    <> "dark:hover:text-white sm:right-6 sm:top-6 sm:h-11 sm:w-11"

  new(id)
  |> class(class_)
  |> render([inner])
  |> onclick(Some(onclick_))
  |> view()
}

/// Render back history button.
///
pub fn back(id: String, text: String, onclick_: a) -> UIRender(a) {
  let inner = [
    svg.new(20, 20)
    |> svg_icons.back()
    |> svg.view(),
  ]

  new(id)
  |> class(class_back)
  |> label(text)
  |> render_left(inner)
  |> onclick(Some(onclick_))
  |> view()
}

/// Render sidebar toggle button.
///
pub fn sidebar(id: String, open: Bool, onclick: Option(a)) -> UIRender(a) {
  let button =
    new(id)
    |> class(sidebar_class)
    |> classes([#(sidebar_toggle_class, open)])

  let inner = [
    svg.new(12, 16)
      |> svg_icons.hamburguer_small()
      |> svg.class("hidden lg:block fill-current")
      |> svg.view(),
    svg.new(24, 24)
      |> svg_icons.hamburguer()
      |> svg.classes([#("block lg:hidden", !open), #("hidden", open)])
      |> svg.view(),
    svg.new(24, 24)
      |> svg_icons.cross()
      |> svg.classes([#("block lg:hidden", open), #("hidden", !open)])
      |> svg.view(),
  ]

  button
  |> button.sm()
  |> do_inner(inner, onclick)
  |> view()
}

/// Render plus toggle button.
///
/// - id: Html id
/// - onclick: Event on click
///
pub fn plus(id: String, onclick: Option(a)) -> UIRender(a) {
  let button =
    new(id)
    |> class(plus_class)
  let inner = [
    svg.new(20, 20)
    |> svg_icons.plus()
    |> svg.view(),
  ]

  button
  |> button.sm()
  |> do_inner(inner, onclick)
  |> view()
}

/// Render dark mode toggle button.
///
/// - id: Html id
/// - onclick: Event on click
///
pub fn dark_mode(id: String, onclick: Option(a)) -> UIRender(a) {
  let button =
    new(id)
    |> class(darkmode_class)
  let inner = [
    svg.new(20, 20)
      |> svg_icons.moon()
      |> svg.class("hidden dark:block")
      |> svg.view(),
    svg.new(20, 20)
      |> svg_icons.sun()
      |> svg.class("dark:hidden")
      |> svg.view(),
  ]

  button
  |> button.sm()
  |> do_inner(inner, onclick)
  |> view()
}

/// Render app nav mobile toggle button.
///
pub fn app_nav(id: String, open: Bool, onclick: Option(a)) -> UIRender(a) {
  let button =
    new(id)
    |> class(app_nav_class)
    |> classes([#("bg-gray-100 dark:bg-gray-800", open)])

  let inner = [
    svg.new(24, 24)
    |> svg_icons.app_nav()
    |> svg.view(),
  ]

  button
  |> button.sm()
  |> do_inner(inner, onclick)
  |> view()
}

/// TODO put size here
pub fn loading(id: String) {
  let inner = [
    svg.new(20, 20)
    |> svg.class("animate-spin")
    |> svg_icons.spinner()
    |> svg.view(),
  ]

  new(id)
  |> primary()
  |> class("w-full")
  |> disabled(True)
  |> do_inner(inner, None)
  |> view()
}

// PRIVATE
//

fn do_inner(in: Button, inner: UIRenders(a), onclick: Option(a)) -> Render(a) {
  in
  |> button.render(inner)
  |> button.onclick(onclick)
}

const const_primary_class = "inline-flex items-center gap-2 rounded-lg bg-brand-500 px-5 py-3.5 text-sm font-medium text-white shadow-theme-xs transition hover:bg-brand-600"

const secondary_class = "inline-flex items-center gap-2 rounded-lg bg-white px-5 py-3.5 text-sm font-medium text-gray-700 shadow-theme-xs ring-1 ring-inset ring-gray-300 transition hover:bg-gray-50 dark:bg-gray-800 dark:text-gray-400 dark:ring-gray-700 dark:hover:bg-white/[0.03]"

const const_tertiary_class = "text-theme-sm shadow-theme-xs flex items-center gap-2 rounded-lg border border-gray-300 bg-white px-2 py-2 font-medium text-gray-700 hover:bg-gray-50 hover:text-gray-800 sm:px-3.5 dark:border-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:hover:bg-white/[0.03] dark:hover:text-gray-200"

const darkmode_class = "hover:text-dark-900 relative flex h-11 w-11 items-center justify-center rounded-full border border-gray-200 bg-white text-gray-500 transition-colors hover:bg-gray-100 hover:text-gray-700 dark:border-gray-800 dark:bg-gray-900 dark:text-gray-400 dark:hover:bg-gray-800 dark:hover:text-white"

const plus_class = "hover:text-dark-900 relative flex h-11 w-11 items-center justify-center rounded-full border border-gray-200 bg-white text-gray-500 transition-colors hover:bg-gray-100 hover:text-gray-700 dark:border-gray-800 dark:bg-gray-900 dark:text-gray-400 dark:hover:bg-gray-800 dark:hover:text-white"

const app_nav_class = "z-99999 flex h-10 w-10 items-center justify-center rounded-lg text-gray-700 hover:bg-gray-100 xl:hidden dark:text-gray-400 dark:hover:bg-gray-800"

const sidebar_class = "z-99999 flex h-10 w-10 items-center justify-center rounded-lg border-gray-200 text-gray-500 lg:h-11 lg:w-11 lg:border dark:border-gray-800 dark:text-gray-400"

const class_back = "inline-flex items-center text-sm text-gray-500 transition-colors hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-300"

const sidebar_toggle_class = "lg:bg-transparent dark:lg:bg-transparent bg-gray-100 dark:bg-gray-800"
