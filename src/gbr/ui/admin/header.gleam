////
//// 🔝 Gleam UI header super element
////

import gleam/option.{type Option, None, Some}

import lustre/attribute as a
import lustre/element
import lustre/element/html

import gbr/ui/admin/button
import gbr/ui/admin/user
import gbr/ui/core/el
import gbr/ui/core/model.{type UIRender}
import gbr/ui/logo.{type UILogo}

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
    on_submit: Option(fn(String) -> a),
    on_dropdown: Option(a),
  )
}

/// New header super element
///
/// - id: Identification html element
///
pub fn new(id: String) {
  let el =
    el.new(id)
    |> el.class(header_class)

  UIHeader(el:, logo: None, user: None, sidebar: False, appnav: False)
}

/// Set header logo
///
pub fn logo(in: Header, logo: Logo) -> Header {
  let logo =
    logo.class(logo, "lg:hidden")
    |> Some

  UIHeader(..in, logo:)
}

/// Set header user
///
pub fn user(in: Header, user: User) -> Header {
  UIHeader(..in, user: Some(user))
}

/// Toggle mobile screen
///
pub fn toggle_mobile(in: Header) -> Header {
  UIHeader(..in, appnav: !in.appnav)
}

/// Toggle sidebar open
///
pub fn toggle_sidebar(in: Header) -> Header {
  UIHeader(..in, sidebar: !in.sidebar)
}

/// Toggle dropdown user info
///
pub fn toggle_dropdown(in: Header) -> Header {
  let user =
    in.user
    |> option.map(user.toggle)

  UIHeader(..in, user:)
}

/// New render header element
///
/// - in: Header info
/// - logo: Logo info
/// - user: User render element
///
pub fn render(in: Header) -> Render(a) {
  UIHeaderRender(
    in:,
    on_app: None,
    on_sidebar: None,
    on_darkmode: None,
    on_dropdown: None,
    on_submit: None,
  )
}

/// On mobile screen toggle
///
/// Uses with `toggle_mobile`
///
/// When chance or open in mobile screen
///
pub fn on_mobile(in: Render(a), on_app: a) -> Render(a) {
  on_mobile_opt(in, Some(on_app))
}

pub fn on_mobile_opt(in: Render(a), on_app: Option(a)) -> Render(a) {
  UIHeaderRender(..in, on_app:)
}

/// On sidebar toggle
///
/// Uses with `toggle_sidebar`
///
/// When sidebar button is clicked
///
pub fn on_sidebar(in: Render(a), onsidebar: a) -> Render(a) {
  on_sidebar_opt(in, Some(onsidebar))
}

pub fn on_sidebar_opt(in: Render(a), on_sidebar: Option(a)) -> Render(a) {
  UIHeaderRender(..in, on_sidebar:)
}

/// On dropdown user info toggle
///
/// Uses with `toggle_dropdown`
///
/// When header user element is clicked
///
pub fn on_dropdown(in: Render(a), on_dropdown: a) -> Render(a) {
  on_dropdown_opt(in, Some(on_dropdown))
}

pub fn on_dropdown_opt(in: Render(a), on_dropdown: Option(a)) -> Render(a) {
  UIHeaderRender(..in, on_dropdown:)
}

/// On submit header generic event
///
/// Uses when TODO?
///
/// When clicked generic button TODO?
///
pub fn on_submit(in: Render(a), onsubmit: fn(String) -> a) -> Render(a) {
  on_submit_opt(in, Some(onsubmit))
}

pub fn on_submit_opt(
  in: Render(a),
  on_submit: Option(fn(String) -> a),
) -> Render(a) {
  UIHeaderRender(..in, on_submit:)
}

/// On dark mode toggle
///
/// When dark mode button is clicked
///
pub fn on_darkmode(in: Render(a), on_darkmode: a) -> Render(a) {
  on_darkmode_opt(in, Some(on_darkmode))
}

pub fn on_darkmode_opt(in: Render(a), on_darkmode: Option(a)) -> Render(a) {
  UIHeaderRender(..in, on_darkmode:)
}

/// Render header super element
///
/// - at: Render header element info
///
pub fn view(at: Render(a)) -> UIRender(a) {
  let UIHeaderRender(
    in:,
    on_app:,
    on_sidebar:,
    on_darkmode:,
    on_dropdown:,
    on_submit:,
  ) = at
  let UIHeader(el, logo:, user:, appnav:, sidebar:) = in

  let logo =
    option.map(logo, logo.view)
    |> option.unwrap(element.none())
  let user =
    option.map(user, user.render)
    |> option.map(user.on_submit_opt(_, on_submit))
    |> option.map(user.on_dropdown_opt(_, on_dropdown))
    |> option.map(user.view)
    |> option.map(fn(user) { user })
    |> option.unwrap(element.none())

  let attrs = el.attrs(el)

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
          a.classes([#("flex", appnav), #("hidden", !appnav)]),
        ],
        [
          html.div([a.class(header_left_content_class)], [
            button.dark_mode("header-btn-toggle-darkmode", on_darkmode),
          ]),
          user,
        ],
      ),
    ]),
  ])
}

// PRIVATE
//

const header_class = "z-999 sticky top-0 flex w-full border-gray-200 lg:border-b bg-white dark:border-gray-800 dark:bg-gray-900"

const header_content_class = "flex grow flex-col items-center justify-between lg:flex-row lg:px-6"

const header_right_class = "flex w-full items-center justify-between gap-2 border-b border-gray-200 px-3 py-3 sm:gap-4 lg:justify-normal lg:border-b-0 lg:px-0 lg:py-4 dark:border-gray-800"

const header_left_class = "shadow-theme-md w-full items-center justify-between gap-4 px-5 py-4 lg:flex lg:justify-end lg:px-0 lg:shadow-none"

const header_left_content_class = "2xsm:gap-3 flex items-center gap-2"
