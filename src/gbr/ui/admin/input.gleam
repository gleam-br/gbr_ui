////
//// Gleam UI admin input element
////

import gleam/option.{type Option}

import lustre/attribute as a
import lustre/element/html

import gbr/ui/input
import gbr/ui/svg
import gbr/ui/svg/form
import gbr/ui/typo

import gbr/ui/core/model.{type UIRenders}

type Input =
  input.UIInput

type Render(a) =
  input.UIInputRender(a)

pub fn primary(in: Input, label: Option(String)) -> Render(a) {
  let in = set_label(in, label)

  input.class(
    in,
    "dark:bg-dark-900 shadow-theme-xs focus:border-brand-300 "
      <> "focus:ring-brand-500/10 dark:focus:border-brand-800 h-11 w-full "
      <> "rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm "
      <> "text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden "
      <> "dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30",
  )
  |> input.at([], [])
}

pub fn password(in: Input, visible: Bool, label: Option(String)) -> Render(a) {
  in
  |> set_label(label)
  |> input.class(
    "dark:bg-dark-900 shadow-theme-xs focus:border-brand-300 "
    <> "focus:ring-brand-500/10 dark:focus:border-brand-800 "
    <> "h-11 w-full rounded-lg border border-gray-300 bg-transparent "
    <> "py-2.5 pr-11 pl-4 text-sm text-gray-800 placeholder:text-gray-400 "
    <> "focus:ring-3 focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 "
    <> "dark:text-white/90 dark:placeholder:text-white/30",
  )
  |> at_right([eye(!visible)])
}

pub fn success(in: Input, text: String) -> Render(a) {
  state_set(in, text, state_success_class, state_success_label, form.success)
}

pub fn alert(in: Input, text: String) -> Render(a) {
  state_set(in, text, state_alert_class, state_alert_label, form.success)
}

pub fn error(in: Input, text: String) -> Render(a) {
  state_set(in, text, state_error_class, state_error_label, form.error)
}

pub fn disabled(in: Input, text: String) -> Render(a) {
  state_set(in, text, disabled_class, label_disabled_class, form.info)
}

pub fn loading(in: Input, text: String) -> Render(a) {
  //todo: dev spinner
  disabled(in, text)
}

pub fn at_right(in: Input, inner: UIRenders(a)) -> Render(a) {
  input.at(in, [a.class(class_right)], inner)
}

pub fn at_left(in: Input, inner: UIRenders(a)) {
  input.at(in, [a.class(class_left)], inner)
}

//PRIVATE
//

fn state_set(in, text, class, class_note, svg) -> Render(a) {
  let svg =
    svg.new(16, 16)
    |> svg()
    |> svg.render()

  let input_class = state_class <> " " <> class
  let note_class = state_label_class <> " " <> class_note
  let note =
    typo.span(text)
    |> typo.class(note_class)

  input.class(in, input_class)
  |> input.note(note)
  |> input.at([a.class(state_icon_class)], [svg])
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

const disabled_class = "shadow-theme-xs focus:border-brand-300 focus:shadow-focus-ring dark:focus:border-brand-300 h-11 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 placeholder:text-gray-400 focus:outline-hidden disabled:border-gray-100 disabled:placeholder:text-gray-300 dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-gray-400 dark:disabled:border-gray-800 dark:disabled:placeholder:text-white/15"

const label_disabled_class = "mb-1.5 block text-sm font-medium text-gray-300 dark:text-white/15"

const class_right = "absolute z-30 text-gray-500 -translate-y-1/2 cursor-pointer right-4 top-1/2 dark:text-gray-400 inline-flex gap-1"

const class_left = "absolute top-1/2 left-0 flex h-11 -translate-y-1/2 items-center justify-center border-r border-gray-200 dark:border-gray-800 inline-flex gap-1 px-3"

fn eye(open: Bool) {
  let transform = case open {
    True -> form.eye_open
    False -> form.eye_close
  }

  svg.new(20, 20)
  |> transform()
  |> svg.render()
}

fn set_label(in: Input, label: Option(String)) -> Input {
  label
  |> option.map(input.label(in, _))
  |> option.map(input.label_class(
    _,
    "mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-400",
  ))
  |> option.unwrap(in)
}
