////
//// Gleam UI link super element.
////

import lustre/attribute as a
import lustre/element/html

import gbr/ui/core.{type UIAttributes, type UILink, type UIRender, UILink}

type Link =
  UILink

/// Render link super element to `lustre/element/html.{a}`.
///
pub fn render(in: Link, attributes: UIAttributes(a)) -> UIRender(a) {
  let UILink(href:, title:) = in

  html.a([a.href(href), ..attributes], [html.text(title)])
}
