////
//// Gleam UI admin typography element
////

import gleam/string

import lustre/attribute as a
import lustre/element/html

import gbr/ui/core/model.{type UIRender}
import gbr/ui/typo.{type UITypos}

/// Render horizontal typos layout.
///
pub fn horizontal(in: UITypos) -> UIRender(a) {
  let class = string.join([text_color_class, "flex items-center gap-2"], " ")

  typo.styled(in, class)
}

pub fn marker() {
  let class = string.join([text_color_class, "h-1 w-1 rounded-full"], " ")

  html.span([a.class(class)], [])
}

const text_color_class = "text-gray-800 dark:text-white"
