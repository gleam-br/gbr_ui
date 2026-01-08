////
//// ⚉ Gleam UI button super element.
////
//// Supose button text and svg at left side:
////
////```gleam
//// import gbr/ui/button
////
//// import gbr/ui/svg
//// import gbr/ui/svg/icons
////
//// import gbr/ui/core/model.{type UIRender, uilabel}
////
//// fn render(id: String) -> UIRender(a) {
////   label = uilabel("Button w/ icon back!", [])
////   let inner = [
////     svg.new("id-svg", 20, 20)
////       |> icons.back()
////       |> svg.view()
////     ]
////   ]
////   button.new(id)
////     |> button.label(label)
////     |> button.render_left(inner)
////     |> button.on_click(onclick)
////     |> button.view()
//// }
////```
////
//// ### Roadmap
////
//// 🚧 **Work in progress**
////
//// - [ ] group behavior
//// - [ ] loading behavior
//// - [ ] contrast accessibilty 4:5:1
////

import gleam/list
import gleam/option.{type Option, None, Some}

import lustre/attribute
import lustre/element/html
import lustre/event

import gbr/ui/svg
import gbr/ui/svg/icons as svg_icons

import gbr/ui/core/el
import gbr/ui/core/model.{type UIRender, type UIRenders, type UISwitches}

type El =
  el.UIEl

type Size {
  Sm
  Md
  Lg
}

type Button =
  UIButton

type Render(a) =
  UIButtonRender(a)

/// Button super element.
///
pub opaque type UIButton {
  UIButton(el: El, size: Size, disabled: Bool, text: Option(String))
}

/// Button render type.
///
pub type UIButtonRender(a) {
  UIButtonRender(in: Button, inner: UIRenders(a), onclick: Option(a))
}

/// New button super element.
///
pub fn new(id: String) -> Button {
  UIButton(el: el.new(id), size: Md, disabled: False, text: None)
}

/// Set button label.
///
pub fn label(in: Button, text: String) -> Button {
  UIButton(..in, text: Some(text))
}

/// Set html type attribute
///
pub fn kind(in: Button, kind: String) -> Button {
  let el = el.att(in.el, [#("type", kind)])

  UIButton(..in, el:)
}

/// Set button disabled.
///
pub fn disabled(in: Button, disabled: Bool) -> Button {
  UIButton(..in, disabled:)
}

/// Set button class.
///
pub fn class(in: Button, class: String) -> Button {
  let el = el.class(in.el, class)

  UIButton(..in, el:)
}

/// Set button classes.
///
pub fn classes(in: Button, classes: UISwitches) -> Button {
  let el = el.classes(in.el, classes)

  UIButton(..in, el:)
}

/// Set button size to medium
///
pub fn md(in: Button) -> Button {
  UIButton(..in, size: Md)
}

/// Set button size to large
///
pub fn lg(in: Button) -> Button {
  UIButton(..in, size: Lg)
}

/// Set button primary behavior.
///
pub fn primary(in: Button) -> Button {
  class(in, primary_class)
}

/// Set button secondary behavior.
///
pub fn secondary(in: Button) -> Button {
  class(in, secondary_class)
}

/// New button render at right inner and onclick event.
///
pub fn render_left(in: Button, inner: UIRenders(a)) -> Render(a) {
  let UIButton(text:, ..) = in

  let inner = case text {
    Some(text) -> list.append(inner, [html.text(text)])
    None -> inner
  }

  UIButtonRender(in:, inner:, onclick: None)
}

/// New button render at left inner and onclick event.
///
pub fn render_right(in: Button, inner: UIRenders(a)) -> Render(a) {
  let UIButton(text:, ..) = in
  let inner = case text {
    Some(text) -> [html.text(text), ..inner]
    None -> inner
  }

  UIButtonRender(in:, inner:, onclick: None)
}

/// New button render at default.
///
pub fn render(in: Button) -> Render(a) {
  let UIButton(text:, ..) = in
  let inner = case text {
    Some(text) -> [html.text(text)]
    None -> []
  }

  UIButtonRender(in:, inner:, onclick: None)
}

/// Set button render onclick event.
///
pub fn on_click_opt(in: Render(a), onclick: Option(a)) -> Render(a) {
  UIButtonRender(..in, onclick:)
}

pub fn on_click(in: Render(a), onclick: a) -> Render(a) {
  on_click_opt(in, Some(onclick))
}

/// Render button super element to `lustre/element.{type Element}`.
///
pub fn view(at: Render(a)) -> UIRender(a) {
  let UIButtonRender(in:, inner:, onclick:) = at
  let UIButton(el:, disabled:, size:, ..) = in

  let onclick =
    option.map(onclick, event.on_click)
    |> option.unwrap(attribute.none())

  let attrs =
    el.classes(el, [
      #("px-4 py-3", size == Md),
      #("px-5 py-3.5", size == Lg),
      #("px-0 py-0", size == Sm),
    ])
    |> el.attrs()
  let attrs = [onclick, attribute.disabled(disabled), ..attrs]

  html.button(attrs, inner)
}

/// Render back history button.
///
pub fn back(id: String, text: String, onclick: a) -> UIRender(a) {
  let inner = [
    svg.new(20, 20)
    |> svg_icons.back()
    |> svg.view(),
  ]

  new(id)
  |> class(class_back)
  |> label(text)
  |> render_left(inner)
  |> on_click(onclick)
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

  UIButton(..button, size: Sm)
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

  UIButton(..button, size: Sm)
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

  UIButton(..button, size: Sm)
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
  UIButtonRender(in:, inner:, onclick:)
}

const primary_class = "w-full inline-flex items-center justify-center gap-2 text-sm font-medium text-white transition rounded-lg bg-brand-500 shadow-theme-xs hover:bg-brand-600 active:bg-brand-500 disabled:cursor-not-allowed"

const secondary_class = "w-full inline-flex items-center gap-2 rounded-lg bg-white text-sm font-medium text-gray-700 shadow-theme-xs ring-1 ring-inset ring-gray-300 transition active:bg-white dark:active:bg-gray-800 hover:bg-gray-50 dark:bg-gray-800 dark:text-gray-400 dark:ring-gray-700 dark:hover:bg-white/[0.03] disabled:cursor-not-allowed"

const darkmode_class = "hover:text-dark-900 relative flex h-11 w-11 items-center justify-center rounded-full border border-gray-200 bg-white text-gray-500 transition-colors hover:bg-gray-100 hover:text-gray-700 dark:border-gray-800 dark:bg-gray-900 dark:text-gray-400 dark:hover:bg-gray-800 dark:hover:text-white"

const app_nav_class = "z-99999 flex h-10 w-10 items-center justify-center rounded-lg text-gray-700 hover:bg-gray-100 xl:hidden dark:text-gray-400 dark:hover:bg-gray-800"

const sidebar_class = "z-99999 flex h-10 w-10 items-center justify-center rounded-lg border-gray-200 text-gray-500 lg:h-11 lg:w-11 lg:border dark:border-gray-800 dark:text-gray-400"

const class_back = "inline-flex items-center text-sm text-gray-500 transition-colors hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-300"

const sidebar_toggle_class = "lg:bg-transparent dark:lg:bg-transparent bg-gray-100 dark:bg-gray-800"
