////
//// 🔝 Gleam UI header super element
////

import gbr/ui/user/dropdown
import gleam/option.{type Option, None, Some}
import lustre/element

import lustre/attribute as a
import lustre/element/html

import gbr/ui/button
import gbr/ui/logo.{type UILogo}
import gbr/ui/notify.{type UINotify}
import gbr/ui/user.{type UIUser}

import gbr/ui/core/model.{type UIRender, to_id}

type Header =
  UIHeader

type Render(a) =
  UIHeaderRender(a)

type Logo =
  UILogo

type User =
  UIUser

type Notify =
  UINotify

/// Header super element
///
/// - id: Identification html element
/// - user: User info (required)
/// - sidebar: Sidebar visible
/// - app_nav: App nav visible to mobile responsive
/// - logo: Logotype info (optional)
/// - notify: Notify info (optional)
///
pub opaque type UIHeader {
  UIHeader(
    id: String,
    user: User,
    sidebar: Bool,
    app_nav: Bool,
    logo: Option(Logo),
    notify: Option(Notify),
  )
}

pub opaque type UIHeaderRender(a) {
  UIHeaderRender(
    in: Header,
    on_app: Option(a),
    on_user: Option(a),
    on_submit: Option(fn(String) -> a),
    on_notify: Option(fn(Bool) -> a),
    on_sidebar: Option(a),
    on_darkmode: Option(a),
  )
}

/// New header super element
///
/// - id: Identification html element
///
pub fn new(id: String) {
  UIHeader(
    id:,
    user: user.new(""),
    sidebar: False,
    app_nav: False,
    logo: None,
    notify: None,
  )
}

/// Set profile info
///
pub fn logo(in: Header, logo: Logo) -> Header {
  UIHeader(..in, logo: Some(logo))
}

/// Set user info
///
pub fn user(in: Header, user: User) -> Header {
  UIHeader(..in, user:)
}

pub fn at(in: Header) -> Render(a) {
  UIHeaderRender(
    in:,
    on_app: None,
    on_submit: None,
    on_user: None,
    on_notify: None,
    on_sidebar: None,
    on_darkmode: None,
  )
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

pub fn on_notify(in: Render(a), on_notify: fn(Bool) -> a) -> Render(a) {
  UIHeaderRender(..in, on_notify: Some(on_notify))
}

pub fn on_submit(in: Render(a), on_submit: fn(String) -> a) -> Render(a) {
  UIHeaderRender(..in, on_submit: Some(on_submit))
}

pub fn on_user(in: Render(a), on_user: a) -> Render(a) {
  UIHeaderRender(..in, on_user: Some(on_user))
}

// pub fn on_search(in: Render(a), on_search: fn(String) -> a) -> Render(a) {
//   UIHeaderRender(..in, on_search: Some(on_search))
// }

pub fn toggle_user(in: Header) -> Header {
  use dropdown <- user.in_dropdown(in.user)
  let dropdown = option.map(dropdown, dropdown.toggle_visible)
  let user = user.dropdown_opt(in.user, dropdown)

  UIHeader(..in, user:)
}

pub fn toggle_notify(in: Header, force: Bool) {
  let UIHeader(notify:, ..) = in
  let notify = option.map(notify, notify.toggle_visible(_, force))

  UIHeader(..in, notify:)
}

pub fn toggle_app(in: Header) -> Header {
  UIHeader(..in, app_nav: !in.app_nav)
}

pub fn toggle_sidebar(in: Header) -> Header {
  UIHeader(..in, sidebar: !in.sidebar)
}

pub fn render(at: Render(a)) -> UIRender(a) {
  let UIHeaderRender(
    in:,
    on_app:,
    on_user:,
    on_notify:,
    on_sidebar:,
    on_darkmode:,
    ..,
  ) = at
  let UIHeader(id, logo:, user:, app_nav:, sidebar:, notify:) = in
  let notify = case notify {
    Some(notify) ->
      notify.at(notify)
      |> notify.on_toggle_opt(on_notify)
      |> notify.render()
    None -> element.none()
  }
  let header_left_toggle_class = case app_nav {
    False -> "hidden"
    True -> "flex"
  }
  let app_class = case app_nav {
    True -> "bg-gray-100 dark:bg-gray-800"
    False -> ""
  }

  html.header([a.id(to_id(id)), a.class(header_class)], [
    html.div([a.class(header_content_class)], [
      html.div([a.class(header_right_class)], [
        button.sidebar("header-btn-toggle-sidebar", sidebar, on_sidebar),
        logo.render_opt(logo),
        button.app_nav("header-btn-toggle-appmobile", app_class, on_app),
      ]),
      html.div(
        [
          a.class(header_left_toggle_class <> " " <> header_left_class),
        ],
        [
          html.div([a.class(header_left_content_class)], [
            button.dark_mode("header-btn-toggle-darkmode", on_darkmode),
            notify,
          ]),
          html.div([a.class(header_left_user_class)], [
            user.at(user)
            |> user.on_dropdown_opt(on_user)
            |> user.on_dropdown_leave_opt(on_user)
            |> user.render(),
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
