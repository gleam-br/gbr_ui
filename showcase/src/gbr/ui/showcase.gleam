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

import gbr/ui/showcase/components/button
import gbr/ui/showcase/components/typo
import gbr/ui/theme
import gleam/option
import lustre/attribute as a

pub fn view(_model) {
  let title =
    typo.h1()
    |> typo.view(
      [
        a.class(
          "text-transparent bg-clip-text bg-gradient-to-r from-green-400 to-emerald-600 dark:from-green-300 dark:to-emerald-500 font-extrabold tracking-tight",
        ),
      ],
      [h.text("GBR UI")],
    )

  let subtitle =
    typo.p(theme.SizeLg)
    |> typo.view(
      [
        a.class(
          "text-gray-600 dark:text-gray-300 mt-6 max-w-2xl mx-auto font-medium",
        ),
      ],
      [
        h.text(
          "O primeiro Design System Algébrico 100% Type-Safe construído em Gleam, Lustre e TailwindCSS para a comunidade brasileira.",
        ),
      ],
    )

  let btn1 =
    button.normal()
    |> button.primary()
    |> button.with_size(theme.SizeLg)
    |> button.with_shape(theme.ShapePill)
    |> button.view(
      [
        a.class(
          "w-full sm:w-auto px-8 transition-transform hover:scale-105 hover:shadow-lg",
        ),
      ],
      [
        h.text("Começar Agora"),
      ],
    )

  let btn2 =
    button.link("https://github.com/gleam-br", option.Some("_blank"))
    |> button.secondary()
    |> button.with_size(theme.SizeLg)
    |> button.with_shape(theme.ShapePill)
    |> button.view(
      [a.class("w-full sm:w-auto px-8 transition-transform hover:scale-105")],
      [
        h.text("Ver no GitHub"),
      ],
    )

  h.div(
    [
      a.class(
        "min-h-screen bg-slate-50 dark:bg-slate-950 flex flex-col items-center justify-center p-6 transition-colors duration-500",
      ),
    ],
    [
      h.div(
        [
          a.class(
            "text-center space-y-8 p-12 bg-white dark:bg-slate-900 rounded-3xl shadow-2xl dark:shadow-emerald-900/20 border border-slate-100 dark:border-slate-800",
          ),
        ],
        [
          h.img([
            a.src("/logo.svg"),
            a.alt("Gleam BR Logo"),
            a.class("w-32 h-32 mx-auto mb-2 drop-shadow-xl"),
          ]),
          title,
          subtitle,
          h.div(
            [a.class("flex flex-col sm:flex-row gap-4 justify-center mt-10")],
            [
              btn1,
              btn2,
            ],
          ),
        ],
      ),
    ],
  )
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

pub type TimerID

/// Define um delay para executar um callback
pub fn on_timeout(delay, callback) {
  use dispatch <- e.from()

  let _timer_id =
    set_timeout(delay, fn() {
      callback
      |> dispatch()
    })

  Nil
}

/// location.url
pub fn location_uri() {
  ffi_do_initial_uri()
}

@external(javascript, "../../showcase_ffi.mjs", "getEnv")
fn ffi_env(key: String) -> Result(String, Nil)

@external(javascript, "../../showcase_ffi.mjs", "setTimeout")
fn set_timeout(delay: Int, callback: msg) -> TimerID

@external(javascript, "../../showcase_ffi.mjs", "do_initial_uri")
fn ffi_do_initial_uri() -> Result(uri.Uri, Nil)
