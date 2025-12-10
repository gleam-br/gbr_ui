////
////
////

import gbr/ui/admin/button
import gleam/option.{type Option, None, Some}

import lustre/attribute as a
import lustre/element
import lustre/element/html

import gbr/ui/svg
import gbr/ui/typo

import gbr/ui/core/el
import gbr/ui/core/model.{type UIRender}

// Alias
//

type Card =
  UICard

type Render(a) =
  UICardRender(a)

///
///
pub opaque type UICard {
  UICard(
    content: typo.UITypo,
    title: Option(typo.UITypo),
    img: Option(el.UIEl),
    svg: Option(svg.Identity),
    horizontal: Bool,
  )
}

///
///
pub opaque type UICardRender(a) {
  UICardRender(in: Card)
}

///
///
pub fn new(content: String) -> Card {
  let content =
    typo.p(content)
    |> typo.class("text-sm text-gray-500 dark:text-gray-400")

  UICard(content:, title: None, img: None, svg: None, horizontal: False)
}

///
///
pub fn title(in: Card, title: String) -> Card {
  let title =
    typo.h4(title)
    |> typo.class(
      "mb-1 text-theme-xl font-medium text-gray-800 dark:text-white/90",
    )
    |> Some()

  UICard(..in, title:)
}

///
///
pub fn img(in: Card, img: String, alt: String) -> Card {
  let img =
    el.new("card-img")
    |> el.att([#("src", img), #("alt", alt)])
    |> el.class("overflow-hidden rounded-lg")
    |> Some()

  UICard(..in, img:, svg: None)
}

///
///
pub fn svg(in: Card, svg: svg.Identity) -> Card {
  UICard(..in, svg: Some(svg), img: None)
}

///
///
pub fn horizontal(in: Card, horizontal: Bool) {
  UICard(..in, horizontal:)
}

///
///
pub fn render(in: Card) -> Render(a) {
  UICardRender(in:)
}

pub fn view(at: Render(a)) -> UIRender(a) {
  let UICardRender(in:) = at
  let UICard(content:, title:, img:, svg:, horizontal:) = in

  let content = typo.view(content)
  let title = render_title(title)
  let img = render_img(img)
  let svg = render_svg(svg)

  let link =
    button.new("btn-read-more")
    |> button.label("Read more")
    |> button.primary()
    |> button.class("mt-4")
    |> button.render()
    |> button.view()

  html.div([], [
    html.div(
      [
        a.classes([
          #(
            "flex flex-col gap-5 rounded-xl border border-gray-200 bg-white p-4 "
              <> "dark:border-gray-800 dark:bg-white/[0.03] sm:flex-row sm:items-center sm:gap-6",
            horizontal,
          ),
          #(
            "rounded-xl border border-gray-200 bg-white p-5 dark:border-gray-800 dark:bg-white/[0.03] sm:p-6",
            !horizontal,
          ),
        ]),
      ],
      [
        img,
        html.div([], [
          svg,
          title,
          content,
          link,
        ]),
      ],
    ),
  ])
}

fn render_img(img) {
  img
  |> option.map(img_view)
  |> option.unwrap(element.none())
}

fn render_svg(svg) {
  svg
  |> option.map(svg_view)
  |> option.unwrap(element.none())
}

fn render_title(title) {
  title
  |> option.map(typo.view)
  |> option.unwrap(element.none())
}

fn svg_view(svg) {
  html.div(
    [
      a.class(
        "mb-5 flex h-14 max-w-14 items-center justify-center rounded-[10.5px] bg-brand-50 text-brand-500 dark:bg-brand-500/10",
      ),
    ],
    [
      svg.new(28, 28)
      |> svg()
      |> svg.view(),
    ],
  )
}

fn img_view(img) {
  let attrs = el.attrs(img)

  html.div([a.class("mb-5 overflow-hidden rounded-lg")], [
    html.img(attrs),
  ])
}
