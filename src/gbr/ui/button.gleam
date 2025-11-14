////
//// ⚉ Gleam UI button super element.
////
//// 🚧 **Work in progress** not production ready.
////
//// ### Roadmap
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

import lustre/attribute as a
import lustre/element.{type Element}
import lustre/element/html

import gbr/ui/core.{
  type UIAttrs, type UILabel, UILabel, attrs_remove, attrs_to_lustre, to_id,
}
import gbr/ui/svg
import gbr/ui/svg/icons as svg_icons

type Label =
  UILabel

type Attrs =
  UIAttrs

type Type {
  /// Typically used for less-pronounced actions, including those located: in dialogs, in cards
  Text
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
    id: String,
    att: Attrs,
    kind: Type,
    size: Size,
    state: State,
    shape: Shape,
    label: Option(Label),
  )
}

/// Button render type.
///
pub type UIButtonRender(a) {
  UIButtonRender(inner: List(Element(a)), onclick: Option(a))
}

/// New button super element.
///
pub fn new(id: String) -> Button {
  UIButton(
    id: to_id(id),
    att: [],
    kind: Text,
    state: Enabled,
    shape: Rect,
    size: Md,
    label: None,
  )
}

/// Set button label.
///
pub fn label(in: Button, label: Label) -> Button {
  UIButton(..in, label: Some(label))
}

/// Set button disabled.
///
pub fn disabled(in: Button, disabled: Bool) -> Button {
  case disabled {
    False ->
      UIButton(..in, state: Enabled, att: attrs_remove(in.att, "disabled"))
    True ->
      UIButton(..in, state: Disabled, att: [#("disabled", "true"), ..in.att])
  }
}

/// Set button disabled.
///
pub fn primary(in: Button) -> Button {
  UIButton(..in, att: [#("class", primary_class), ..in.att])
}

/// New button render at right inner and onclick event.
///
pub fn at_right(in: Button, inner: List(Element(a))) -> Render(a) {
  let UIButton(label:, ..) = in
  let inner = case label {
    Some(UILabel(text:, ..)) -> list.append(inner, [html.text(text)])
    None -> inner
  }

  UIButtonRender(inner:, onclick: None)
}

/// New button render at left inner and onclick event.
///
pub fn at_left(in: Button, inner: List(Element(a))) -> Render(a) {
  let UIButton(label:, ..) = in
  let inner = case label {
    Some(UILabel(text:, ..)) -> [html.text(text), ..inner]
    None -> inner
  }

  UIButtonRender(inner:, onclick: None)
}

/// New button render at default.
///
pub fn at(in: Button) -> Render(a) {
  let UIButton(label:, ..) = in
  let inner = case label {
    Some(UILabel(text:, ..)) -> [html.text(text)]
    None -> []
  }

  UIButtonRender(inner:, onclick: None)
}

/// Set button render onclick event.
///
pub fn at_onclick(in: Render(a), onclick: a) -> Render(a) {
  UIButtonRender(..in, onclick: Some(onclick))
}

/// Render button super element to `lustre/element.{type Element}`.
///
pub fn render(in: Button, render: Render(a)) -> Element(a) {
  let UIButton(id:, att:, ..) = in
  let UIButtonRender(inner:, ..) = render
  let attrs = [a.id(id), ..attrs_to_lustre(att)]

  html.button(attrs, inner)
}

/// Render app nav mobile button.
///
pub fn app_nav(id: String, onclick: a) -> Element(a) {
  let button = UIButton(..new(id), att: [#("class", app_nav_class)])
  let inner = [
    svg.new("btn-icon-app-nav", 24, 24)
    |> svg_icons.app_nav()
    |> svg.render(),
  ]

  render(button, do_inner(inner, onclick))
}

/// Render sidebar toggle button.
///
pub fn sidebar(id: String, visible: Bool, onclick: a) -> Element(a) {
  let cross_toggle = case visible {
    True -> "block lg:hidden"
    False -> "hidden"
  }
  let default_toggle = case visible {
    True -> "hidden"
    False -> "block lg:hidden"
  }
  let class_toggle = case visible {
    True ->
      " lg:bg-transparent dark:lg:bg-transparent bg-gray-100 dark:bg-gray-800"
    False -> ""
  }
  let button =
    UIButton(..new(id), att: [#("class", sidebar_class <> class_toggle)])
  let inner = [
    svg.new("btn-icon-sidebar-hamburguer-small", 12, 16)
      |> svg_icons.hamburguer_small()
      |> svg.classes(["hidden lg:block"])
      |> svg.render(),
    svg.new("btn-icon-sidebar-hamburguer", 20, 20)
      |> svg_icons.hamburguer()
      |> svg.classes([default_toggle])
      |> svg.render(),
    svg.new("btn-icon-sidebar-cross", 24, 24)
      |> svg_icons.cross()
      |> svg.classes([cross_toggle])
      |> svg.render(),
  ]

  render(button, do_inner(inner, onclick))
}

/// Render dark mode button.
///
pub fn dark_mode(id: String, onclick: a) -> Element(a) {
  let button = UIButton(..new(id), att: [#("class", darkmode_class)])
  let inner = [
    svg.new("btn-icon-dark-mode-moon", 20, 20)
      |> svg_icons.moon()
      |> svg.classes(["hidden dark:block"])
      |> svg.render(),
    svg.new("btn-icon-dark-mode-sun", 20, 20)
      |> svg_icons.sun()
      |> svg.classes(["dark:hidden"])
      |> svg.render(),
  ]

  render(button, do_inner(inner, onclick))
}

// PRIVATE
//

fn do_inner(inner: List(Element(a)), onclick: a) -> Render(a) {
  UIButtonRender(inner:, onclick: Some(onclick))
}

const primary_class = "inline-flex items-center justify-center w-full gap-2 px-4 py-3 text-sm font-medium text-white transition rounded-lg bg-brand-500 shadow-theme-xs hover:bg-brand-600 disabled:bg-gray-400 disabled:cursor-not-allowed"

const darkmode_class = "hover:text-dark-900 relative flex h-11 w-11 items-center justify-center rounded-full border border-gray-200 bg-white text-gray-500 transition-colors hover:bg-gray-100 hover:text-gray-700 dark:border-gray-800 dark:bg-gray-900 dark:text-gray-400 dark:hover:bg-gray-800 dark:hover:text-white"

const app_nav_class = "z-99999 flex h-10 w-10 items-center justify-center rounded-lg text-gray-700 hover:bg-gray-100 xl:hidden dark:text-gray-400 dark:hover:bg-gray-800"

const sidebar_class = "z-99999 flex h-10 w-10 items-center justify-center rounded-lg border-gray-200 text-gray-500 lg:h-11 lg:w-11 lg:border dark:border-gray-800 dark:text-gray-400"
