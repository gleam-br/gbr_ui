////
//// Gleam UI link super element.
////

import gleam/list

import lustre/attribute as a
import lustre/element/html

import gbr/ui/core.{
  type UIAttributes, type UILink as LinkCore, type UIRender, type UIRenders,
}

type Link =
  UILink

pub opaque type UILink {
  UILink(target: LinkCore, primary: Bool, signin: Bool)
}

pub type UILinkRender(a) {
  UILinkRender(in: UILink, inner: UIRenders(a))
}

pub fn new(target: LinkCore) {
  UILink(target:, primary: False, signin: False)
}

pub fn signin(in: Link) -> Link {
  UILink(..in, primary: False, signin: True)
}

pub fn primary(in: Link) -> Link {
  UILink(..in, primary: True, signin: False)
}

/// New button render at left inner and onclick event.
///
pub fn at_rigth(in: Link, inner: UIRenders(a)) -> UILinkRender(a) {
  let UILink(target:, ..) = in
  let inner = list.append(inner, [html.text(target.title)])

  UILinkRender(in:, inner:)
}

/// New button render at left inner and onclick event.
///
pub fn at_left(in: Link, inner: UIRenders(a)) -> UILinkRender(a) {
  let UILink(target:, ..) = in
  let inner = [html.text(target.title), ..inner]

  UILinkRender(in:, inner:)
}

pub fn at(in: Link) -> UILinkRender(a) {
  UILinkRender(in:, inner: [])
}

/// Render link super element to `lustre/element/html.{a}`.
///
pub fn render(at: UILinkRender(a)) -> UIRender(a) {
  let UILinkRender(in:, inner:) = at
  let UILink(signin:, primary:, ..) = in

  case primary, signin {
    True, False -> render_attrs(in, [a.class(class_primary)], inner)
    False, True -> render_attrs(in, [a.class(class_btn_signin)], inner)
    _, _ -> render_attrs(in, [], inner)
  }
}

// PRIVATE
//

fn render_attrs(
  in: Link,
  attributes: UIAttributes(a),
  inner: UIRenders(a),
) -> UIRender(a) {
  let UILink(target:, ..) = in

  case inner {
    [] -> html.a([a.href(target.href), ..attributes], [html.text(target.title)])
    _ -> html.a([a.href(target.href), ..attributes], inner)
  }
}

const class_btn_signin = "dark:hover:text-gray-300 cursor-pointer inline-flex items-center justify-center gap-3 py-3 text-sm font-normal text-gray-700 transition-colors bg-gray-100 rounded-lg px-7 hover:bg-gray-200 hover:text-gray-800 dark:bg-white/5 dark:text-white/90 dark:hover:bg-white/10"

const class_primary = "cursor-pointer text-sm text-brand-500 hover:text-brand-600 dark:text-brand-400"
