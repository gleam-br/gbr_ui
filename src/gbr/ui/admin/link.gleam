////
//// Gleam UI admin link element.
////

import gbr/ui/core/el/link

// Alias
type Link =
  link.UILink

type Render(a) =
  link.UILinkRender(a)

/// Set link primary behavior
///
pub fn primary(in: Link) -> Render(a) {
  link.class(in, class_primary)
  |> link.at()
}

/// Set link primary behavior
///
pub fn signin(in: Link) -> Render(a) {
  link.class(in, class_signin)
  |> link.at()
}

pub fn alert(in: Link) -> Render(a) {
  link.class(in, class_alert)
  |> link.at()
}

const class_alert = "mt-3 inline-block text-sm font-medium text-gray-500"
  <> " underline dark:text-gray-400"

const class_primary = "cursor-pointer text-sm text-brand-500"
  <> " hover:text-brand-600 dark:text-brand-400"

const class_signin = "dark:hover:text-gray-300 cursor-pointer inline-flex"
  <> " items-center justify-center gap-3 py-3 text-sm font-normal text-gray-700"
  <> " transition-colors bg-gray-100 rounded-lg px-7 hover:bg-gray-200"
  <> " hover:text-gray-800 dark:bg-white/5 dark:text-white/90 dark:hover:bg-white/10"
