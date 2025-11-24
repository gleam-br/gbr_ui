import lustre/attribute as a
import lustre/element/html

import gbr/ui/core/model.{type UIRender}
import gbr/ui/typo.{type UITypos, styled}

/// Render horizontal typos layout.
///
pub fn horizontal(in: UITypos) -> UIRender(a) {
  styled(in, "flex items-center gap-2 text-gray-500 dark:text-gray-400")
}

pub fn marker() {
  html.span([a.class("h-1 w-1 rounded-full bg-gray-400")], [])
}

const text_color_class = "text-gray-800 dark:text-white"
