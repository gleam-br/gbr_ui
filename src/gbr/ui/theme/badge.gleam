////
//// GBR: UI Admin Badge Module
////

import gleam/function
import gleam/list

import lustre/element/html as h

import gbr/ui/theme
import gbr/ui/theme/typo

pub type UIBadge {
  UIBadge(text: String, size: theme.UISize, direction: theme.UIAbsolute)
}

pub fn new(text) {
  UIBadge(text:, size: theme.SizeMd, direction: theme.AxisX(theme.Start))
}

pub fn with_text(badge, text) {
  UIBadge(..badge, text:)
}

pub fn with_direction(badge, direction) {
  UIBadge(..badge, direction:)
}

pub fn view(badge, theme, a, e) {
  let UIBadge(text:, size:, direction:) = badge

  let e =
    [h.text(text), ..e]
    |> case direction {
      theme.AxisX(theme.End) -> list.reverse
      _ -> function.identity
    }

  typo.span(theme, size, a, e)
}
