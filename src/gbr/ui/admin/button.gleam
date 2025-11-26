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
////       |> svg.render()
////     ]
////   ]
////   button.new(id)
////     |> button.label(label)
////     |> button.at_left(inner)
////     |> button.on_click(onclick)
////     |> button.render()
//// }
////```
////
//// ### Roadmap
////
//// 🚧 **Work in progress**
////
//// - [ ] type behavior
//// - [ ] size behavior
//// - [ ] icon behavior
////   - [ ] direction top, down, left and right
////   - [ ] badge styled
//// - [ ] state behavior
//// - [ ] shape behavior
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

type Type {
  /// Typically used for less-pronounced actions, including those located: in dialogs, in cards
  Default
  // /// High-emphasis, distinguished by their use of elevation and fill. Actions that are primary.
  // Contained
  // /// Encourages a user to perform a specific action, such as "Shop Now", "Sign Up".
  // Cta
  // /// Appears in front of all screen content, typically as a circular shape with an icon in its center.
  // Fab
  // /// Lower-emphasis buttons that are not important but are important funcionality, like FAB but layout rect.
  // Ghost
  // /// Medium-emphasis buttons that are important but aren't the primary action.
  // Outlined
  // /// Group related options, a group should share a common container, e.g. switch button.
  // Toggle
  // /// Signify actions and seek to give depth to a mostly flat page
  // Raised
  // /// Should be used for important, final actions that complete a flow.
  // Filled
  // /// Reveals a list of options when clicked, allowing a user to select one.
  // Dropdown
  // /// Attract user attention, initial actions that is required.
  // Expendable
}

type Size {
  // Xs
  // Sm
  Md
  // Lg
  // Xl
}

type Shape {
  Rect
  // Cirlce
  // Rounded
}

type State {
  /// Enabled to action
  Enabled
  /// Disabled to action
  Disabled
  // /// On focus
  // Focus
  // /// On hover
  // Hover
  // /// On pressed
  // Active
}

type Button =
  UIButton

type Render(a) =
  UIButtonRender(a)

/// Button super element.
///
pub opaque type UIButton {
  UIButton(
    el: El,
    kind: Type,
    size: Size,
    state: State,
    shape: Shape,
    text: Option(String),
  )
}

/// Button render type.
///
pub type UIButtonRender(a) {
  UIButtonRender(in: Button, inner: UIRenders(a), onclick: Option(a))
}

/// New button super element.
///
pub fn new(id: String) -> Button {
  UIButton(
    el: el.new(id),
    kind: Default,
    state: Enabled,
    shape: Rect,
    size: Md,
    text: None,
  )
}

/// Set button label.
///
pub fn label(in: Button, text: String) -> Button {
  UIButton(..in, text: Some(text))
}

/// Set button disabled.
///
pub fn disabled(in: Button, disabled: Bool) -> Button {
  case disabled {
    False -> UIButton(..in, state: Enabled)
    True -> UIButton(..in, state: Disabled)
  }
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

/// Set button disabled.
///
pub fn primary(in: Button) -> Button {
  class(in, primary_class)
}

/// New button render at right inner and onclick event.
///
pub fn at_right(in: Button, inner: UIRenders(a)) -> Render(a) {
  let UIButton(text:, ..) = in

  let inner = case text {
    Some(text) -> list.append(inner, [html.text(text)])
    None -> inner
  }

  UIButtonRender(in:, inner:, onclick: None)
}

/// New button render at left inner and onclick event.
///
pub fn at_left(in: Button, inner: UIRenders(a)) -> Render(a) {
  let UIButton(text:, ..) = in
  let inner = case text {
    Some(text) -> [html.text(text), ..inner]
    None -> inner
  }

  UIButtonRender(in:, inner:, onclick: None)
}

/// New button render at default.
///
pub fn at(in: Button) -> Render(a) {
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
pub fn render(at: Render(a)) -> UIRender(a) {
  let UIButtonRender(in:, inner:, onclick:) = at
  let UIButton(el:, ..) = in

  let onclick =
    option.map(onclick, event.on_click)
    |> option.unwrap(attribute.none())

  let attrs = [onclick, ..el.attrs(el)]

  html.button(attrs, inner)
}

/// Render back history button.
///
pub fn back(id: String, text: String, onclick: a) -> UIRender(a) {
  let inner = [
    svg.new(20, 20)
    |> svg_icons.back()
    |> svg.render(),
  ]

  new(id)
  |> class(class_back)
  |> label(text)
  |> at_left(inner)
  |> on_click(onclick)
  |> render()
}

/// Render sidebar toggle button.
///
pub fn sidebar(id: String, open: Bool, onclick: Option(a)) -> UIRender(a) {
  let button =
    new(id)
    |> class(sidebar_class)
    |> classes([#(toggle_class, open)])

  let inner = [
    svg.new(12, 16)
      |> svg_icons.hamburguer_small()
      |> svg.class("hidden lg:block fill-current")
      |> svg.render(),
    svg.new(24, 24)
      |> svg_icons.hamburguer()
      |> svg.classes([#("block lg:hidden", !open), #("hidden", open)])
      |> svg.render(),
    svg.new(24, 24)
      |> svg_icons.cross()
      |> svg.classes([#("block lg:hidden", open), #("hidden", !open)])
      |> svg.render(),
  ]

  do_inner(button, inner, onclick)
  |> render()
}

/// Render dark mode toggle button.
///
pub fn dark_mode(id: String, onclick: Option(a)) -> UIRender(a) {
  let button =
    new(id)
    |> class(darkmode_class)
  let inner = [
    svg.new(20, 20)
      |> svg_icons.moon()
      |> svg.class("hidden dark:block")
      |> svg.render(),
    svg.new(20, 20)
      |> svg_icons.sun()
      |> svg.class("dark:hidden")
      |> svg.render(),
  ]

  button
  |> do_inner(inner, onclick)
  |> render()
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
    |> svg.render(),
  ]

  button
  |> do_inner(inner, onclick)
  |> render()
}

// PRIVATE
//

fn do_inner(in: Button, inner: UIRenders(a), onclick: Option(a)) -> Render(a) {
  UIButtonRender(in:, inner:, onclick:)
}

const primary_class = "inline-flex items-center justify-center w-full gap-2 px-4 py-3 text-sm font-medium text-white transition rounded-lg bg-brand-500 shadow-theme-xs hover:bg-brand-600 disabled:bg-gray-400 disabled:cursor-not-allowed"

const darkmode_class = "hover:text-dark-900 relative flex h-11 w-11 items-center justify-center rounded-full border border-gray-200 bg-white text-gray-500 transition-colors hover:bg-gray-100 hover:text-gray-700 dark:border-gray-800 dark:bg-gray-900 dark:text-gray-400 dark:hover:bg-gray-800 dark:hover:text-white"

const app_nav_class = "z-99999 flex h-10 w-10 items-center justify-center rounded-lg text-gray-700 hover:bg-gray-100 xl:hidden dark:text-gray-400 dark:hover:bg-gray-800"

const sidebar_class = "z-99999 flex h-10 w-10 items-center justify-center rounded-lg border-gray-200 text-gray-500 lg:h-11 lg:w-11 lg:border dark:border-gray-800 dark:text-gray-400"

const class_back = "inline-flex items-center text-sm text-gray-500 transition-colors hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-300"

const toggle_class = "lg:bg-transparent dark:lg:bg-transparent bg-gray-100 dark:bg-gray-800"
