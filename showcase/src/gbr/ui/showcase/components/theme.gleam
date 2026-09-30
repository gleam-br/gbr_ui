////
////
////

import gleam/option.{Some}

import gbr/ui/theme as ui
import gbr/ui/theme/lustre
import gbr/ui/theme/lustre/tailwind/token

pub fn new_button_theme() {
  ui.new()
  |> ui.with_base_to_tokens(fn() {
    [
      lustre.Class(
        "cursor-pointer border border-shadow-1 border-1 border-gray-800 w-full",
      ),
    ]
  })
  |> ui.with_design_to_tokens(button_design_tokens)
  |> ui.with_size_to_tokens(button_size_tokens)
}

fn button_size_tokens(s) {
  [
    case s {
      ui.SizeXxl -> lustre.Class("h-24")
      ui.SizeXl -> lustre.Class("h-20")
      ui.SizeLg -> lustre.Class("h-18")
      ui.SizeMd -> lustre.Class("h-16")
      ui.SizeSm -> lustre.Class("h-14")
      ui.SizeXs -> lustre.Class("h-12")
      ui.SizeXxs -> lustre.Class("h-10")
    },
    ..size_text_tokens(s, token.TextBase)
  ]
}

fn button_design_tokens(v, a, s) {
  [
    case v, a, s {
      ui.VariantPrimary, _, _ -> lustre.Class("bg-green-500 dark:bg-green-300")
      ui.VariantSecondary, _, _ ->
        lustre.Class("bg-amber-200 dark:bg-amber-300")
      ui.VariantTertiary, _, _ ->
        lustre.Class("bg-gray-900 dark:bg-black-300 text-white")
      _, _, _ -> lustre.Class("bg-gray-600 border-gray-900")
    },
  ]
}

pub fn new_typo_theme(is_header) {
  ui.new()
  |> ui.with_size_to_tokens(size_text_tokens(_, is_header))
}

pub fn size_text_tokens(size, is_header) {
  let to_token = token.size_text_to_classes(is_header)

  [to_token(size)]
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
