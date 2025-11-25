////
//// Gleam UI admin avatar super element
////
//// **TODO: el.UIEl**
////

import gleam/option.{type Option, None, Some}
import gleam/string

import lustre/attribute as a
import lustre/element
import lustre/element/html

type Avatar =
  UIAvatar

type State =
  Option(String)

type Size {
  Size(classes: String, indicator: String)
}

pub opaque type UIAvatar {
  UIAvatar(img: String, size: Size, state: State)
}

pub fn new(img: String) {
  UIAvatar(img:, size: md_(), state: None)
}

pub fn success(avatar: Avatar) {
  UIAvatar(..avatar, state: Some("bg-success-500"))
}

pub fn alert(avatar: Avatar) {
  UIAvatar(..avatar, state: Some("bg-warning-500"))
}

pub fn offline(avatar: Avatar) {
  UIAvatar(..avatar, state: Some("bg-error-500"))
}

pub fn xs(in: Avatar) {
  UIAvatar(..in, size: xs_())
}

pub fn sm(in: Avatar) {
  UIAvatar(..in, size: sm_())
}

pub fn md(in: Avatar) {
  UIAvatar(..in, size: md_())
}

pub fn lg(in: Avatar) {
  UIAvatar(..in, size: lg_())
}

pub fn xl(in: Avatar) {
  UIAvatar(..in, size: xl_())
}

pub fn xxl(in: Avatar) {
  UIAvatar(..in, size: xxl_())
}

pub fn render(avatar: Avatar) {
  let UIAvatar(img:, size:, state:) = avatar

  html.span([a.class(avatar_class(size))], [
    html.img([
      a.class("overflow-hidden rounded-full"),
      a.src(img),
      a.alt("Avatar"),
    ]),
    case state {
      Some(classes) ->
        html.span(
          [
            a.class(classes),
            a.class(size.indicator),
            a.class(state_class),
          ],
          [],
        )
      None -> element.none()
    },
  ])
}

// PRIVATE
//

fn xs_() {
  Size("max-w-6 h-6", "max-w-2 h-2")
}

fn sm_() {
  Size("max-w-8 h-8", "max-w-2.5 h-2.5")
}

fn md_() {
  Size("max-w-10 h-10", "max-w-3 h-3")
}

fn lg_() {
  Size("max-w-12 h-12", "max-w-3.5 h-3.5")
}

fn xl_() {
  Size("max-w-14 h-14", "max-w-4 h-4")
}

fn xxl_() {
  Size("max-w-16 h-16", "max-w-4.5 h-4.5")
}

fn avatar_class(size: Size) {
  string.join(["relative w-full", size.classes, "rounded-full"], " ")
}

const state_class = "absolute bottom-0 right-0 w-full rounded-full border-[1.5px] border-white dark:border-gray-900"
