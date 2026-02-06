////
//// Gleam UI admin input element
////

import gleam/string

import lustre/attribute as a

import gbr/ui/input
import gbr/ui/svg
import gbr/ui/svg/form
import gbr/ui/typo

import gbr/ui/core/model.{type UIRenders}

// Alias
//

pub const new = input.new

pub const text = input.text

pub const email = input.email

pub const checkbox = input.checkbox

pub const value = input.value

pub const name = input.name

pub const autocomplete = input.autocomplete

pub const placeholder = input.placeholder

pub const label = input.label

pub const label_class = input.label_class

pub const note = input.note

pub const class = input.class

pub const classes = input.classes

pub const inner_svg = input.inner_svg

pub const inner_class = input.inner_class

pub const inner_onclick = input.inner_onclick

pub const render = input.render

pub const view = input.view

pub type UIInput =
  input.UIInput

pub type UIInputRender(a) =
  input.UIInputRender(a)

type Input =
  UIInput

type Render(a) =
  UIInputRender(a)

/// Set input primary style behavior.
///
pub fn primary(in: Input) -> Input {
  in
  |> input.disabled(False)
  |> class(
    "dark:bg-dark-900 shadow-theme-xs focus:border-brand-300 "
    <> "focus:ring-brand-500/10 dark:focus:border-brand-800 h-10 w-full "
    <> "rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm "
    <> "text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden "
    <> "dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30",
  )
  |> label_class(
    "mt-2.5 mb-1 block text-sm font-medium text-gray-700 dark:text-gray-400",
  )
}

/// Set password input behavior with icon eye
///
/// Set eye icon open/close to visible input content.
///
/// - This only put icon and control about what icon show open/close also
/// - This control input.type attribute if open show "text" else "password".
///
pub fn password(in: Input, open: Bool) -> Input {
  let type_ = case open {
    True -> "text"
    False -> "password"
  }

  in
  |> input.kind(type_)
  |> input.disabled(False)
  |> class(
    "dark:bg-dark-900 shadow-theme-xs focus:border-brand-300 "
    <> "focus:ring-brand-500/10 dark:focus:border-brand-800 "
    <> "h-10 w-full rounded-lg border border-gray-300 bg-transparent "
    <> "py-2.5 pl-4 pr-11 text-sm text-gray-800 placeholder:text-gray-400 "
    <> "focus:ring-3 focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 "
    <> "dark:text-white/90 dark:placeholder:text-white/30",
  )
  |> label_class(
    "mt-2.5 mb-1 block text-sm font-medium text-gray-700 dark:text-gray-400",
  )
  |> inner_svg(eye(open))
}

pub fn success(in: Input, text: String) -> Input {
  state_set(in, text, state_success_class, state_success_label, form.success)
}

pub fn alert(in: Input, text: String) -> Input {
  state_set(in, text, state_alert_class, state_alert_label, form.success)
}

pub fn error(in: Input, text: String) -> Input {
  state_set(in, text, state_error_class, state_error_label, form.error)
}

pub fn disabled(in: Input, text: String) -> Input {
  in
  |> input.disabled(True)
  |> state_set(text, state_disabled_class, state_disabled_label, form.info)
}

pub fn loading(in: Input, text: String) -> Input {
  //todo: dev spinner
  disabled(in, text)
}

pub fn render_right(in: Input, inner: UIRenders(a)) -> Render(a) {
  input.render(in, [a.class(class_right)], inner)
}

pub fn render_left(in: Input, inner: UIRenders(a)) {
  input.render(in, [a.class(class_left)], inner)
}

//PRIVATE
//

fn state_set(in, text, class, class_note, svg_transform) -> Input {
  let input_class = string.join([state_class, class], " ")
  let note_class = string.join([state_label_class, class_note], " ")
  let note =
    typo.span(text)
    |> typo.class(note_class)

  in
  |> input.inner_svg(
    svg.new(16, 16)
    |> svg_transform(),
  )
  |> input.inner_class(state_icon_class)
  |> input.class(input_class)
  |> input.note(note)
}

const state_label_class = "text-theme-xs text-error-500 mt-1.5"

const state_icon_class = "absolute top-1/2 right-3.5:-translate-y-1/2"

const state_class = "dark:bg-dark-900 shadow-theme-xs w-full rounded-lg border bg-transparent px-4 py-2.5 pr-10 text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30"

const state_success_class = " border-green-300 focus:border-green-300 focus:ring-green-500/10 dark:border-green-700 dark:focus:border-green-800"

const state_alert_class = " border-yellow-300 focus:border-yellow-300 focus:ring-yellow-500/10 dark:border-yellow-700 dark:focus:border-yellow-800"

const state_error_class = " border-red-300 focus:border-red-300 focus:ring-red-500/10 dark:border-red-700 dark:focus:border-red-800"

const state_success_label = "text-xs text-green-600 mt-1.5"

const state_alert_label = "text-xs text-yellow-600 mt-1.5"

const state_error_label = "text-xs text-red-700 mt-1.5"

const state_disabled_class = "disabled:border-gray-100 dark:disabled:border-gray-600 "
  <> "dark:disabled:bg-gray-800 dark:disabled:bg-gray-500 "
  <> "disabled:text-gray-500 dark:disabled:text-white/40"

const state_disabled_label = "mb-1.5 block text-sm font-medium text-gray-300 dark:text-white/15"

const class_right = "absolute z-30 text-gray-500 -translate-y-1/2 cursor-pointer right-4 top-1/2 dark:text-gray-400 inline-flex gap-1"

const class_left = "absolute top-1/2 left-0 flex h-11 -translate-y-1/2 items-center justify-center border-r border-gray-200 dark:border-gray-800 inline-flex gap-1 px-3"

fn eye(open) {
  let transform = case open {
    True -> form.eye_open
    False -> form.eye_close
  }

  svg.new(20, 20)
  |> transform()
}
