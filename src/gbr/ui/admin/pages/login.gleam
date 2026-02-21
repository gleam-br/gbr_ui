////
//// 🔐 UI login page admin
////

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string

import lustre/attribute as a
import lustre/element
import lustre/element/html

import gbr/ui
import gbr/ui/core/model
import gbr/ui/form
import gbr/ui/logo
import gbr/ui/svg
import gbr/ui/svg/social
import gbr/ui/typo

import gbr/ui/admin/button
import gbr/ui/admin/input
import gbr/ui/admin/input/checkbox
import gbr/ui/admin/separator

// Alias
//

type Logo =
  logo.UILogo

type Form =
  form.UIForm

type Login =
  LoginPage

type Render(a) =
  LoginPageRender(a)

type Event =
  LoginPageEvent

///
///
pub opaque type LoginPage {
  LoginPage(
    logo: Option(Logo),
    form: Form,
    passwd_visible: Bool,
    keep_login: checkbox.UICheckbox,
    username: input.UIInput,
    password: input.UIInput,
  )
}

pub type LoginPageEvent {
  OnKeepLogin
  OnPasswordVisible
}

pub opaque type LoginPageRender(a) {
  LoginPageRender(
    in: Login,
    ondark: Option(a),
    onform: Option(fn(Event) -> a),
    onsubmit: Option(fn(model.UIProperties) -> a),
  )
}

/// New login page element with logo
///
pub fn new() -> Login {
  let form = form.new("page-login")

  LoginPage(
    form:,
    logo: None,
    passwd_visible: False,
    keep_login: checkbox.new("keepme-loggedin")
      |> checkbox.label("Manter-me logado?")
      |> checkbox.checked(True),
    username: input.text("username")
      |> input.placeholder("Digite seu usuário aqui"),
    password: input.new("password", "password")
      |> input.password(False)
      |> input.placeholder("Digite sua senha aqui"),
  )
}

pub fn username(in: LoginPage, value: String) -> LoginPage {
  let username = input.value(in.username, value)
  LoginPage(..in, username:)
}

pub fn password(in: LoginPage, value: String) -> LoginPage {
  let password = input.value(in.password, value)
  LoginPage(..in, password:)
}

/// Set logo element to login
///
pub fn logo(in: LoginPage, logo: logo.UILogo) -> LoginPage {
  LoginPage(..in, logo: Some(logo))
}

pub fn render(in: Login) -> Render(a) {
  LoginPageRender(in:, onform: None, onsubmit: None, ondark: None)
}

pub fn ondarkmode(in: Render(a), ondarkmode: a) -> Render(a) {
  LoginPageRender(..in, ondark: Some(ondarkmode))
}

pub fn onform(in: Render(a), onform: fn(Event) -> a) -> Render(a) {
  LoginPageRender(..in, onform: Some(onform))
}

pub fn onsubmit(
  in: Render(a),
  onsubmit: fn(model.UIProperties) -> a,
) -> Render(a) {
  LoginPageRender(..in, onsubmit: Some(onsubmit))
}

pub fn view(at: Render(a)) -> element.Element(a) {
  let LoginPageRender(in:, ..) = at

  let hero =
    in.logo
    |> option.map(hero_logo_render)
    |> option.unwrap(element.none())

  let login = login_render(at)

  ui.horizontal([
    login,
    hero,
  ])
}

pub fn update(in: Login, evt: Event) -> Login {
  case evt {
    OnKeepLogin -> LoginPage(..in, keep_login: checkbox.toggle(in.keep_login))
    OnPasswordVisible -> LoginPage(..in, passwd_visible: !in.passwd_visible)
  }
}

// PRIVATE
//

const const_class_login_provider = "inline-flex items-center justify-center gap-3 rounded-lg bg-gray-100 px-7 py-3 text-sm font-normal text-gray-700 transition-colors hover:bg-gray-200 hover:text-gray-800 dark:bg-white/5 dark:text-white/90 dark:hover:bg-white/10"

fn hero_logo_render(logotype: logo.UILogo) {
  // todo: make grid.svg dynamic in parameter function
  let logo = [html.img([a.src("/grid-01.svg")])]
  let inner = [
    logo.view(logotype),
    html.p([a.class("text-center text-gray-400 dark:text-white/60")], [
      html.text(
        "Bem-vindo ao Sistema Administrador, faça seu login para acessar o painel.",
      ),
    ]),
  ]

  let hero = html.div([a.class("flex max-w-xs flex-col items-center")], inner)

  ui.grid(logo, logo, [hero])
}

fn login_render(at) {
  let LoginPageRender(in:, onsubmit:, onform:, ondark:) = at

  let login_head = login_head_render(ondark)
  let login_providers = login_provider_render(onsubmit)
  let login_form = login_form_render(in, onform, onsubmit)

  html.div([a.class("flex flex-col flex-1 w-full lg:w-1/2")], [
    html.div(
      [a.class("mx-auto flex w-full max-w-md flex-1 flex-col justify-center")],
      [
        html.div([], [
          login_head,
          // form basic and providers
          html.div([], [
            login_providers,
            // separator
            separator.new()
              |> separator.label("Ou")
              |> separator.view(),
            // form basic login
            login_form,
          ]),
        ]),
      ],
    ),
  ])
}

fn login_form_render(in, onform, onsubmit) {
  let LoginPage(form:, username:, password:, keep_login:, passwd_visible:, ..) =
    in
  let username = {
    username
    |> input.label("Usuário:")
    |> input.primary()
    |> input.render([], [])
    |> input.view()
  }
  let password = {
    password
    |> input.label("Senha:")
    |> input.password(passwd_visible)
    |> input.render([], [])
    |> input.inner_onclick(
      onform
      |> option.map(fn(onform) {
        OnPasswordVisible
        |> onform()
      }),
    )
    |> input.view()
  }
  let onkeeplogin =
    option.map(onform, fn(onform) {
      OnKeepLogin
      |> onform()
    })
  let keep_login =
    keep_login
    |> checkbox.render()
    |> checkbox.onclick(onkeeplogin)
    |> checkbox.view()

  let links =
    html.div([a.class("flex items-center justify-between")], [keep_login])
  let submit =
    button.new("login-submit")
    |> button.kind("submit")
    |> button.label("Entrar")
    |> button.primary()
    |> button.class_append("w-1/3 justify-center")
    |> button.render([])
    |> button.view()

  let inner =
    html.div([a.class("space-y-5")], [
      username,
      password,
      links,
      html.div([a.class("flex justify-end")], [submit]),
    ])

  let onsubmit =
    onsubmit
    |> option.map(fn(onsubmit) { fn(values) { onsubmit(values) } })

  form
  |> form.render([inner])
  |> form.onsubmit(onsubmit)
  |> form.view()
}

fn login_head_render(ondarkmode: Option(a)) {
  html.div([a.class("mb-5 sm:mb-8")], [
    html.div(
      [a.class("inline-flex justify-between w-full max-w-md pt-10 mx-auto")],
      [
        typo.h1("Login")
          |> typo.class(
            "text-title-sm sm:text-title-md mb-2 font-semibold text-gray-800 dark:text-white/90",
          )
          |> typo.view(),
        button.dark_mode("login-dark-mode", ondarkmode),
      ],
    ),
    typo.p("Entre com seu usuário e senha para acessar.")
      |> typo.class("text-sm text-gray-500 dark:text-gray-400")
      |> typo.view(),
  ])
}

fn login_provider_render(onsubmit) {
  let providers = {
    use #(id, transform) <- list.map([
      #("microsoft", social.microsoft),
      //
    //#("google", social.google),
    //#("twitter", social.twitter),
    ])

    button.new("btn-login-" <> id)
    |> button.label("Login " <> string.capitalise(id))
    |> button.class(const_class_login_provider)
    |> button.render_left([
      svg.new(23, 23)
      |> transform
      |> svg.view(),
    ])
    |> button.onclick(
      onsubmit
      |> option.map(fn(onsubmit) { onsubmit([#("provider", "microsoft")]) }),
    )
    |> button.view()
  }

  // provider login buttons
  html.div(
    [a.class("grid grid-cols-1 gap-3 sm:grid-cols-2 sm:gap-5")],
    providers,
  )
}
