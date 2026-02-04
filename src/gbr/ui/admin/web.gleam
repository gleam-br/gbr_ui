////
//// Falcon admin web module
////

import gleam/bool
import gleam/io
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/uri

import rsvp

import lustre
import lustre/effect

import gbr/js/darkmode
import gbr/js/jsglobal

import gbr/ui/api.{type Api}
import gbr/ui/router

import gbr/ui/admin/alert
import gbr/ui/admin/pages/home
import gbr/ui/admin/pages/login
import gbr/ui/admin/security

// Alias
//

type DarkInfo =
  darkmode.BrowserDarkMode

type Alert =
  alert.UIAlert

type ApiError =
  rsvp.Error

type LoginEvent =
  login.LoginFormEvent

type HomeEvent =
  home.HomePageEvent

/// Web model type to start
///
pub opaque type WebStart {
  WebStart(selector: String, alert: Alert, api: Api, darkinfo: DarkInfo)
}

/// Web model type running
///
pub type Web {
  Web(
    selector: String,
    api: Api,
    home: home.HomePage,
    login: login.LoginPage,
    alert: Alert,
    darkinfo: DarkInfo,
    security: Option(security.Security),
    uri: Option(uri.Uri),
    loading: Bool,
    keep_logged: Bool,
  )
}

/// Web event type
///
pub type WebEvent {
  OnDarkMode
  OnAlert(Bool)
  OnLogin(List(#(String, String)))
  OnRefresh(String)
  OnAuth(Result(String, ApiError))
  OnLoginForm(LoginEvent)
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
    )

  let assert Ok(runtime) =
    lustre.application(init, update, view)
    |> lustre.start(web.selector, web)

  runtime
}

const const_storage_jwt = "auth/token"

/// Lustre init flow
///
pub fn onsecurity(web: Web, on: fn(WebEvent) -> a) -> #(Web, effect.Effect(a)) {
  let #(web, onsecurity) = case security.load(const_storage_jwt) {
    Ok(security) -> {
      let home =
        security
        |> Some()
        |> security.to_user()
        |> home.user(web.home, _)

      let api =
        security.to_string(security)
        |> api.authorization(web.api, _)

      let web = Web(..web, api:, home:, security: Some(security))

      #(web, effect.none())
    }
    Error(err) -> {
      // log
      security.error(err)
      |> io.println_error()

      // try auth apache mod_msal
      let do_msal = {
        use dispatch <- effect.from()

        OnLogin([#("provider", "microsoft")])
        |> on()
        |> dispatch()
      }

      let web = Web(..web, security: None)

      #(web, do_msal)
    }
  }

  let web = Web(..web, loading: True)

  #(web, onsecurity)
}

/// Lustre update flow
///
pub fn do_update(
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
    OnLoginForm(evt) -> do_login_form_update(web, evt)
    OnAuth(auth) -> do_auth(web, auth, on)
    // home
    OnHomePage(home.OnUserDropdownClick("signout")) -> do_signout(web)
    OnHomePage(evt) -> do_home_update(web, evt)
    _ -> #(web, effect.none())
  }

  #(web, effect.batch([onsecurity, onupdate]))
}

// PRIVATE
//

pub fn onchange_uri(oncontent) {
  let on_uri_change = {
    use dispatch <- effect.from()
    use uri <- router.on_change(None)

    oncontent(uri)
    |> dispatch
  }

  on_uri_change
}

fn new_alert() {
  alert.new(
    "Seja bem-vindo!",
    "Falcon admin web é o sistema que administra e gerencia "
      <> "dados referentes ao sistema Horus Falcon",
  )
  |> alert.info()
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

///
///
fn do_auth(web: Web, auth, on) {
  case auth {
    Ok(token) -> {
      let api = api.authorization(web.api, token)
      let security =
        security.persist(token, const_storage_jwt)
        |> option.from_result()

      let home =
        security
        |> security.to_user()
        |> home.user(web.home, _)

      let web =
        Web(..web, api:, alert: new_alert(), security:, home:, loading: False)

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

fn security_guard(web: Web, on) {
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
