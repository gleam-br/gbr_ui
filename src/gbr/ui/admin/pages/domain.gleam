////
//// 📑 UI super page element type and functions
////

import gleam/dict
import gleam/option.{type Option}

import lustre/effect
import lustre/element

/// UI page admin type
///
/// - id: Page id
/// - title: Page title
///
pub type UIPage(a) {
  UIPage(
    id: String,
    title: String,
    view: Option(fn() -> element.Element(a)),
    init: Option(fn() -> effect.Effect(a)),
  )
}

/// List of ui pages
///
pub type UIPages(a) =
  dict.Dict(String, UIPage(a))
