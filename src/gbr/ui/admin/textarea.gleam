////
//// Admin ui textarea element
////

import gbr/ui/textarea

pub type UITextarea =
  textarea.UITextarea

pub const render = textarea.render

pub const view = textarea.view

pub const value = textarea.value

pub const class = textarea.class

pub const placeholder = textarea.placeholder

pub const on_input = textarea.oninput

pub const on_change = textarea.onchange

pub type Status {
  Success
  Error
  Warn
  Hidden
}

pub fn new(id: String) -> UITextarea {
  textarea.new(id)
  |> textarea.class(
    "dark:bg-dark-900 shadow-theme-xs focus:border-brand-300 focus:ring-brand-500/10 "
    <> "dark:focus:border-brand-800 w-full rounded-lg border border-gray-300 bg-transparent "
    <> "px-4 py-2.5 text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 "
    <> "focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 "
    <> "dark:placeholder:text-white/30",
  )
}

pub fn label(in: UITextarea, label: String) -> UITextarea {
  in
  |> textarea.label(label)
  |> textarea.class_label(
    "mt-2.5 mb-1 block text-sm font-medium text-gray-700 dark:text-gray-400",
  )
}

pub fn status(in: UITextarea, message: String, status: Status) -> UITextarea {
  textarea.message(in, message)
  |> textarea.class_message("text-theme-xs")
  |> textarea.classes_message([
    #("text-success-500", status == Success),
    #("text-orange-500", status == Warn),
    #("text-error-500", status == Error),
    #("hidden", status == Hidden),
  ])
}
