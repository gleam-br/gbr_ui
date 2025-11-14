////
//// Gleam UI logotype super element.
////

import gleam/option.{type Option, None, Some}

import lustre/attribute as a
import lustre/element/html

import gbr/ui/core.{type UIRender, to_id}

type Logo =
  UILogo

/// Logotype super element.
///
pub type UILogo {
  UILogo(
    id: String,
    img: String,
    img_dark: String,
    href: Option(String),
    alt: Option(String),
  )
}

/// New logotype image super element.
///
pub fn new(id: String, img img: String, img_dark img_dark: String) -> Logo {
  UILogo(id: to_id(id), img:, img_dark:, href: None, alt: None)
}

/// Set logotype href link.
///
pub fn href(in: Logo, href: String) -> Logo {
  UILogo(..in, href: Some(href))
}

/// Set logo image alt.
///
pub fn alt(in: Logo, alt: String) -> Logo {
  UILogo(..in, alt: Some(alt))
}

/// Render logo super element to `lustre/element.{type Element}`.
///
pub fn render(in: Logo) -> UIRender(a) {
  let UILogo(id:, img:, img_dark:, href:, alt:) = in
  let href =
    option.unwrap(href, "_blank")
    |> a.href()
  let alt =
    option.unwrap(alt, "logo")
    |> a.alt()

  html.a([a.id(id), a.class(logo_class), href], [
    html.img([
      a.class(logo_img_class),
      a.src(img),
      alt,
    ]),
    html.img([
      a.class(logo_img_dark_class),
      a.src(img_dark),
      alt,
    ]),
  ])
}

// PRIVATE
//

const logo_class = "lg:hidden"

const logo_img_class = "dark:hidden"

const logo_img_dark_class = "hidden dark:block"
