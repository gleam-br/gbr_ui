////
//// Gleam UI super alert elements.
////

import gleam/bool
import gleam/list

import lustre/element
import lustre/element/html

import gbr/ui/svg
import gbr/ui/svg/alert as svg_alert

import gbr/ui/core/el
import gbr/ui/core/el/desc
import gbr/ui/core/model.{type UIRender, type UIRenders, type UISwitches}

type Alert =
  UIAlert

type Render(a) =
  UIAlertRender(a)

type El =
  el.UIEl

type Desc =
  desc.UIDesc

type Switches =
  UISwitches

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
  UIAlert(el: El, info: Desc, status: Status, open: Bool, icon_show: Bool)
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
  let el = el.new(const_key)
  let info =
    desc.new(el)
    |> desc.text(title)
    |> desc.desc(desc)

  UIAlert(el:, info:, status: Info, open: False, icon_show: False)
}

/// Replace alert title
///
pub fn title(in: Alert, title: String) -> Alert {
  let info = desc.text(in.info, title)

  UIAlert(..in, info:)
}

/// Replace alert title
///
pub fn desc(in: Alert, desc: String) -> Alert {
  let info = desc.desc(in.info, desc)

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

/// Set alert main class style
///
/// in: Alert info
/// class: Alert class
///
pub fn class(in: Alert, class: String) -> Alert {
  let el = el.class(in.el, class)

  UIAlert(..in, el:)
}

/// Set alert content class style
///
/// in: Alert info
/// class: Alert content class
///
pub fn class_content(in: Alert, class: String) -> Alert {
  let el = el.class_key(in.el, const_key_content, class)

  UIAlert(..in, el:)
}

/// Set alert title class style
///
/// in: Alert title info
/// class: Alert title class
///
pub fn class_title(in: Alert, class: String) -> Alert {
  let info = desc.class_text(in.info, class)

  UIAlert(..in, info:)
}

/// Set alert description class style
///
/// in: Alert description info
/// class: Alert description class
///
pub fn class_desc(in: Alert, class: String) -> Alert {
  let info = desc.class_desc(in.info, class)

  UIAlert(..in, info:)
}

/// Set alert icon class style
///
/// in: Alert info
/// class: Alert icon class to set
///
pub fn class_icon(in: Alert, class: String) -> Alert {
  let el = el.class_key(in.el, const_key_icon, class)

  UIAlert(..in, el:)
}

/// Set alert status class style
///
/// - in: Alert info
/// - class: Alert status class style
/// - class_icon: Alert icon class style, only if `icon_show = True`
///
pub fn class_status_info(in: Alert, class: String, class_icon: String) {
  class_status(in, Info, class, class_icon)
}

/// Set alert status class style
///
/// - in: Alert info
/// - class: Alert status class style
/// - class_icon: Alert icon class style, only if `icon_show = True`
///
pub fn class_status_success(in: Alert, class: String, class_icon: String) {
  class_status(in, Success, class, class_icon)
}

/// Set alert status class style
///
/// - in: Alert info
/// - class: Alert status class style
/// - class_icon: Alert icon class style, only if `icon_show = True`
///
pub fn class_status_warn(in: Alert, class: String, class_icon: String) {
  class_status(in, Warning, class, class_icon)
}

/// Set alert status class style
///
/// - in: Alert info
/// - class: Alert status class style
/// - class_icon: Alert icon class style, only if `icon_show = True`
///
pub fn class_status_error(in: Alert, class: String, class_icon: String) {
  class_status(in, Error, class, class_icon)
}

/// Set alert status classes switch
///
/// - in: Alert info
/// - classes: Alert status classes
/// - classes_icon: Alert icon class style, only if `icon_show = True`
///
pub fn classes_status_info(in: Alert, classes: Switches, classes_icon: Switches) {
  classes_status(in, Info, classes, classes_icon)
}

/// Set alert status classes switch
///
/// - in: Alert info
/// - classes: Alert status classes
/// - classes_icon: Alert icon class style, only if `icon_show = True`
///
pub fn classes_status_success(
  in: Alert,
  classes: Switches,
  classes_icon: Switches,
) {
  classes_status(in, Success, classes, classes_icon)
}

/// Set alert status classes switch style
///
/// - in: Alert info
/// - classes: Alert status classes
/// - classes_icon: Alert icon class style, only if `icon_show = True`
///
pub fn classes_status_warn(in: Alert, classes: Switches, classes_icon: Switches) {
  classes_status(in, Warning, classes, classes_icon)
}

/// Set alert status classes switch
///
/// - in: Alert info
/// - classes: Alert status classes
/// - classes_icon: Alert icon class style, only if `icon_show = True`
///
pub fn classes_status_error(
  in: Alert,
  classes: Switches,
  classes_icon: Switches,
) {
  classes_status(in, Error, classes, classes_icon)
}

/// New alert render element.
///
/// - in: Alert info
///
pub fn at(in: Alert) -> Render(a) {
  UIAlertRender(in:, inner: [])
}

/// Replace alert inner elements
///
pub fn inner(in: Render(a), inner: UIRenders(a)) -> Render(a) {
  UIAlertRender(..in, inner:)
}

/// Set attribute el.classes by status
///
/// Render super alert element to `lustre/element/html.{div}`.
///
pub fn render(at: Render(a)) -> UIRender(a) {
  let UIAlertRender(in:, inner:) = at
  let UIAlert(el:, info:, status:, open:, icon_show:) = in

  use <- bool.guard(!open, element.none())

  let #(status_key, status_key_icon) = status_key(status)

  let el_attrs = el.attrs(el)
  let el_attrs_content = el.attrs_key(el, const_key_content)

  let el_attrs_icon = el.attrs_key(el, const_key_icon)
  let el_attrs_status = el.attrs_key(el, status_key)
  let el_attrs_status_icon = el.attrs_key(el, status_key_icon)

  let el_attrs =
    el_attrs
    |> list.append(el_attrs_status)
  let el_attrs_icon =
    el_attrs_icon
    |> list.append(el_attrs_status_icon)

  let status_icon = status_icon(status, el_attrs_icon, icon_show)
  let status_info =
    desc.at(info)
    |> desc.inner(inner)
    |> desc.render()

  html.div(el_attrs, [
    html.div(el_attrs_content, [
      status_icon,
      status_info,
    ]),
  ])
}

// PRIVATE
//

fn classes_status(
  in: Alert,
  status: Status,
  classes: Switches,
  classes_icon: Switches,
) -> Alert {
  let #(status_key, status_key_icon) = status_key(status)
  let el =
    el.classes_key(in.el, status_key, classes)
    |> el.classes_key(status_key_icon, classes_icon)

  UIAlert(..in, el:)
}

fn class_status(
  in: Alert,
  status: Status,
  class: String,
  class_icon: String,
) -> Alert {
  let #(status_key, status_key_icon) = status_key(status)

  let el =
    el.class_key(in.el, status_key, class)
    |> el.class_key(status_key_icon, class_icon)

  UIAlert(..in, el:)
}

fn status_key(status) {
  let key = case status {
    Info -> "info"
    Success -> "success"
    Warning -> "warning"
    Error -> "error"
  }

  let icon_key = key <> const_key_icon

  #(key, icon_key)
}

fn status_icon(status, attrs, show) {
  use <- bool.guard(!show, element.none())

  // svg func to transform
  let status = case status {
    Info -> svg_alert.info
    Success -> svg_alert.success
    Warning -> svg_alert.warning
    Error -> svg_alert.error
  }

  html.div(attrs, [
    svg.new(24, 24)
    |> status()
    |> svg.render(),
  ])
}

const const_key = ".alert"

const const_key_icon = ".alert-icon"

const const_key_content = ".alert-content"
