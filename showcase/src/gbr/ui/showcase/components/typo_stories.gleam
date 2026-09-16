////
//// UI: Stories Typo Module (Storybook)
////

import gleam/dynamic/decode

import lustre/element/html as h

import gbr/ui/showcase/components/typo
import gbr/ui/storybook
import gbr/ui/theme

pub fn view() {
  use args <- storybook.render()

  let #(kind, size, label) = decode_args(args)
  let view = fn(view) { view([], [h.text(label)]) }

  case kind {
    "h1" -> view(typo.h1)
    "h2" -> view(typo.h2)
    "h3" -> view(typo.h3)
    "h4" -> view(typo.h4)
    "h5" -> view(typo.h5)
    "h6" -> view(typo.h6)
    "p" -> view(fn(a, e) { typo.p(size, a, e) })
    "pre" -> view(fn(a, e) { typo.pre(size, a, e) })
    "span" -> view(fn(a, e) { typo.span(size, a, e) })
    "label" -> view(fn(a, e) { typo.label(size, a, e) })
    _ -> view(typo.h1)
  }
}

fn decode_args(args) {
  let label = storybook.decode(args, "label", "Olá mundo!", decode.string)
  let kind = storybook.decode(args, "kind", "span", decode.string)
  let size = storybook.decode(args, "size", "md", decode.string)

  let size = case size {
    "xxs" -> theme.SizeXxs
    "xs" -> theme.SizeXs
    "sm" -> theme.SizeSm
    "md" -> theme.SizeMd
    "lg" -> theme.SizeLg
    "xl" -> theme.SizeXl
    "2xl" -> theme.SizeXxl
    _ -> theme.SizeMd
  }

  #(kind, size, label)
}
