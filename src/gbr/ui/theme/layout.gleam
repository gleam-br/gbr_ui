////
//// GBR: UI Theme Layout Module
////

import gbr/ui/theme
import gbr/ui/theme/token/tailwind

/// Tipo de layout
///
pub type Layout {
  Flex(Flex)
  Grid
}

/// Espelhamento tailwind 'flex'
pub type Flex {
  Row
  Col
  Inline
}

/// Conversor p/ os tokens tailwind baseado no `Layout`.
///
pub fn layout(layout: Layout) {
  case layout {
    Grid -> tailwind.layout_grid_class()
    Flex(layout) -> layout_flex(layout)
  }
}

/// Retorna os tokens a partir do layout flex.
///
pub fn layout_flex(layout: Flex) {
  case layout {
    Row -> tailwind.layout_flex_row_class()
    Col -> tailwind.layout_flex_col_class()
    Inline -> tailwind.layout_flex_inline_class()
  }
}

// ==========================================
//
// 🧱 TAILWIND BASE LAYOUTS (DIV)
//
// ==========================================

/// Flex row layout.
///
pub fn row(theme, layout, attributes, inner elements) {
  container_base(theme, Flex(Row), layout, attributes, elements)
}

/// Flex col layout.
///
pub fn col(theme, layout, attributes, inner elements) {
  container_base(theme, Flex(Col), layout, attributes, elements)
}

/// Grid layout.
///
pub fn grid(theme, layout, attributes, inner elements) {
  container_base(theme, Grid, layout, attributes, elements)
}

/// Grouped Layout
///
/// Perfeito para agrupar botões.
///   - Podemos mostrar visualmente qual botão está clicado (selecionado).
///
pub fn grouped(theme, layout, attributes, buttons) {
  container_base(theme, Flex(Inline), layout, attributes, buttons)
}

/// O Container layout base tailwind, baseado no tipo `Layout` em `tailwind.gleam`.
///
pub fn container_base(theme, base, more, a, e) {
  let base = layout(base)

  container(theme, [base, ..more], a, e)
}

/// O Container layout genérico, baseado nos layout tokens.
///
/// - theme: Dados do tema para ser aplicado no container.
/// - layout: Tokens do tema para serem aplicados na base do layout.
/// - attributes: Atributes adcionais.
/// - elements: Elementos adionais.
///
pub fn container(theme, layout, attributes, elements) {
  let base_layout = fn() { layout }

  theme.with_base_to_tokens(theme, base_layout)
  |> theme.div(attributes, elements)
}
