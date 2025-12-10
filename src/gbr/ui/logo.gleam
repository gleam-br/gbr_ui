////
//// Gleam UI logo super element.
////

import gbr/ui/core/el
import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/element

import lustre/element/html

import gbr/ui/core/model.{type UIRender}

import gbr/ui/img
import gbr/ui/link
import gbr/ui/typo

type Logo =
  UILogo

type Link =
  link.UILink

type Img =
  img.UIImg

type Typos =
  typo.UITypos

/// Logotype super element.
///
/// - href: Link location on clicked
/// - img: Image super element info
///
pub opaque type UILogo {
  UILogo(el: el.UIEl, href: Link, img: Option(Img), text: Option(Typos))
}

/// New logotype image super element.
///
/// - href: Link location on clicked
///
pub fn new(href: String) -> Logo {
  let el = el.new("logo")
  let href = link.new(href)

  UILogo(el:, href:, img: None, text: None)
}

/// Set typos to logo text
///
/// - text: `gbr/ui/typo` list to show logo text
///
pub fn text(in: Logo, text: Typos) -> Logo {
  UILogo(..in, text: Some(text))
}

/// Set logo img
///
/// This function always create a new `gbr/ui/img` element.
///
/// - src: Image source path `lustre/attribute.src`
///
pub fn src(in: Logo, src: String) -> Logo {
  let img = img.new(src)

  UILogo(..in, img: Some(img))
}

/// Set logo icon to dark mode.
///
pub fn icon(in: Logo, icon: String) -> Logo {
  let img = option.map(in.img, img.small(_, icon))

  UILogo(..in, img:)
}

/// Set logo icon only show
///
/// - icon_only: If show only icon or not
///
pub fn icon_only(in: Logo, icon_only: Bool) -> Logo {
  let img = option.map(in.img, img.small_only(_, icon_only))

  UILogo(..in, img:)
}

/// Set logo img to dark mode.
///
pub fn src_dark(in: Logo, dark: String) -> Logo {
  let img = option.map(in.img, img.dark(_, dark))

  UILogo(..in, img:)
}

/// Set logo img alt text
///
pub fn alt(in: Logo, alt: String) -> Logo {
  let img = option.map(in.img, img.alt(_, alt))

  UILogo(..in, img:)
}

/// Set logotype href link.
///
pub fn href(in: Logo, href: String) -> Logo {
  let href = link.href(in.href, href)

  UILogo(..in, href:)
}

/// Set logo class attribute
///
pub fn class(in: Logo, class: String) -> Logo {
  let href = link.class(in.href, class)

  UILogo(..in, href:)
}

/// Set log content class attribute
///
pub fn class_content(in: Logo, class: String) -> Logo {
  let el = el.class(in.el, class)

  UILogo(..in, el:)
}

/// Set logo small class attribute
///
pub fn class_small(in: Logo, class: String) {
  let img = option.map(in.img, img.class_small(_, class))

  UILogo(..in, img:)
}

/// Render logo super element to `lustre/element.{type Element}`.
///
pub fn view(in: Logo) -> UIRender(a) {
  let UILogo(el:, href:, img:, text:) = in
  let icon_only =
    option.map(img, img.is_small_only)
    |> option.unwrap(False)
  let text = case icon_only {
    False ->
      option.map(text, typo.styled(_, "inline-block align-middle items-center"))
      // |> option.unwrap([])
      |> option.unwrap(element.none())
    // True -> []
    True -> element.none()
  }
  let img =
    option.map(img, img.render)
    |> option.map(img.view)
    |> option.unwrap([])

  // todo orientation (left or right)
  // let inner = list.append(img, text)
  let inner = list.reverse([text, ..img])
  let inner = html.div(el.attrs(el), inner)

  link.render(href, [inner])
  |> link.view()
}
