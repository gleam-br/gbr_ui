////
//// GBR: UI Showcase
////

import lustre

import gbr/ui/showcase

pub fn main() {
  let api = showcase.env("VITE_GBR_UI_SHOWCASE_API", "http://localhost:8080")
  let log = showcase.env("VITE_GBR_UI_SHOWCASE_LOG", "debug")
  let mode = showcase.env("VITE_GBR_UI_SHOWCASE_MODE", "dev")
  let context = showcase.context(api:, log:, mode:)

  lustre.application(showcase.init, showcase.update, showcase.view)
  |> lustre.start("body", context)
}
