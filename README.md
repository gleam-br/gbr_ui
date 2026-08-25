[![Package Version](https://img.shields.io/hexpm/v/gbr_ui)](https://hex.pm/packages/gbr_ui)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/gbr_ui/)

# 📺 GleamBR UI Lustre library

[Gleam](https://gleam.run/) UI [lustre](https://lustre.build/) library by @gleam-br

## Como usar?

```gleam
import lustre/element as el

import gbr/ui/theme

pub fn div_container(state) -> el.Element(msg) {
  // theme design
  let variant = theme.primary()
  let appearance = theme.filled()

  // theme create
  let theme =
    theme.new()
    |> theme.with_design_to_tokens(design_classes)
    |> theme.with_variant(variant:)
    |> theme.with_appearance(appearance:)
    |> theme.with_state(state:)

  // typo view with theme
  theme.div(theme:, attributes: [], elements: [])
}

fn design_classes(variant v, appearance a, state s) {
  case v, a, s {
    theme.VariantPrimary, theme.AppearanceFilled, _ -> [
      theme.Class("bg-primary-500"),
      theme.Classes([
        #("bg-primary-500 border border-red", s == theme.StateError),
      ]),
    ]
    _, _, _ -> [
      theme.Class("bg-secondary-500"),
      theme.Classes([ #("bg-orange-500", s == theme.StateError) ]),
    ]
  }
}
```

**Outro exemplo:** Um título utilizando o módulo auxiliar `typo`.

```gleam
import lustre/element as el

import gbr/ui/theme
import gbr/ui/theme/typo

pub fn title(state) -> el.Element(msg) {
  // typography type
  let title = typo.H2
  // theme design
  let variant = theme.primary()
  let appearance = theme.filled()
  // theme create
  let theme =
    theme.new()
    |> theme.with_design_to_tokens(design_classes)
    |> theme.with_variant(variant:)
    |> theme.with_appearance(appearance:)
    |> theme.with_state(state:)

  // typo view with theme
  typo.view(title, theme:, attributes: [], elements: [])
}

fn design_classes(variant v, appearance a, state s) {
  case v, a, s {
    theme.VariantPrimary, theme.AppearanceFilled, theme.StateHover ->[
      theme.Class("hover:text-primary-600 text-primary-500"),
    ]

    theme.VariantPrimary, theme.AppearanceFilled, _ -> [
      theme.Classes([
        #("text-primary-500", s == theme.StateIdle),
        #("text-error-500", s == theme.StateError),
        #("text-blue-light-500", s == theme.StateInfo),
      ])
    ]
    _, _, _ -> [
      theme.Classes([
        #("text-secondary-500", s == theme.StateIdle),
        #("text-orange-500", s == theme.StateError),
      ])
  }
}
```
