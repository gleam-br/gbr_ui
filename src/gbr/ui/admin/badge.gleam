////
//// Gleam UI badge super element
////

import gleam/list
import gleam/option.{type Option, None, Some}

import lustre/attribute as a
import lustre/element/html
import lustre/event

import gbr/ui/core/el
import gbr/ui/core/model.{type UIRender, type UIRenders}

//Alias
//

type Badge =
  UIBadge

type Render(a) =
  UIBadgeRender(a)

pub opaque type UIBadge {
  UIBadge(el: el.UIEl, text: String)
}

pub opaque type UIBadgeRender(a) {
  UIBadgeRender(
    in: Badge,
    inner: UIRenders(a),
    onclick: Option(fn(String) -> a),
  )
}

pub fn solid(id: String) -> Badge {
  new(
    id,
    "inline-flex items-center justify-center gap-1 rounded-full bg-brand-500 px-2.5 "
      <> "py-0.5 text-sm font-medium text-white",
  )
}

pub fn light(id: String) -> Badge {
  new(
    id,
    "inline-flex items-center justify-center gap-1 rounded-full bg-brand-50 px-2.5 "
      <> "py-0.5 text-sm font-medium text-brand-500 dark:bg-brand-500/15 dark:text-brand-400",
  )
}

pub fn text(in: Badge, text: String) -> Badge {
  UIBadge(..in, text:)
}

pub fn at(in: Badge) -> Render(a) {
  UIBadgeRender(in:, inner: [html.text(in.text)], onclick: None)
}

pub fn at_right(in: Badge, inner: UIRenders(a)) -> Render(a) {
  UIBadgeRender(in:, inner: [html.text(in.text), ..inner], onclick: None)
}

pub fn at_left(in: Badge, inner: UIRenders(a)) -> Render(a) {
  let inner = list.append(inner, [html.text(in.text)])

  UIBadgeRender(in:, inner:, onclick: None)
}

pub fn onclick(at: Render(a), onclick: fn(String) -> a) {
  UIBadgeRender(..at, onclick: Some(onclick))
}

pub fn render(at: Render(a)) -> UIRender(a) {
  let UIBadgeRender(in:, inner:, onclick:) = at
  let UIBadge(el:, ..) = in

  let id = el.get_id(el)
  let attrs = el.attrs(el)
  let onclick =
    onclick
    |> option.map(fn(onclick) { event.on_click(onclick(id)) })
    |> option.unwrap(a.none())

  html.span([onclick, ..attrs], inner)
}

// PRIVATE
//

fn new(id: String, class: String) -> Badge {
  let el =
    el.new(id)
    |> el.class(class)

  UIBadge(el:, text: "")
}
