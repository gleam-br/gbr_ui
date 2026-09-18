////
////
////
////

import gleam/result
import gleam/uri

import lustre/effect as e
import lustre/element/html as h

import gbr/ui/showcase/api
import gbr/ui/showcase/client
import gbr/ui/showcase/darkmode
import gbr/ui/showcase/log

pub type Model {
  Model(api: client.Api, log: log.Log, mode: Mode, darkmode: darkmode.DarkMode)
}

pub type Mode {
  Development
  Production
}

pub opaque type Context {
  Context(api: String, log: String, mode: String, darkmode: darkmode.DarkMode)
}

pub fn context(api api, log log, mode mode) {
  let darkmode =
    darkmode.new()
    |> darkmode.from_media()

  Context(api:, log:, mode:, darkmode:)
}

pub fn init(context) {
  let Context(api:, log:, mode:, darkmode:) = context
  let api =
    uri.parse(api)
    |> result.map(api.create)
    |> result.unwrap(api.create(uri.empty))
  let log =
    case log {
      "debut" -> log.Debug
      "info" -> log.Info
      "warn" -> log.Warn
      _ -> log.Error
    }
    |> log.new()
  let mode = case mode {
    "dev" | "development" -> Development
    _ -> Production
  }
  let model = Model(api:, log:, mode:, darkmode:)

  #(model, e.none())
}

pub fn update(model, _event) {
  #(model, e.none())
}

pub fn view(_model) {
  h.div([], [h.h1([], [h.text("Olá mundo!")])])
}

pub fn env(key, default) {
  case ffi_env(key) {
    Ok(value) -> value
    Error(Nil) -> default
  }
}

//
// -- FFI
//

type TimerID

fn on_timeout(delay, callback) {
  use dispatch <- e.from()

  let _timer_id =
    set_timeout(delay, fn() {
      callback
      |> dispatch()
    })

  Nil
}

@external(javascript, "../../showcase_ffi.mjs", "getEnv")
fn ffi_env(key: String) -> Result(String, Nil)

@external(javascript, "../../showcase_ffi.mjs", "setTimeout")
fn set_timeout(delay: Int, callback: msg) -> TimerID

@external(javascript, "../../showcase_ffi.mjs", "do_initial_uri")
fn ffi_do_initial_uri() -> Result(uri.Uri, Nil)
