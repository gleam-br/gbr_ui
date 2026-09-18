////
//// UI: Stories Typo Module (Storybook)
////

import gbr/ui/storybook
import gleam/dynamic/decode

import lustre/element/html as h

import gbr/ui/theme

import gbr/ui/showcase/components/typo
import gbr/ui/showcase/stories

pub fn view() {
  use args <- storybook.render()

  let label = storybook.decode(args, "label", "Olá mundo!", decode.string)
  let kind = storybook.decode(args, "kind", "span", decode.string)
  let size = stories.decode_field_size(args, "size", theme.SizeMd)
  let typo = case kind {
    "h1" -> typo.h1()
    "h2" -> typo.h2()
    "h3" -> typo.h3()
    "h4" -> typo.h4()
    "h5" -> typo.h5()
    "h6" -> typo.h6()
    "p" -> typo.p(size)
    "pre" -> typo.pre(size)
    "span" -> typo.span(size)
    "label" -> typo.label(size)
    _ -> typo.h1()
  }

  stories.decode_field_elevation(args, "theme.elevation", theme.ElevationFlat)
  |> typo.with_shadow(typo, _)
  |> typo.view([], [h.text(label)])
}
