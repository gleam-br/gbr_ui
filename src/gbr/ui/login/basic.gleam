////
//// Gleam UI login basic form super element.
////

import gleam/option.{type Option, None, Some}

import lustre/attribute as a
import lustre/element
import lustre/element/html
import lustre/event

import gbr/ui/button
import gbr/ui/checkbox
import gbr/ui/form
import gbr/ui/input
import gbr/ui/link

import gbr/ui/core.{uilabel, uilink}

type Login =
  UILoginBasic

type Render(a) =
  UILoginBasicRender(a)

pub opaque type UILoginBasic {
  UILoginBasic(
    username: String,
    password: String,
    password_visible: Bool,
    keep_logged_in: Bool,
    with_keep_logged_in: Bool,
    with_forgot_password: Bool,
  )
}

pub opaque type UILoginBasicRender(a) {
  UILoginBasicRender(
    in: Login,
    onsubmit: Option(a),
    onkeep_logged_in: Option(a),
    onpassword_visible: Option(a),
    onchange_username: Option(fn(String) -> a),
    onchange_password: Option(fn(String) -> a),
  )
}

pub const data_empty = UILoginBasic(
  username: "",
  password: "",
  password_visible: False,
  keep_logged_in: False,
  with_keep_logged_in: True,
  with_forgot_password: True,
)

/// New login basic super element.
///
pub fn new(username: String, password: String) -> Login {
  UILoginBasic(..data_empty, username:, password:)
}

/// New login basic render.
///
pub fn at(in: Login) -> Render(a) {
  UILoginBasicRender(
    in:,
    onsubmit: None,
    onkeep_logged_in: None,
    onchange_password: None,
    onchange_username: None,
    onpassword_visible: None,
  )
}

/// Set login basic render on submit form event.
///
pub fn on_submit(in: Render(a), onsubmit) -> Render(a) {
  UILoginBasicRender(..in, onsubmit: Some(onsubmit))
}

/// Set login basic render on submit form event.
///
pub fn on_username(in: Render(a), onusername) -> Render(a) {
  UILoginBasicRender(..in, onchange_username: Some(onusername))
}

/// Set login basic render on submit form event.
///
pub fn on_password(in: Render(a), onpassword) -> Render(a) {
  UILoginBasicRender(..in, onchange_password: Some(onpassword))
}

/// Set login basic render on submit form event.
///
pub fn on_password_visible(in: Render(a), onvisible) -> Render(a) {
  UILoginBasicRender(..in, onpassword_visible: Some(onvisible))
}

/// Set login basic render on submit form event.
///
pub fn on_keep_logged(in: Render(a), onkeep_logged) -> Render(a) {
  UILoginBasicRender(..in, onkeep_logged_in: Some(onkeep_logged))
}

/// Render login basic super element.
///
pub fn render(at: Render(a)) {
  let UILoginBasicRender(
    in:,
    onsubmit:,
    onpassword_visible:,
    onchange_username:,
    onchange_password:,
    onkeep_logged_in:,
  ) = at
  let UILoginBasic(
    password_visible:,
    keep_logged_in:,
    with_forgot_password:,
    with_keep_logged_in:,
    ..,
  ) = in
  let eye =
    form.eye(password_visible, [
      option.map(onpassword_visible, event.on_click)
      |> option.unwrap(a.none()),
    ])
  let username =
    input.email("login-user")
    |> input.primary()
    |> input.label("Usuário", [])
    |> input.placeholder("Preencha seu usuário")
    |> input.at()
    |> input.on_change_opt(onchange_username)
    |> input.render()
  let password =
    input.password("login-pass")
    |> input.primary()
    |> input.label("Senha", [])
    |> input.placeholder("Preencha sua senha")
    |> input.visible(password_visible)
    |> input.at_right([], [eye])
    |> input.on_change_opt(onchange_password)
    |> input.render()
  let keep_logged = case with_keep_logged_in {
    True ->
      checkbox.new("check-id")
      |> checkbox.label(uilabel("Keep me logged in.", []))
      |> checkbox.checked(keep_logged_in)
      |> checkbox.at()
      |> checkbox.on_click_opt(onkeep_logged_in)
      |> checkbox.render()
    _ -> element.none()
  }
  let forget_password = case with_forgot_password {
    True ->
      link.new(uilink("/forgot-password", "Forgot password?"))
      |> link.primary()
      |> link.at()
      |> link.render()
    _ -> element.none()
  }
  let links =
    html.div([a.class("flex items-center justify-between")], [
      keep_logged,
      forget_password,
    ])
  let submit =
    html.div([], [
      button.new("form-basic-btn-submit")
      |> button.primary()
      |> button.label(uilabel("Sign In", []))
      |> button.at()
      |> button.on_click_opt(onsubmit)
      |> button.render(),
    ])

  form.new("form-basic")
  |> form.classes(["space-y-5 space-x-2"])
  |> form.at_inline([username, password, links, submit])
  |> form.render()
}
