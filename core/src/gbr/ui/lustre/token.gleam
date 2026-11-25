//// GBR: UI Lustre Token

import gbr/ui/lustre
import gbr/ui/lustre/internal/token_layout
import gbr/ui/lustre/internal/token_scale
import gbr/ui/theme

/// Retorna o token da superfície do tema em arredondamento do tailwind.
pub fn shape_rounded_to_tokens(shape: theme.UIShape) {
  token_scale.shape_rounded_to_tokens(shape)
}

pub fn size_layout_to_rounded_tokens(size, layout) {
  token_scale.size_layout_to_rounded_tokens(size, layout)
}

pub fn size_layout_flow_to_rounded_token(
  size: theme.UISize,
  layout: theme.UIFlow,
) {
  token_scale.size_layout_flow_to_rounded_token(size, layout)
}

pub fn size_alignment_to_rounded_token(
  size: theme.UISize,
  alignment: theme.UIAlignment,
) {
  token_scale.size_alignment_to_rounded_token(size, alignment)
}

pub fn size_absolute_to_rounded_tokens(
  size: theme.UISize,
  absolute: theme.UIAbsolute,
) {
  token_scale.size_absolute_to_rounded_tokens(size, absolute)
}

pub fn size_to_rounded_all(size: theme.UISize) {
  token_scale.rounded_class("rounded-", size)
}

pub fn size_to_rounded_top(size: theme.UISize) {
  token_scale.rounded_class("rounded-t-", size)
}

pub fn size_to_rounded_bottom(size: theme.UISize) {
  token_scale.rounded_class("rounded-b-", size)
}

pub fn size_to_rounded_left(size: theme.UISize) {
  token_scale.rounded_class("rounded-l-", size)
}

pub fn size_to_rounded_right(size: theme.UISize) {
  token_scale.rounded_class("rounded-r-", size)
}

pub fn size_to_rounded_top_left(size: theme.UISize) {
  token_scale.rounded_class("rounded-tl-", size)
}

pub fn size_to_rounded_top_right(size: theme.UISize) {
  token_scale.rounded_class("rounded-tr-", size)
}

pub fn size_to_rounded_bottom_left(size: theme.UISize) {
  token_scale.rounded_class("rounded-bl-", size)
}

pub fn size_to_rounded_bottom_right(size: theme.UISize) {
  token_scale.rounded_class("rounded-br-", size)
}

pub fn size_to_rounded_start(size: theme.UISize) {
  token_scale.rounded_class("rounded-s-", size)
}

pub fn size_to_rounded_end(size: theme.UISize) {
  token_scale.rounded_class("rounded-e-", size)
}

pub fn size_to_rounded_start_start(size: theme.UISize) {
  token_scale.rounded_class("rounded-ss-", size)
}

pub fn size_to_rounded_start_end(size: theme.UISize) {
  token_scale.rounded_class("rounded-se-", size)
}

pub fn size_to_rounded_end_start(size: theme.UISize) {
  token_scale.rounded_class("rounded-es-", size)
}

pub fn size_to_rounded_end_end(size: theme.UISize) {
  token_scale.rounded_class("rounded-ee-", size)
}

/// Converte a elevação do tema em bordas tailwind.
pub fn elevation_to_shadow_border_tokens(elevation) {
  token_scale.elevation_to_shadow_border_tokens(elevation)
}

pub fn elevation_to_text_shadow_tokens(elevation) {
  token_scale.elevation_to_text_shadow_tokens(elevation)
}

pub fn size_layout_to_border_tokens(size, layout) {
  token_scale.size_layout_to_border_tokens(size, layout)
}

pub fn size_layout_flow_to_border_token(
  size: theme.UISize,
  layout: theme.UIFlow,
) {
  token_scale.size_layout_flow_to_border_token(size, layout)
}

pub fn size_alignment_to_border_token(
  size: theme.UISize,
  alignment: theme.UIAlignment,
) {
  token_scale.size_alignment_to_border_token(size, alignment)
}

pub fn size_absolute_to_border_tokens(
  size: theme.UISize,
  absolute: theme.UIAbsolute,
) {
  token_scale.size_absolute_to_border_tokens(size, absolute)
}

pub fn size_to_border_all(size: theme.UISize) {
  token_scale.border_class("border-", size)
}

pub fn size_to_border_top(size: theme.UISize) {
  token_scale.border_class("border-t-", size)
}

pub fn size_to_border_bottom(size: theme.UISize) {
  token_scale.border_class("border-b-", size)
}

pub fn size_to_border_left(size: theme.UISize) {
  token_scale.border_class("border-l-", size)
}

pub fn size_to_border_right(size: theme.UISize) {
  token_scale.border_class("border-r-", size)
}

pub fn size_to_border_top_left(size: theme.UISize) {
  token_scale.border_class("border-tl-", size)
}

pub fn size_to_border_top_right(size: theme.UISize) {
  token_scale.border_class("border-tr-", size)
}

pub fn size_to_border_bottom_left(size: theme.UISize) {
  token_scale.border_class("border-bl-", size)
}

pub fn size_to_border_bottom_right(size: theme.UISize) {
  token_scale.border_class("border-br-", size)
}

pub fn size_to_border_start(size: theme.UISize) {
  token_scale.border_class("border-s-", size)
}

pub fn size_to_border_end(size: theme.UISize) {
  token_scale.border_class("border-e-", size)
}

pub fn size_to_border_start_start(size: theme.UISize) {
  token_scale.border_class("border-ss-", size)
}

pub fn size_to_border_start_end(size: theme.UISize) {
  token_scale.border_class("border-se-", size)
}

pub fn size_to_border_end_start(size: theme.UISize) {
  token_scale.border_class("border-es-", size)
}

pub fn size_border_end_end(size: theme.UISize) {
  token_scale.border_class("border-ee-", size)
}

/// Converte o empilhamento do tema no 'z-index' do tailwind.
pub fn stack_to_zindex_tokens(stacking: theme.UIStacking) {
  [stack_to_zindex_token(stacking)]
}

pub fn stack_to_zindex_token(stacking: theme.UIStacking) {
  token_layout.stack_to_zindex_token(stacking)
}

pub type TextToken {
  TextBase
  TextTheme
  TextTitle
}

pub fn size_text_to_classes(text_token) {
  fn(size) {
    case size {
      theme.SizeXxl -> [
        #("text-theme-2xl sm:text-theme-4xl", text_token == TextTheme),
        #("text-title-2xl sm:text-title-4xl", text_token == TextTitle),
        #("text-xl sm:text-2xl", text_token == TextBase),
      ]
      theme.SizeXl -> [
        #("text-theme-xl sm:text-theme-2xl", text_token == TextTheme),
        #("text-title-xl sm:text-title-2xl", text_token == TextTitle),
        #("text-lg sm:text-xl", text_token == TextBase),
      ]
      theme.SizeLg -> [
        #("text-theme-lg sm:text-theme-xl", text_token == TextTheme),
        #("text-title-lg sm:text-title-xl", text_token == TextTitle),
        #("text-theme-md sm:text-lg", text_token == TextBase),
      ]
      theme.SizeMd -> [
        #("text-theme-md sm:text-theme-lg", text_token == TextTheme),
        #("text-title-md sm:text-title-lg", text_token == TextTitle),
        #("text-sm sm:text-theme-md", text_token == TextBase),
      ]
      theme.SizeSm -> [
        #("text-theme-sm sm:text-theme-md", text_token == TextTheme),
        #("text-title-sm sm:text-title-md", text_token == TextTitle),
        #("text-sm", text_token == TextBase),
      ]
      theme.SizeXxs | theme.SizeXs -> [
        #("text-theme-xs sm:text-theme-sm", text_token == TextTheme),
        #("text-title-xs sm:text-title-sm", text_token == TextTitle),
        #("text-xs sm:text-xs", text_token == TextBase),
      ]
    }
    |> lustre.Classes
  }
}

/// Retona o tamanho do tema em tamanho de texto do tailwind.
pub fn size_text_to_class(size: theme.UISize) {
  token_layout.size_text_to_class(size)
}

pub fn size_icon_height_class(size) {
  token_layout.size_icon_height_class(size)
}

pub fn size_icon_width_class(size) {
  token_layout.size_icon_width_class(size)
}

pub fn size_icon_max_height_class(size) {
  token_layout.size_icon_max_height_class(size)
}

pub fn size_icon_max_width_class(size) {
  token_layout.size_icon_max_width_class(size)
}

pub fn size_to_shadown_token(size) {
  token_layout.size_to_shadown_token(size)
}

pub fn layout_flex_tokens(layout) {
  [layout_flex_class(), ..layout_to_tokens(layout)]
}

pub fn layout_grid_tokens(layout) {
  [layout_flex_class(), ..layout_to_tokens(layout)]
}

pub fn layout_to_tokens(layout: theme.UILayout) {
  token_layout.layout_to_tokens(layout)
}

/// Tema de layout para tokens tailwind.
pub fn layout_flow_to_tokens(layout: theme.UIFlow) -> List(lustre.UILustre) {
  token_layout.layout_flow_to_tokens(layout)
}

pub fn alignment_to_items_tokens(align: theme.UIAlignment) {
  [alignment_to_items_token(align)]
}

/// Alinhamento dos itens no eixo transversal (align-items)
pub fn alignment_to_items_token(align: theme.UIAlignment) {
  token_layout.alignment_to_items_token(align)
}

pub fn alignment_to_content_tokens(align: theme.UIAlignment) {
  [alignment_to_content_token(align)]
}

/// A intenção de alinhamento no eixo transversal (align-content)
pub fn alignment_to_content_token(align: theme.UIAlignment) {
  token_layout.alignment_to_content_token(align)
}

pub fn alignment_to_justify_tokens(align: theme.UIAlignment) {
  [alignment_to_justify_token(align)]
}

/// A intenção de alinhamento no eixo principal (justify-content)
pub fn alignment_to_justify_token(align: theme.UIAlignment) {
  token_layout.alignment_to_justify_token(align)
}

pub fn new_layout_absolute_x_top() {
  new_layout_absolute_x(theme.Start)
}

pub fn new_layout_absolute_x_bottom() {
  new_layout_absolute_x(theme.End)
}

pub fn new_layout_absolute_x(x) {
  theme.AxisX(x)
  |> theme.LayoutAbsolute
}

pub fn new_layout_absolute_y(y) {
  theme.AxisY(y)
  |> theme.LayoutAbsolute
}

pub fn new_layout_absolute_y_left() {
  new_layout_absolute_y(theme.Start)
}

pub fn new_layout_absolute_y_right() {
  new_layout_absolute_y(theme.End)
}

/// Processa o modelo de posicionamento absoluto, injetando a classe 'absolute'.
pub fn absolute_to_layout_token(absolute: theme.UIAbsolute) {
  token_layout.absolute_to_layout_token(absolute)
}

/// Processa o eixo X absoluto.
/// - Nota: Center usa o translate para centralização.
pub fn horizontal_to_layout_token(x: theme.UIAlignment) {
  token_layout.horizontal_to_layout_token(x)
}

/// Processa o eixo Y absoluto.
pub fn vertical_to_layout_token(y: theme.UIAlignment) {
  token_layout.vertical_to_layout_token(y)
}

pub fn layout_flex_class() {
  lustre.Class("flex")
}

pub fn layout_grid_class() {
  lustre.Class("grid")
}

pub fn layout_sticky_class() {
  lustre.Class("sticky")
}

pub fn layout_flex_row_class() {
  lustre.Class("flex flex-row")
}

pub fn layout_flex_col_class() {
  lustre.Class("flex flex-col")
}

pub fn layout_flex_inline_class() {
  lustre.Class("inline-flex")
}

pub fn block_hidden_classes(is_block) {
  lustre.Classes([#("block", is_block), #("hidden", !is_block)])
}

pub fn rotate_classes(is_rotate) {
  lustre.Classes([#("rotate-180", is_rotate)])
}

/// Estado de carregamento.
pub fn aria_busy(is_loading: Bool) {
  case is_loading {
    True -> lustre.Attribute("aria-busy", "true")
    False -> lustre.Attribute("aria-busy", "false")
  }
}

/// Descrever elementos visuais (ex: imagens) em leitores de tela.
pub fn aria_label(label: String) {
  lustre.Attribute("aria-label", label)
}

/// Descrever elementos usando ref. a outro elemento, exemplo `<h2 id="..." />`.
pub fn aria_labelledby(id: String) {
  lustre.Attribute("aria-labelledby", id)
}

/// Ocultar elementos visuais (ex: ícones decorativos) de leitores de tela.
pub fn aria_hidden() {
  lustre.Attribute("aria-hidden", "true")
}

/// Indica se o componente está expandido ou não, útil para sidebar menu.
pub fn aria_expanded(expand: Bool) {
  case expand {
    True -> lustre.Attribute("aria-expanded", "true")
    False -> lustre.Attribute("aria-expanded", "false")
  }
}
