////
//// 🔝 Gleam UI header super element
////

import gleam/option.{type Option, None, Some}
import lustre/element

import lustre/attribute as a
import lustre/element/html

import gbr/ui/core/el
import gbr/ui/core/model.{type UIRender}
import gbr/ui/logo.{type UILogo}

import gbr/ui/admin/button
import gbr/ui/admin/user

type Header =
  UIHeader

type Render(a) =
  UIHeaderRender(a)

type Logo =
  UILogo

type User =
  user.UIUser

/// Header super element
///
/// - id: Identification html element
/// - sidebar: Sidebar visible
/// - app_nav: App nav visible to mobile responsive
///
pub opaque type UIHeader {
  UIHeader(
    el: el.UIEl,
    logo: Option(Logo),
    user: Option(User),
    sidebar: Bool,
    appnav: Bool,
  )
}

/// Render header element
///
/// - user: User info
/// - logo: Logotype info
/// - on_...: Events
///
pub opaque type UIHeaderRender(a) {
  UIHeaderRender(
    in: Header,
    on_app: Option(a),
    on_sidebar: Option(a),
    on_darkmode: Option(a),
  )
}

/// New header super element
///
/// - id: Identification html element
/// - sidebar: Logo info
/// - appnav: User info
///
pub fn new(id: String) {
  let el =
    el.new(id)
    |> el.class(header_class)

  UIHeader(el:, logo: None, user: None, sidebar: False, appnav: False)
}

pub fn logo(in: Header, logo: Logo) -> Header {
  let logo =
    logo.class(logo, "lg:hidden")
    |> Some

  UIHeader(..in, logo:)
}

pub fn user(in: Header, user: User) -> Header {
  UIHeader(..in, user: Some(user))
}

/// New render header element
///
/// - in: Header info
/// - logo: Logo info
/// - user: User render element
///
pub fn at(in: Header) -> Render(a) {
  UIHeaderRender(in:, on_app: None, on_sidebar: None, on_darkmode: None)
}

pub fn on_app_mobile(in: Render(a), on_app: a) -> Render(a) {
  UIHeaderRender(..in, on_app: Some(on_app))
}

pub fn on_sidebar(in: Render(a), on_sidebar: a) -> Render(a) {
  UIHeaderRender(..in, on_app: Some(on_sidebar))
}

pub fn on_darkmode(in: Render(a), on_darkmode: a) -> Render(a) {
  UIHeaderRender(..in, on_darkmode: Some(on_darkmode))
}

pub fn toggle_app(in: Header) -> Header {
  UIHeader(..in, appnav: !in.appnav)
}

pub fn toggle_sidebar(in: Header) -> Header {
  UIHeader(..in, sidebar: !in.sidebar)
}

pub fn render(at: Render(a)) -> UIRender(a) {
  let UIHeaderRender(in:, on_app:, on_sidebar:, on_darkmode:) = at
  let UIHeader(el, logo:, user:, appnav:, sidebar:) = in

  let attrs = el.attrs(el)
  let logo =
    option.map(logo, logo.render)
    |> option.unwrap(element.none())
  let user =
    option.map(user, user.at)
    |> option.map(user.render)
    |> option.unwrap(element.none())

  html.header(attrs, [
    html.div([a.class(header_content_class)], [
      html.div([a.class(header_right_class)], [
        button.sidebar("header-toggle-sidebar", sidebar, on_sidebar),
        logo,
        button.app_nav("header-toggle-appnav", appnav, on_app),
      ]),
      html.div(
        [
          a.class(header_left_class),
          a.classes([#("flex", !appnav), #("hidden", appnav)]),
        ],
        [
          html.div([a.class(header_left_content_class)], [
            button.dark_mode("header-btn-toggle-darkmode", on_darkmode),
          ]),
          html.div([a.class(header_left_user_class)], [
            user,
          ]),
        ],
      ),
    ]),
  ])
}

// PRIVATE
//

const header_class = "sticky top-0 z-99999 flex w-full border-gray-200 lg:border-b bg-white dark:border-gray-800 dark:bg-gray-900"

const header_content_class = "flex grow flex-col items-center justify-between lg:flex-row lg:px-6"

const header_right_class = "flex w-full items-center justify-between gap-2 border-b border-gray-200 px-3 py-3 sm:gap-4 lg:justify-normal lg:border-b-0 lg:px-0 lg:py-4 dark:border-gray-800"

const header_left_class = "shadow-theme-md w-full items-center justify-between gap-4 px-5 py-4 lg:flex lg:justify-end lg:px-0 lg:shadow-none"

const header_left_content_class = "2xsm:gap-3 flex items-center gap-2"

const header_left_user_class = "2xsm:gap-3 flex items-center gap-2"
