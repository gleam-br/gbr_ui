////
//// Gleam UI logotype super element.
////

import lustre/attribute as a
import lustre/element/html

import gbr/ui/core/model.{type UIRender, random_str}

type Logo =
  UILogo

/// Logotype super element.
///
pub opaque type UILogo {
  UILogo(
    id: String,
    img: String,
    img_dark: String,
    icon: String,
    href: String,
    alt: String,
    icon_only: Bool,
  )
}

/// New logotype image super element.
///
/// - id
/// - img: href
///
pub fn new(id: String, img: String) -> Logo {
  UILogo(
    id: random_str(id),
    img:,
    img_dark: img,
    icon: img,
    href: "",
    alt: "",
    icon_only: False,
  )
}

/// Set logo icon to dark mode.
///
pub fn icon(in: Logo, icon) -> Logo {
  UILogo(..in, icon:)
}

/// Set logo img to dark mode.
///
pub fn dark(in: Logo, img_dark: String) -> Logo {
  UILogo(..in, img_dark:)
}

/// Set logotype href link.
///
pub fn href(in: Logo, href: String) -> Logo {
  UILogo(..in, href:)
}

/// Set logo image alt.
///
pub fn alt(in: Logo, alt: String) -> Logo {
  UILogo(..in, alt:)
}

/// Set icon only to small logo
///
pub fn icon_only(in: Logo, icon_only: Bool) -> Logo {
  UILogo(..in, icon_only:)
}

/// Render logo super element to `lustre/element.{type Element}`.
///
pub fn render(in: Logo) -> UIRender(a) {
  let UILogo(id:, img:, img_dark:, href:, alt:, icon:, icon_only:) = in

  html.a(
    [
      a.id(id),
      a.href(href),
    ],
    [
      html.span(
        [
          a.class("logo"),
          a.classes([#("hidden", icon_only)]),
        ],
        [
          html.img([
            a.alt(alt),
            a.src(img),
            a.class("dark:hidden"),
          ]),
          html.img([
            a.alt(alt),
            a.src(img_dark),
            a.class("hidden dark:block"),
          ]),
        ],
      ),
      html.img([
        a.alt(alt),
        a.src(icon),
        a.class("logo-icon"),
        a.classes([#("lg:block", icon_only), #("hidden", !icon_only)]),
      ]),
    ],
  )
}
