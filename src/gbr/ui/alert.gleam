////
//// Gleam UI super alert elements.
////

import gleam/bool
import gleam/option

import lustre/attribute as a
import lustre/element/html

import gbr/ui/core.{
  type UIDesc, type UILink, type UIRender, UIDesc, UILink, to_id,
}
import gbr/ui/svg
import gbr/ui/svg/alert as svg_alert

type Alert =
  UIAlert

type Status {
  Success
  Warning
  Error
  Info
}

type Link =
  option.Option(UILink)

/// UI super alert element.
///
pub opaque type UIAlert {
  UIAlert(id: String, info: UIDesc, status: Status, visible: Bool, link: Link)
}

/// New alert super element pass title and description.
///
pub fn new(id: String, title: String, desc: String) -> Alert {
  UIAlert(
    id: to_id(id),
    info: UIDesc(title:, desc:),
    status: Info,
    visible: False,
    link: option.None,
  )
}

/// Set visible to alert element.
///
pub fn visible(in: Alert, visible: Bool) -> Alert {
  UIAlert(..in, visible:)
}

/// Set info behavior to alert element.
///
pub fn info(in: Alert) -> Alert {
  UIAlert(..in, status: Info)
}

/// Set success behavior to alert element.
///
pub fn success(in: Alert) -> Alert {
  UIAlert(..in, status: Success)
}

/// Set warning behavior to alert element.
///
pub fn warning(in: Alert) -> Alert {
  UIAlert(..in, status: Warning)
}

/// Set error behavior to alert element.
///
pub fn error(in: Alert) -> Alert {
  UIAlert(..in, status: Error)
}

/// Set link behavior to alert element.
///
pub fn link(in: Alert, href: String, title: String) -> Alert {
  let link = UILink(href:, title:)

  UIAlert(..in, link: option.Some(link))
}

/// Render super alert element to `lustre/element/html.{div}`.
///
pub fn render(in: Alert) -> UIRender(a) {
  let UIAlert(id:, info:, status:, link:, visible:) = in

  use <- bool.guard(!visible, html.text(""))

  let status = case status {
    Info -> #(
      classes_main_info,
      classes_icon_info,
      svg.new("el-alert-info", 24, 24) |> svg_alert.info(),
    )
    Success -> #(
      classes_main_success,
      classes_icon_success,
      svg.new("el-alert-success", 24, 24) |> svg_alert.success(),
    )
    Warning -> #(
      classes_main_warning,
      classes_icon_warning,
      svg.new("el-alert-warn", 24, 24) |> svg_alert.warning(),
    )
    Error -> #(
      classes_main_error,
      classes_icon_error,
      svg.new("el-alert-error", 24, 24) |> svg_alert.error(),
    )
  }

  let main_class = classes_main <> " " <> status.0
  let icon_class = classes_icon <> " " <> status.1

  html.div([a.id(id), a.class(main_class)], [
    html.div([a.class(classes_content)], [
      html.div([a.class(icon_class)], [
        status.2 |> svg.render(),
      ]),
      html.div([], [
        html.h4([a.class(classes_title)], [html.text(info.title)]),
        html.p([a.class(classes_desc)], [html.text(info.desc)]),

        case link {
          option.Some(link) ->
            html.a([a.href(link.href), a.class(classes_link)], [
              html.text(link.title),
            ])
          option.None -> html.text("")
        },
      ]),
    ]),
  ])
}

// PRIVATES
//

const classes_main = "fixed top-10 right-10 z-999999 rounded-xl border p-4 animate-bounce"

const classes_content = "flex items-start gap-3"

const classes_icon = "-mt-0.5"

const classes_title = "mb-1 text-sm font-semibold text-gray-800 dark:text-white/90"

const classes_desc = "text-sm text-gray-500 dark:text-gray-400"

const classes_link = "mt-3 inline-block text-sm font-medium text-gray-500 underline dark:text-gray-400"

const classes_main_info = "border-blue-light-500 bg-blue-light-50 dark:border-blue-light-500/30 dark:bg-blue-light-500/15"

const classes_main_success = "border-success-500 bg-success-50 dark:border-success-500/30 dark:bg-success-500/15"

const classes_main_warning = "border-warning-500 bg-warning-50 dark:border-warning-500/30 dark:bg-warning-500/15"

const classes_main_error = "border-error-500 bg-error-50 dark:border-error-500/30 dark:bg-error-500/15"

const classes_icon_info = "text-blue-light-500"

const classes_icon_success = "text-success-500"

const classes_icon_warning = "text-warning-500"

const classes_icon_error = "text-error-500"
