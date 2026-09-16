////
//// UI: Stories Typo Module (Storybook)
////

import gleam/dynamic/decode

import gbr/ui/storybook
import gbr/ui/theme
import gbr/ui/theme/lustre
import gbr/ui/theme/lustre/typo

pub fn view() {
  use args <- storybook.render()

  let #(kind, label) = decode_args(args)

  theme.new()
  |> theme.with_size_to_tokens(fn(size) {
    [
      case size {
        theme.SizeAncestor(_) -> ""
        theme.SizeXxl -> "text-2xl "
        theme.SizeXl -> "text-xl"
        theme.SizeLg -> "text-lg"
        theme.SizeMd -> "text-md"
        theme.SizeSm -> "text-sm"
        theme.SizeXs -> "text-xs"
        theme.SizeXxs -> "text-xs"
      }
      |> lustre.Class,
    ]
  })
  |> typo.text(kind, _, label, [], [])
}

fn decode_args(args) {
  let label = storybook.decode(args, "label", decode.string, "Olá mundo!")
  let kind = storybook.decode(args, "kind", decode.string, "span")
  let size = storybook.decode(args, "size", decode.string, "md")

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

  let kind = case kind {
    "h1" -> typo.H1
    "h2" -> typo.H2
    "h3" -> typo.H3
    "h4" -> typo.H4
    "h5" -> typo.H5
    "h6" -> typo.H6
    "p" -> typo.Paragraph(size)
    "pre" -> typo.Pre(size)
    "span" -> typo.Span(size)
    "label" -> typo.Label(size)
    _ -> typo.H1
  }

  #(kind, label)
}
