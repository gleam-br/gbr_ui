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

type Background =
  UIBadgeBackground

type Behavior =
  UIBadgeBehavior

pub opaque type UIBadgeBackground {
  BackgroundLight
  BackgroundSolid
}

pub opaque type UIBadgeBehavior {
  BehaviorPrimary
  BehaviorSuccess
  BehaviorError
  BehaviorWarning
  BehaviorInfo
  BehaviorBright
  BehaviorDark
}

pub opaque type UIBadge {
  UIBadge(el: el.UIEl, text: String, behavior: Behavior, background: Background)
}

pub opaque type UIBadgeRender(a) {
  UIBadgeRender(
    in: Badge,
    inner: UIRenders(a),
    onclick: Option(fn(String) -> a),
  )
}

pub fn new(id: String) -> Badge {
  let el =
    el.new(id)
    |> el.class(
      "inline-flex items-center justify-center gap-1 rounded-full px-2.5 "
      <> "py-0.5 text-sm font-medium text-white",
    )

  UIBadge(el:, text: "", behavior: BehaviorPrimary, background: BackgroundLight)
}

pub fn text(in: Badge, text: String) -> Badge {
  UIBadge(..in, text:)
}

pub fn light(in: Badge) -> Badge {
  UIBadge(..in, background: BackgroundLight)
}

pub fn solid(in: Badge) -> Badge {
  UIBadge(..in, background: BackgroundSolid)
}

pub fn primary(in: Badge) -> Badge {
  UIBadge(..in, behavior: BehaviorPrimary)
}

pub fn success(in: Badge) -> Badge {
  UIBadge(..in, behavior: BehaviorSuccess)
}

pub fn warn(in: Badge) -> Badge {
  UIBadge(..in, behavior: BehaviorWarning)
}

pub fn error(in: Badge) -> Badge {
  UIBadge(..in, behavior: BehaviorError)
}

pub fn info(in: Badge) -> Badge {
  UIBadge(..in, behavior: BehaviorInfo)
}

pub fn bright(in: Badge) -> Badge {
  UIBadge(..in, behavior: BehaviorBright)
}

pub fn dark(in: Badge) -> Badge {
  UIBadge(..in, behavior: BehaviorDark)
}

pub fn render(in: Badge) -> Render(a) {
  UIBadgeRender(in:, inner: [html.text(in.text)], onclick: None)
}

pub fn render_right(in: Badge, inner: UIRenders(a)) -> Render(a) {
  UIBadgeRender(in:, inner: [html.text(in.text), ..inner], onclick: None)
}

pub fn render_left(in: Badge, inner: UIRenders(a)) -> Render(a) {
  let inner = list.append(inner, [html.text(in.text)])

  UIBadgeRender(in:, inner:, onclick: None)
}

pub fn onclick(at: Render(a), onclick: fn(String) -> a) {
  UIBadgeRender(..at, onclick: Some(onclick))
}

pub fn view(at: Render(a)) -> UIRender(a) {
  let UIBadgeRender(in:, inner:, onclick:) = at
  let UIBadge(el:, background:, behavior:, ..) = in

  let id = el.id_get(el)
  let attrs =
    el.attrs(el)
    |> set_behavior(background, behavior)

  let onclick =
    onclick
    |> option.map(fn(onclick) { event.on_click(onclick(id)) })
    |> option.unwrap(a.none())

  html.span([onclick, ..attrs], inner)
}

// PRIVATE
//

fn set_behavior(attrs, background, behavior) {
  [
    a.classes([
      #(
        "bg-brand-50 text-brand-500 dark:bg-brand-500/15 dark:text-brand-400",
        background == BackgroundLight && behavior == BehaviorPrimary,
      ),
      #(
        "bg-success-50 text-success-500 dark:bg-success-500/15 dark:text-success-400",
        background == BackgroundLight && behavior == BehaviorSuccess,
      ),
      #(
        "bg-error-50 text-error-500 dark:bg-error-500/15 dark:text-error-400",
        background == BackgroundLight && behavior == BehaviorError,
      ),
      #(
        "bg-warning-50 text-warning-500 dark:bg-warning-500/15 dark:text-orange-400",
        background == BackgroundLight && behavior == BehaviorWarning,
      ),
      #(
        "bg-blue-light-50 text-blue-light-500 dark:bg-blue-light-500/15 dark:text-blue-light-400",
        background == BackgroundLight && behavior == BehaviorInfo,
      ),
      #(
        "bg-gray-100 text-gray-700 dark:bg-white/5 dark:text-white/80",
        background == BackgroundLight && behavior == BehaviorBright,
      ),
      #(
        "bg-gray-500 text-white dark:bg-white/5 dark:text-white",
        background == BackgroundLight && behavior == BehaviorDark,
      ),
      #(
        "bg-brand-500 text-white",
        background == BackgroundSolid && behavior == BehaviorPrimary,
      ),
      #(
        "bg-success-500 text-white",
        background == BackgroundSolid && behavior == BehaviorSuccess,
      ),
      #(
        "bg-error-500 text-white",
        background == BackgroundSolid && behavior == BehaviorError,
      ),
      #(
        "bg-warning-500 text-white",
        background == BackgroundSolid && behavior == BehaviorWarning,
      ),
      #(
        "bg-blue-light-500 text-white",
        background == BackgroundSolid && behavior == BehaviorInfo,
      ),
      #(
        "bg-gray-400 text-white dark:bg-white/5 dark:text-white/80",
        background == BackgroundSolid && behavior == BehaviorBright,
      ),
      #(
        "bg-gray-800 text-white dark:bg-white/15 dark:text-white",
        background == BackgroundSolid && behavior == BehaviorDark,
      ),
    ]),
    ..attrs
  ]
}
