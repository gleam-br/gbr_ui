////
//// Gleam UI logo super element.
////

import gbr/ui/core/model.{type UIRender}
import gbr/ui/img
import gbr/ui/link

type Logo =
  UILogo

type Link =
  link.UILink

type Img =
  img.UIImg

/// Logotype super element.
///
pub opaque type UILogo {
  UILogo(href: Link, img: Img)
}

/// New logotype image super element.
///
/// - id
/// - img: href
///
pub fn new(href: String, src: String) -> Logo {
  let href = link.new(href)
  let img = img.new(src)

  UILogo(href:, img:)
}

/// Set logo icon to dark mode.
///
pub fn icon(in: Logo, icon: String) -> Logo {
  let img = img.small(in.img, icon)

  UILogo(..in, img:)
}

pub fn icon_only(in: Logo, icon_only: Bool) -> Logo {
  let img = img.small_only(in.img, icon_only)

  UILogo(..in, img:)
}

/// Set logo img to dark mode.
///
pub fn dark(in: Logo, dark: String) -> Logo {
  let img = img.dark(in.img, dark)

  UILogo(..in, img:)
}

pub fn alt(in: Logo, alt: String) -> Logo {
  let img = img.alt(in.img, alt)

  UILogo(..in, img:)
}

/// Set logotype href link.
///
pub fn href(in: Logo, href: String) -> Logo {
  let href = link.href(in.href, href)

  UILogo(..in, href:)
}

pub fn class(in: Logo, class: String) {
  let href = link.class(in.href, class)

  UILogo(..in, href:)
}

pub fn class_small(in: Logo, class: String) {
  let img = img.class_small(in.img, class)

  UILogo(..in, img:)
}

/// Render logo super element to `lustre/element.{type Element}`.
///
pub fn render(in: Logo) -> UIRender(a) {
  let UILogo(href:, img:) = in
  let img = img.at(img) |> img.render()

  link.at(href, img)
  |> link.render()
}
