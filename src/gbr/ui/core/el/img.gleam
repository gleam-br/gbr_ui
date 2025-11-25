////
//// Gleam UI image super element
////

import gleam/option.{type Option, None}

import lustre/attribute as a
import lustre/element/html

import gbr/ui/core/el
import gbr/ui/core/model.{type UIRenders}

type Img =
  UIImg

type Render(a) =
  UIImgRender(a)

pub opaque type UIImg {
  UIImg(el: el.UIEl, src: String, dark: String, small: String, small_only: Bool)
}

pub opaque type UIImgRender(a) {
  UIImgRender(in: Img, onclick: Option(a))
}

pub fn new(src: String) -> Img {
  UIImg(el: el.new("img"), src:, dark: src, small: src, small_only: False)
}

pub fn alt(in: Img, alt: String) -> Img {
  let el = el.att(in.el, [#("alt", alt)])

  UIImg(..in, el:)
}

pub fn dark(in: Img, dark: String) -> Img {
  UIImg(..in, dark:)
}

pub fn small(in: Img, small: String) -> Img {
  UIImg(..in, small:)
}

pub fn small_only(in: Img, small_only: Bool) -> Img {
  UIImg(..in, small_only:)
}

pub fn class(in: Img, class: String) -> Img {
  let el = el.class(in.el, class)

  UIImg(..in, el:)
}

pub fn class_src(in: Img, class: String) -> Img {
  let el = el.class_key(in.el, "src", class)

  UIImg(..in, el:)
}

pub fn class_dark(in: Img, class: String) -> Img {
  let el = el.class_key(in.el, "dark", class)

  UIImg(..in, el:)
}

pub fn class_small(in: Img, class: String) -> Img {
  let el = el.class_key(in.el, "small", class)

  UIImg(..in, el:)
}

pub fn at(in: Img) -> Render(a) {
  UIImgRender(in:, onclick: None)
}

pub fn render(at: Render(a)) -> UIRenders(a) {
  let UIImgRender(in:, ..) = at
  let UIImg(el:, src:, dark:, small:, small_only:) = in

  let attrs = el.attrs(el)
  let attrs_src = el.attrs_key(el, "dark")
  let attrs_dark = el.attrs_key(el, "dark")
  let attrs_small = el.attrs_key(el, "small")

  // toggle small only
  let classes = a.classes([#("hidden", small_only)])

  [
    html.span([classes, ..attrs], [
      html.img([a.src(src), a.class("dark:hidden"), ..attrs_src]),
      html.img([a.src(dark), a.class("hidden dark:block"), ..attrs_dark]),
    ]),
    html.img([
      a.src(small),
      a.classes([#("lg:block", small_only), #("hidden", !small_only)]),
      ..attrs_small
    ]),
  ]
}
