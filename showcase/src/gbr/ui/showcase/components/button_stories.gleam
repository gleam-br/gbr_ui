////
////
////

import gleam/dynamic/decode
import gleam/string

import lustre/element/html as h
import lustre/event as evt

import gbr/ui/showcase/components/button
import gbr/ui/theme as ui
import gbr/ui/theme/lustre

import gbr/ui/storybook

pub type Msg {
  OnClickButton
}

pub fn render() {
  use args <- storybook.render()

  let label =
    storybook.decode(args, "label", "Olá, clique aqui!", decode.string)
  let kind = storybook.decode(args, "kind", "submit", decode.string)
  let variant = storybook.decode(args, "variant", "primary", decode.string)
  let size = storybook.decode(args, "size", "md", decode.string)

  let kind = case kind {
    "normal" -> button.normal()
    "reset" -> button.reset()
    "link" -> {
      let href = storybook.decode(args, "href", "#/", decode.string)
      let target =
        storybook.decode(args, "target", "", decode.string)
        |> string.to_option()

      button.link(href, target)
    }
    _ -> button.submit()
  }

  let variant = case variant {
    "primary" -> button.primary(kind)
    "secondary" -> button.secondary(kind)
    "tertiary" -> button.tertiary(kind)
    _ -> kind
  }

  let size = case size {
    "xxs" -> button.size(variant, ui.SizeXxs)
    "xs" -> button.size(variant, ui.SizeXs)
    "sm" -> button.size(variant, ui.SizeSm)
    "md" -> button.size(variant, ui.SizeMd)
    "lg" -> button.size(variant, ui.SizeLg)
    "xl" -> button.size(variant, ui.SizeXl)
    "2xl" -> button.size(variant, ui.SizeXxl)
    _ -> button.size(variant, ui.SizeMd)
  }

  button.view(size, [evt.on_click(OnClickButton)], [h.text(label)])
}
