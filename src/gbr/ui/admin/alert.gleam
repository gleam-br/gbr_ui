////
//// Gleam UI admin alert element
////

import gleam/option.{type Option}

import gbr/ui/alert
import gbr/ui/core/el/link

type Alert =
  alert.UIAlert

type Render(a) =
  alert.UIAlertRender(a)

type Link(a) =
  Option(link.UILinkRender(a))

pub fn primary(in: Alert, link: Link(a)) -> Render(a) {
  let link = option.map(link, link.at_class(_, class_link))

  alert.class(in, class_main)
  |> alert.class_title(class_title)
  |> alert.class_desc(class_desc)
  |> alert.class_icon(class_icon)
  |> alert.class_content(class_content)
  |> alert.class_status_info(class_main_info, class_icon_info)
  |> alert.class_status_success(class_main_success, class_icon_success)
  |> alert.class_status_warn(class_main_warning, class_icon_warning)
  |> alert.class_status_error(class_main_error, class_icon_error)
  |> alert.at()
  // |> alert.link(link)
}

const class_icon = "-mt-0.5"

const class_content = "flex items-start gap-3"

const class_icon_info = "text-blue-light-500"

const class_icon_success = "text-success-500"

const class_icon_warning = "text-warning-500"

const class_icon_error = "text-error-500"

const class_main = "fixed top-10 right-10 z-999999 rounded-xl border p-4"
  <> " animate-bounce"

const class_title = "mb-1 text-sm font-semibold text-gray-800"
  <> " dark:text-white/90"

const class_desc = "text-sm text-gray-500 dark:text-gray-400"

const class_link = "mt-3 inline-block text-sm font-medium text-gray-500"
  <> " underline dark:text-gray-400"

const class_main_info = "border-blue-light-500 dark:border-blue-light-500/30"
  <> " bg-blue-light-50 dark:bg-blue-light-500/15"

const class_main_success = "border-success-500 dark:border-success-500/30"
  <> " bg-success-50 dark:bg-success-500/15"

const class_main_warning = "border-warning-500 dark:border-warning-500/30"
  <> " bg-warning-50 dark:bg-warning-500/15"

const class_main_error = "border-error-500 bg-error-50 dark:border-error-500/30"
  <> " dark:bg-error-500/15"
