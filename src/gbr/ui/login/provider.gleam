////
//// Gleam UI login provider super element.
////
//// Button to signin with providers like google, github, etc.
////

import gleam/list
import gleam/option.{type Option, None, Some}

import lustre/attribute as a
import lustre/element/html

import gbr/ui/link
import gbr/ui/svg.{type Svg}

import gbr/ui/core.{type UILink, type UIRender, UILink, uilink}

type Provider =
  UIProvider

type Providers =
  List(Provider)

/// Provider super element.
///
pub opaque type UIProvider {
  UIProvider(link: UILink, svg: Option(Svg), redirect: Option(String))
}

/// Render login profile signin button.
///
pub fn render(in: Provider) -> UIRender(a) {
  let UIProvider(link:, svg:, ..) = in
  let UILink(href:, title:) = link
  let inner = case svg {
    Some(svg) -> [svg.render(svg)]
    None -> []
  }

  uilink(href, title)
  |> link.new()
  |> link.signin()
  |> link.at_left(inner)
  |> link.render()
}

/// Render grouped list of provider sigin buttons.
///
pub fn grouped(in: Providers) -> UIRender(a) {
  html.div(
    [a.class("grid grid-cols-1 gap-3 sm:grid-cols-2 sm:gap-5")],
    providers(in),
  )
}

// PRIVATE
//

fn providers(providers) {
  use provider <- list.map(providers)

  render(provider)
}
