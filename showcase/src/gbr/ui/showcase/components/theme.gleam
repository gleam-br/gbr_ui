////
////
////

import gleam/option.{Some}

import gbr/ui/theme as ui
import gbr/ui/theme/lustre/tailwind/token

pub fn new_typo_theme(is_header) {
  ui.new()
  |> ui.with_size_to_tokens(size_text_tokens(_, is_header))
}

pub fn size_text_tokens(size, is_header) {
  let fx = token.size_text_to_classes(is_header)
  [fx(size)]
}

pub fn new_layout_flow_items(main, items) {
  ui.new()
  |> layout_flex(ui.FlowItems(main, items))
}

pub fn layout_flow_items(theme, main, items) {
  layout_flex(theme, ui.FlowItems(main, items))
}

pub fn layout_flex(theme, layout) {
  theme
  |> ui.with_layout(Some(ui.LayoutFlow(layout)))
  |> ui.with_layout_to_tokens(token.layout_flex_tokens)
}

pub fn layout_grid(theme, layout) {
  theme
  |> ui.with_layout(Some(ui.LayoutFlow(layout)))
  |> ui.with_layout_to_tokens(token.layout_grid_tokens)
}
