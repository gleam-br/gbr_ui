////
//// 🔗 Gleam UI core link super element
////
//// Is one element with required href attribute.
////
//// To render a link needs inner elements like a span with text or maybe more
//// complex example, e.g., `gbr/ui/logo`.
////

import gleam/option.{type Option, None, Some}

import lustre/attribute as a
import lustre/element/html
import lustre/event

import gbr/ui/core/el
import gbr/ui/core/model.{type UIRender, type UIRenders}

type El =
  el.UIEl

type Link =
  UILink

type Render(a) =
  UILinkRender(a)

/// Link event on click
///
/// - href: The href link attribute
///
type OnClick(a) =
  Option(fn(String) -> a)

/// Link super element
///
/// el: Element info
/// href: Path location link
///
pub opaque type UILink {
  UILink(el: El, href: String)
}

pub opaque type UILinkRender(a) {
  UILinkRender(in: Link, inner: UIRenders(a), onclick: OnClick(a))
}

/// New link super element
///
/// - href: `lustre/attribute.href`
///
pub fn new(href: String) -> Link {
  let el = el.new(const_key)

  UILink(el:, href:)
}

pub fn href(in: Link, href: String) -> Link {
  UILink(..in, href:)
}

pub fn class(in: Link, class: String) -> Link {
  let el = el.class(in.el, class)

  UILink(..in, el:)
}

pub fn at(in: Link) -> Render(a) {
  UILinkRender(in:, inner: [], onclick: None)
}

pub fn inner(at: Render(a), inner: UIRenders(a)) -> Render(a) {
  UILinkRender(..at, inner:)
}

pub fn onclick(at: Render(a), onclick: fn(String) -> a) -> Render(a) {
  UILinkRender(..at, onclick: Some(onclick))
}

/// Render link super element
///
pub fn render(at: Render(a)) -> UIRender(a) {
  let UILinkRender(in:, inner:, onclick:) = at
  let UILink(el:, href:) = in

  let attrs = el.attrs(el)
  let onclick = map_onclick(href, onclick)

  html.a([a.href(href), onclick, ..attrs], inner)
}

// PRIVATE
//

fn map_onclick(href, onclick) {
  option.map(onclick, fn(onclick) {
    onclick(href)
    |> event.on_click()
  })
  |> option.unwrap(a.none())
}

const const_key = ".link"
