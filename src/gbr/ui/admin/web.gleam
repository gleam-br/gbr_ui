////
//// Web admin module
////

import gleam/bool
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/uri

import rsvp

import lustre
import lustre/effect

import gbr/js/darkmode
import gbr/js/jsglobal

import gbr/ui/api
import gbr/ui/router

import gbr/ui/admin/alert
import gbr/ui/admin/pages/home
import gbr/ui/admin/pages/login
import gbr/ui/admin/security
import gbr/ui/admin/user/dropdown

// Alias
//
const const_storage_jwt = "auth/token"

type Api =
  api.Api

type ApiError =
  rsvp.Error

type Alert =
  alert.UIAlert

type DarkInfo =
  darkmode.BrowserDarkMode

type LoginEvent =
  login.LoginPageEvent

type HomeEvent =
  home.HomePageEvent

/// Web model type to start
///
/// - selector: DOM selector element to start lustre lifecycle.
/// - alert: Main alert element in web admin (global use case).
/// - api: Api type instance loading options from `.env` or SO env vars.
/// - darkinfo: Dark info type instance uses to manager dark/light events.
///
pub opaque type WebStart {
  WebStart(selector: String, alert: Alert, api: Api, darkinfo: DarkInfo)
}

/// Web model type running
///
/// - selector: DOM selector element to start lustre lifecycle.
/// - api: Api type instance loading options from `.env` or SO env vars.
/// - alert: Main alert element in web admin (global use case).
/// - darkinfo: Dark info type instance uses to manager dark/light events.
/// - home: Home page admin type instance.
/// - login: Login page admin type instance.
/// - security: Security type instance, manage auth token and user session.
/// - uri: Current location uri.
/// - loading: If web admin is loading.
/// - user_dropdown: User dropdown list, on user logged in show in home header.
/// TODO: Alternatives to set user dropdown, after remove it here
///
pub type Web {
  Web(
    selector: String,
    api: Api,
    alert: Alert,
    darkinfo: DarkInfo,
    home: home.HomePage,
    login: login.LoginPage,
    security: Option(security.Security),
    uri: Option(uri.Uri),
    loading: Bool,
    keep_logged: Bool,
    user_dropdown: Option(dropdown.UIDropdown),
  )
}

/// Web event type
///
/// - OnDarkMode: Switch dark/light mode.
/// - OnAlert: Switch alert visible.
/// - OnLogin: On click submit login form.
/// - OnRefresh: On token needs refresh yourself.
/// - OnAuth: On authentication result from login, new security or error.
/// - OnLoginPage: On login page events, like `on keep me logged in` and more controls.
/// - OnHomePage: On home page events, like `select menu when click it`,
/// `show content page when change uri` and more.
///
pub type WebEvent {
  OnDarkMode
  OnAlert(Bool)
  OnLogin(List(#(String, String)))
  OnRefresh(String)
  OnAuth(Result(String, ApiError))
  OnLoginPage(LoginEvent)
  OnHomePage(HomeEvent)
}

/// New web info
///
/// - selector: Element selector to render app
///
pub fn new(selector: String) -> WebStart {
  let darkinfo = darkmode.new()
  let api = api.new()
  let alert = new_alert()
  // set dark mode from media query
  let _ =
    darkmode.from_media(darkinfo)
    |> result.unwrap(False)

  WebStart(api:, alert:, selector:, darkinfo:)
}

/// New web single page application
///
/// - selector: Element selector to render app
///
pub fn start(web: WebStart, init, update, view) -> lustre.Runtime(a) {
  let WebStart(selector:, alert:, api:, darkinfo:) = web
  let home = home.new()
  let login = login.new()
  let web =
    Web(
      selector:,
      alert:,
      api:,
      darkinfo:,
      login:,
      home:,
      uri: None,
      security: None,
      loading: False,
      keep_logged: False,
      user_dropdown: None,
    )

  let assert Ok(runtime) =
    lustre.application(init, update, view)
    |> lustre.start(web.selector, web)

  runtime
}

/// Lustre init flow
///
/// - web: Web admin type instance.
/// - oncontent: On change uri then call this event.
///
pub fn init(web: Web, oncontent: fn(uri.Uri) -> a) -> #(Web, effect.Effect(a)) {
  let web = case security_load(web) {
    Ok(web) -> {
      let assert Some(security) = web.security
      let home =
        Some(security)
        |> security.to_user(web.user_dropdown)
        |> home.user(web.home, _)
      let api =
        security.to_string(security)
        |> api.authorization(web.api, _)

      Web(..web, api:, home:)
    }
    Error(_) -> {
      web
    }
  }

  #(web, onchange_uri(oncontent))
}

/// Lustre update flow
///
/// - web: Web admin type instance.
/// - event: Web admin event type instance.
/// - on: Convert web admin event to your event type.
///
pub fn update(
  web: Web,
  event: WebEvent,
  on: fn(WebEvent) -> a,
) -> #(Web, effect.Effect(a)) {
  let #(web, onsecurity) = security_guard(web, on)

  let #(web, onupdate) = case event {
    // geral
    OnDarkMode -> do_dark_mode_toggle(web)
    OnAlert(open) -> do_alert_open_toggle(web, open)
    // login
    OnLoginPage(evt) -> do_login_form_update(web, evt)
    OnAuth(auth) -> do_auth(web, auth, on)
    // home
    OnHomePage(home.OnUserDropdownClick("signout")) -> do_signout(web)
    OnHomePage(evt) -> do_home_update(web, evt)
    _ -> #(web, effect.none())
  }

  #(web, effect.batch([onsecurity, onupdate]))
}

// Utils
//

/// Set onchange uri event.
///
/// This uses lib gbr_ui_router.
/// TODO: maybe private fn here
///
pub fn onchange_uri(onuri) {
  use dispatch <- effect.from()
  use uri <- router.on_change(None)

  onuri(uri)
  |> dispatch
}

/// Set user dropdown element, when is logged in.
///
/// - web: Web type instance.
/// - dropdown: User dropdown to logged in session.
/// TODO search alternatives to this
///
pub fn user_dropdown(web: Web, dropdown: dropdown.UIDropdown) -> Web {
  Web(..web, user_dropdown: Some(dropdown))
}

/// Load security token from local storage.
///
/// - web: Web type instance.
///
pub fn security_load(web: Web) -> Result(Web, security.SecurityError) {
  const_storage_jwt
  |> security.load()
  |> result.map(fn(security) {
    let home =
      security
      |> Some()
      |> security.to_user(web.user_dropdown)
      |> home.user(web.home, _)
    let api =
      security.to_string(security)
      |> api.authorization(web.api, _)

    Web(..web, api:, home:, security: Some(security))
  })
}

/// Guard security token if expires and/or needs refresh and/or invalid one logout user.
///
/// - web: Web admin type instance.
///
pub fn security_guard(web: Web, on) {
  // guard return if none security
  use <- bool.guard(option.is_none(web.security), #(web, effect.none()))

  // guard security token
  let assert Some(security) = web.security

  let expired = security.expired(security)
  let refresh = security.refresh(security, 30)

  case expired, refresh {
    // refresh
    Ok(_), Ok(True) -> {
      let web = Web(..web, security: None)
      let assert Ok(Nil) = security.remove(const_storage_jwt)
      let token = security.to_string(security)
      let evt = {
        use dispatch <- effect.from()

        OnRefresh(token)
        |> on()
        |> dispatch()
      }

      #(web, evt)
    }
    // expired
    Ok(exp), Ok(False) if exp <= 0 -> {
      do_signout(web)
    }
    // error
    Error(_), _ | _, Error(_) -> {
      do_signout(web)
    }
    // no refresh and not expired
    _, _ -> {
      #(web, effect.none())
    }
  }
}

// PRIVATE
//

/// New main alert element
///
fn new_alert() {
  alert.new(
    "Seja bem-vindo!",
    "Web admin é o sistema que administra e gerencia "
      <> "dados de maneira eficiente!",
  )
  |> alert.info()
}

/// Show main alert
///
/// - duration: Option int
///
fn show_alert(duration: Option(Int), on) {
  let alert_open = alert_onopen(on)
  let alert_close =
    duration
    |> alert_duration()
    |> alert_onclose(on)

  effect.batch([alert_open, alert_close])
}

fn alert_duration(duration) {
  duration
  |> option.map(fn(duration) {
    case duration {
      d if d > 0 -> Some(d * 1000)
      _ -> None
    }
  })
  |> option.flatten()
  |> option.unwrap(5000)
}

fn alert_onopen(on) {
  use dispatch <- effect.from()

  OnAlert(True)
  |> on()
  |> dispatch()
}

fn alert_onclose(duration, on: fn(WebEvent) -> a) -> effect.Effect(a) {
  use dispatch <- effect.from()

  jsglobal.set_timeout(duration, fn() {
    OnAlert(False)
    |> on()
    |> dispatch()
  })

  Nil
}

/// Auth return process store token or errors.
///
fn do_auth(web: Web, auth, on) {
  case auth {
    Ok(token) -> {
      let security =
        security.persist(token, const_storage_jwt)
        |> option.from_result()
      let home =
        security
        |> security.to_user(web.user_dropdown)
        |> home.user(web.home, _)
      let api = api.authorization(web.api, token)
      let web =
        Web(..web, api:, home:, security:, alert: new_alert(), loading: False)

      let assert Ok(Nil) = router.replace("/home")

      #(web, show_alert(Some(10), on))
    }
    Error(err) -> {
      let alert =
        web.alert
        |> alert.error()
        |> alert.title("Erro de Autenticação")
        |> alert.content(api.error(err))

      #(Web(..web, alert:, loading: False), show_alert(None, on))
    }
  }
}

fn do_login_form_update(web: Web, evt) {
  let login = login.update(web.login, evt)
  let web = Web(..web, login:)

  #(web, effect.none())
}

fn do_home_update(web: Web, evt) {
  let #(home, evt) = home.update(web.home, evt)
  let web = Web(..web, home:)

  #(web, evt)
}

fn do_dark_mode_toggle(web: Web) {
  let _ =
    web.darkinfo
    |> darkmode.toggle(None)
    |> result.unwrap(False)

  #(web, effect.none())
}

fn do_alert_open_toggle(web: Web, open) {
  let alert =
    web.alert
    |> alert.open(open)

  let web = Web(..web, alert:)

  #(web, effect.none())
}

fn do_signout(web) {
  // todo do_signout func
  let web = Web(..web, security: None)
  let assert Ok(Nil) = security.remove(const_storage_jwt)
  let assert Ok(Nil) = router.replace("/login")

  #(web, effect.none())
}
// todo as
// "Dynamic providers and try call default provider when
// loading error jwt token from localStorage"
//
// fn onsecurity(web: Web, on: fn(WebEvent) -> a) -> #(Web, effect.Effect(a)) {
//   let #(web, onsecurity) = case security_load(web) {
//     Ok(_) -> {
//       #(web, effect.none())
//     }
//     Error(err) -> {
//       // log
//       security.error(err)
//       |> io.println_error()
//       // try auth apache mod_msal
//       let do_msal = {
//         use dispatch <- effect.from()
//         OnLogin([#("provider", "microsoft")])
//         |> on()
//         |> dispatch()
//       }
//       let web = Web(..web, security: None)
//       #(web, do_msal)
//     }
//   }
//   let web = Web(..web, loading: True)
//   #(web, onsecurity)
// }
