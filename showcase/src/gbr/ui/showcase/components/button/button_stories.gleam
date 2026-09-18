////
////
////

import gleam/dynamic/decode
import gleam/string

import lustre/element/html as h
import lustre/event as evt

import gbr/ui/storybook
import gbr/ui/theme

import gbr/ui/showcase/components/button
import gbr/ui/showcase/stories

pub type Msg {
  OnClickButton
}

pub fn render() {
  use args <- storybook.render()

  let kind = storybook.decode(args, "kind", "submit", decode.string)
  let button = case kind {
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

  let label =
    storybook.decode(args, "label", "Olá, clique aqui!", decode.string)
  let variant =
    stories.decode_field_variant(args, "theme.variant", theme.VariantPrimary)
  let appearance =
    stories.decode_field_appearance(
      args,
      "theme.appearance",
      theme.AppearanceFilled,
    )
  let size = stories.decode_field_size(args, "theme.size", theme.SizeMd)
  let shape = stories.decode_field_shape(args, "theme.shape", theme.ShapeSharp)
  let elevation =
    stories.decode_field_elevation(args, "theme.elevation", theme.ElevationFlat)

  button
  |> button.with_variant(variant)
  |> button.with_appearance(appearance)
  |> button.with_size(size)
  |> button.with_shape(shape |> echo)
  |> button.with_elevation(elevation)
  |> button.view([evt.on_click(OnClickButton)], [h.text(label)])
}
