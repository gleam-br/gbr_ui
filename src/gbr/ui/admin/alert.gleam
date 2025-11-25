////
//// Gleam UI admin alert element
////

import gleam/bool

import lustre/attribute as a
import lustre/element
import lustre/element/html

import gbr/ui/core/el
import gbr/ui/core/model.{type UIRender, type UIRenders}
import gbr/ui/desc

import gbr/ui/svg
import gbr/ui/svg/alert as svg_alert

type Alert =
  UIAlert

type Render(a) =
  UIAlertRender(a)

type El =
  el.UIEl

type Desc =
  desc.UIDesc

type Status {
  Success
  Warning
  Error
  Info
}

/// UI super alert element.
///
/// - el: Element info
/// - info: Alert description info
/// - status: Alert status "info", "error"...
/// - open: If alert is open or not.
///
pub opaque type UIAlert {
  UIAlert(el: El, info: Desc, status: Status, open: Bool)
}

/// Alert render element
///
/// in: Alert info
///
pub opaque type UIAlertRender(a) {
  UIAlertRender(in: Alert, inner: UIRenders(a))
}

/// New alert super element pass title and description.
///
/// - title: Alert title
/// - desc: Alert description
///
pub fn new(title: String, desc: String) -> Alert {
  let el = create_el()

  let info =
    desc.new(title, desc)
    |> desc.class_content("text-sm text-gray-500 dark:text-gray-400")
    |> desc.class_title(
      "mb-1 text-sm font-semibold text-gray-800 dark:text-white/90",
    )

  UIAlert(el:, info:, status: Info, open: False)
}

/// Replace alert title
///
pub fn title(in: Alert, title: String) -> Alert {
  let info = desc.title(in.info, title)

  UIAlert(..in, info:)
}

/// Replace alert content description
///
pub fn content(in: Alert, content: String) -> Alert {
  let info = desc.content(in.info, content)

  UIAlert(..in, info:)
}

/// Set open alert element.
///
pub fn open(in: Alert, open: Bool) -> Alert {
  UIAlert(..in, open:)
}

/// Set info behavior to alert
///
pub fn info(in: Alert) -> Alert {
  UIAlert(..in, status: Info)
}

/// Set success behavior to alert
///
pub fn success(in: Alert) -> Alert {
  UIAlert(..in, status: Success)
}

/// Set warning behavior to alert
///
pub fn warning(in: Alert) -> Alert {
  UIAlert(..in, status: Warning)
}

/// Set error behavior to alert
///
pub fn error(in: Alert) -> Alert {
  UIAlert(..in, status: Error)
}

/// New alert render element.
///
/// - in: Alert info
///
pub fn at(in: Alert, inner: UIRenders(a)) -> Render(a) {
  UIAlertRender(in:, inner:)
}

/// Set attribute el.classes by status
///
/// Render super alert element to `lustre/element/html.{div}`.
///
pub fn render(at: Render(a)) -> UIRender(a) {
  let UIAlertRender(in:, inner:) = at
  let UIAlert(el:, info:, status:, open:) = in

  use <- bool.guard(!open, element.none())

  let attrs =
    classes_el(el, status)
    |> el.attrs()

  html.div(attrs, [
    html.div([a.class("flex items-start gap-3")], [
      html.div([a.class("-mt-0.5"), classes_icon(status)], [
        svg.new(24, 24)
        |> svg_status(status)
        |> svg.render(),
      ]),
      desc.at(info, inner)
        |> desc.render(),
    ]),
    //TODO
  // link.new("#")
  //   |> link.class(
  //     "mt-3 inline-block text-sm font-medium text-gray-500 underline dark:text-gray-400",
  //   )
  //   |> link.at([html.text("Learn more")])
  //   |> link.render(),
  ])
}

// PRIVATE
//

fn svg_status(status) {
  // svg func to transform
  case status {
    Info -> svg_alert.info
    Success -> svg_alert.success
    Warning -> svg_alert.warning
    Error -> svg_alert.error
  }
}

fn create_el() {
  el.new("alert")
  |> el.class("rounded-xl border p-4")
}

fn classes_el(el, status) {
  el.classes(el, [
    #(
      "border-blue-light-500 bg-blue-light-50 dark:border-blue-light-500/30 dark:bg-blue-light-500/15",
      status == Info,
    ),
    #(
      "border-success-500 bg-success-50 dark:border-success-500/30 dark:bg-success-500/15",
      status == Success,
    ),
    #(
      "border-warning-500 bg-warning-50 dark:border-warning-500/30 dark:bg-warning-500/15",
      status == Warning,
    ),
    #(
      "border-error-500 bg-error-50 dark:border-error-500/30 dark:bg-error-500/15",
      status == Error,
    ),
  ])
}

fn classes_icon(status) {
  [
    #("text-blue-light-500", status == Info),
    #("text-success-500", status == Success),
    #("text-warning-500 dark:text-orange-400", status == Warning),
    #("text-error-500", status == Error),
  ]
  |> a.classes()
}
