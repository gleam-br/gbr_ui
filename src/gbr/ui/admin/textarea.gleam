////
//// Admin ui textarea element
////

import gbr/ui/textarea

type Textarea =
  textarea.UITextarea

pub type Status {
  Success
  Error
  Warn
  Hidden
}

pub fn new(label: String, text: String) -> Textarea {
  textarea.new(text)
  |> textarea.class(
    "dark:bg-dark-900 shadow-theme-xs focus:border-brand-300 focus:ring-brand-500/10 dark:focus:border-brand-800 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30",
  )
  |> textarea.label(label)
  |> textarea.class_label(
    "mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-400",
  )
}

pub fn status(in: Textarea, message: String, status: Status) -> Textarea {
  textarea.message(in, message)
  |> textarea.class_message("text-theme-xs")
  |> textarea.classes_message([
    #("text-success-500", status == Success),
    #("text-orange-500", status == Warn),
    #("text-error-500", status == Error),
    #("hidden", status == Hidden),
  ])
}
