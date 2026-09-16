////
//// UI Lustre Tailwind Module
////

import gbr/ui/theme
import gbr/ui/theme/lustre

// -----------------------------------------------------------------------------
//
// -- 🛠️ HELPERS THEME **UIShape**
//
// -----------------------------------------------------------------------------

/// Retorna o token da superfície do tema em arredondamento do tailwind.
///
pub fn shape_rounded_to_class(shape: theme.UIShape) {
  case shape {
    theme.ShapeCircle -> lustre.Class("rounded-full")
    theme.ShapePill -> lustre.Class("rounded-3xl")
    theme.ShapeSharp -> lustre.Class("rounded-none")
    theme.ShapeAncestor(_) -> lustre.Class("rounded-inherit")
    theme.Shape(size, layout) -> size_layout_to_rounded_token(size, layout)
  }
}

/// Converte a superfície do tema em arredondamentos do container do tailwind.
///
pub fn shape_rounded_tokens(shape: theme.UIShape) {
  [shape_rounded_to_class(shape)]
}

// -----------------------------------------------------------------------------
// **ROUNDED-**
//
// -- 🛠️ HELPERS THEME `rounded-` UISize x UILayout
//
// -----------------------------------------------------------------------------

pub fn size_layout_to_rounded_token(size, layout) {
  case layout {
    theme.LayoutDefault -> lustre.Empty
    theme.LayoutAncestor(_) -> lustre.Class("rounded-inherit")
    theme.LayoutFlow(flow) -> size_layout_flow_to_rounded_token(size, flow)
    theme.LayoutAbsolute(absolute) ->
      size_absolute_to_rounded_token(size, absolute)
  }
}

pub fn size_layout_flow_to_rounded_token(
  size: theme.UISize,
  layout: theme.UIFlow,
) {
  case layout {
    // Para simplificar a herança de layout, priorizamos o eixo 'main'
    theme.Flow(main, _, _)
    | theme.FlowItems(main, _)
    | theme.FlowContent(main, _) -> size_alignment_to_rounded_token(size, main)

    theme.Main(align) | theme.CrossContent(align) | theme.CrossItems(align) ->
      size_alignment_to_rounded_token(size, align)
  }
}

pub fn size_alignment_to_rounded_token(
  size: theme.UISize,
  alignment: theme.UIAlignment,
) {
  case alignment {
    theme.Start -> size_to_rounded_start(size)
    theme.End -> size_to_rounded_end(size)
    theme.SpaceBetween -> size_to_rounded_start_start(size)
    theme.SpaceAround -> size_to_rounded_start_end(size)
    theme.SpaceEvenly -> size_rounded_end_end(size)
    theme.Stretch -> size_to_rounded_end_start(size)
    theme.Center -> size_to_rounded_all(size)
  }
}

pub fn size_absolute_to_rounded_token(
  size: theme.UISize,
  absolute: theme.UIAbsolute,
) {
  case absolute {
    theme.AxisY(theme.Start) -> size_to_rounded_top(size)
    theme.AxisY(theme.End) -> size_to_rounded_bottom(size)
    theme.AxisX(theme.Start) -> size_to_rounded_left(size)
    theme.AxisX(theme.End) -> size_to_rounded_right(size)

    // Combinações (X, Y) mapeadas para os cantos exatos
    theme.Axis(theme.Start, theme.Start) -> size_to_rounded_top_left(size)
    theme.Axis(theme.Start, theme.End) -> size_to_rounded_bottom_left(size)
    theme.Axis(theme.End, theme.Start) -> size_to_rounded_top_right(size)
    theme.Axis(theme.End, theme.End) -> size_to_rounded_bottom_right(size)

    // combinação Center e outras
    _ -> size_to_rounded_all(size)
  }
}

pub fn size_to_rounded_all(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-2xl"
    theme.SizeXl -> "rounded-xl"
    theme.SizeLg -> "rounded-lg"
    theme.SizeMd -> "rounded-md"
    theme.SizeSm -> "rounded-sm"
    theme.SizeXs -> "rounded-xs"
    theme.SizeXxs -> "rounded-[0.0625rem]"
    theme.SizeAncestor(_) -> "rounded-inherit"
  }
  |> lustre.Class
}

pub fn size_to_rounded_top(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-t-2xl"
    theme.SizeXl -> "rounded-t-xl"
    theme.SizeLg -> "rounded-t-lg"
    theme.SizeMd -> "rounded-t-md"
    theme.SizeSm -> "rounded-t-sm"
    theme.SizeXs -> "rounded-t-xs"
    theme.SizeXxs -> "rounded-t-[0.0625rem]"
    theme.SizeAncestor(_) -> "rounded-t-inherit"
  }
  |> lustre.Class
}

pub fn size_to_rounded_bottom(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-b-2xl"
    theme.SizeXl -> "rounded-b-xl"
    theme.SizeLg -> "rounded-b-lg"
    theme.SizeMd -> "rounded-b-md"
    theme.SizeSm -> "rounded-b-sm"
    theme.SizeXs -> "rounded-b-xs"
    theme.SizeXxs -> "rounded-b-[0.0625rem]"
    theme.SizeAncestor(_) -> "rounded-b-inherit"
  }
  |> lustre.Class
}

pub fn size_to_rounded_left(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-l-2xl"
    theme.SizeXl -> "rounded-l-xl"
    theme.SizeLg -> "rounded-l-lg"
    theme.SizeMd -> "rounded-l-md"
    theme.SizeSm -> "rounded-l-sm"
    theme.SizeXs -> "rounded-l-xs"
    theme.SizeXxs -> "rounded-l-[0.0625rem]"
    theme.SizeAncestor(_) -> "rounded-l-inherit"
  }
  |> lustre.Class
}

pub fn size_to_rounded_right(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-r-2xl"
    theme.SizeXl -> "rounded-r-xl"
    theme.SizeLg -> "rounded-r-lg"
    theme.SizeMd -> "rounded-r-md"
    theme.SizeSm -> "rounded-r-sm"
    theme.SizeXs -> "rounded-r-xs"
    theme.SizeXxs -> "rounded-r-[0.0625rem]"
    theme.SizeAncestor(_) -> "rounded-r-inherit"
  }
  |> lustre.Class
}

pub fn size_to_rounded_top_left(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-tl-2xl"
    theme.SizeXl -> "rounded-tl-xl"
    theme.SizeLg -> "rounded-tl-lg"
    theme.SizeMd -> "rounded-tl-md"
    theme.SizeSm -> "rounded-tl-sm"
    theme.SizeXs -> "rounded-tl-xs"
    theme.SizeXxs -> "rounded-tl-[0.0625rem]"
    theme.SizeAncestor(_) -> "rounded-tl-inherit"
  }
  |> lustre.Class
}

pub fn size_to_rounded_top_right(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-tr-2xl"
    theme.SizeXl -> "rounded-tr-xl"
    theme.SizeLg -> "rounded-tr-lg"
    theme.SizeMd -> "rounded-tr-md"
    theme.SizeSm -> "rounded-tr-sm"
    theme.SizeXs -> "rounded-tr-xs"
    theme.SizeXxs -> "rounded-tr-[0.0625rem]"
    theme.SizeAncestor(_) -> "rounded-tr-inherit"
  }
  |> lustre.Class
}

pub fn size_to_rounded_bottom_left(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-bl-2xl"
    theme.SizeXl -> "rounded-bl-xl"
    theme.SizeLg -> "rounded-bl-lg"
    theme.SizeMd -> "rounded-bl-md"
    theme.SizeSm -> "rounded-bl-sm"
    theme.SizeXs -> "rounded-bl-xs"
    theme.SizeXxs -> "rounded-bl-[0.0625rem]"
    theme.SizeAncestor(_) -> "rounded-bl-inherit"
  }
  |> lustre.Class
}

pub fn size_to_rounded_bottom_right(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-br-2xl"
    theme.SizeXl -> "rounded-br-xl"
    theme.SizeLg -> "rounded-br-lg"
    theme.SizeMd -> "rounded-br-md"
    theme.SizeSm -> "rounded-br-sm"
    theme.SizeXs -> "rounded-br-xs"
    theme.SizeXxs -> "rounded-br-[0.0625rem]"
    theme.SizeAncestor(_) -> "rounded-br-inherit"
  }
  |> lustre.Class
}

pub fn size_to_rounded_start(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-s-2xl"
    theme.SizeXl -> "rounded-s-xl"
    theme.SizeLg -> "rounded-s-lg"
    theme.SizeMd -> "rounded-s-md"
    theme.SizeSm -> "rounded-s-sm"
    theme.SizeXs -> "rounded-s-xs"
    theme.SizeXxs -> "rounded-s-[0.0625rem]"
    theme.SizeAncestor(_) -> "rounded-s-inherit"
  }
  |> lustre.Class
}

pub fn size_to_rounded_end(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-e-2xl"
    theme.SizeXl -> "rounded-e-xl"
    theme.SizeLg -> "rounded-e-lg"
    theme.SizeMd -> "rounded-e-md"
    theme.SizeSm -> "rounded-e-sm"
    theme.SizeXs -> "rounded-e-xs"
    theme.SizeXxs -> "rounded-e-[0.0625rem]"
    theme.SizeAncestor(_) -> "rounded-e-inherit"
  }
  |> lustre.Class
}

pub fn size_to_rounded_start_start(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-ss-2xl"
    theme.SizeXl -> "rounded-ss-xl"
    theme.SizeLg -> "rounded-ss-lg"
    theme.SizeMd -> "rounded-ss-md"
    theme.SizeSm -> "rounded-ss-sm"
    theme.SizeXs -> "rounded-ss-xs"
    theme.SizeXxs -> "rounded-ss-[0.0625rem]"
    theme.SizeAncestor(_) -> "rounded-ss-inherit"
  }
  |> lustre.Class
}

pub fn size_to_rounded_start_end(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-se-2xl"
    theme.SizeXl -> "rounded-se-xl"
    theme.SizeLg -> "rounded-se-lg"
    theme.SizeMd -> "rounded-se-md"
    theme.SizeSm -> "rounded-se-sm"
    theme.SizeXs -> "rounded-se-xs"
    theme.SizeXxs -> "rounded-se-[0.0625rem]"
    theme.SizeAncestor(_) -> "rounded-se-inherit"
  }
  |> lustre.Class
}

pub fn size_to_rounded_end_start(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-es-2xl"
    theme.SizeXl -> "rounded-es-xl"
    theme.SizeLg -> "rounded-es-lg"
    theme.SizeMd -> "rounded-es-md"
    theme.SizeSm -> "rounded-es-sm"
    theme.SizeXs -> "rounded-es-xs"
    theme.SizeXxs -> "rounded-es-[0.0625rem]"
    theme.SizeAncestor(_) -> "rounded-es-inherit"
  }
  |> lustre.Class
}

pub fn size_rounded_end_end(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-ee-2xl"
    theme.SizeXl -> "rounded-ee-xl"
    theme.SizeLg -> "rounded-ee-lg"
    theme.SizeMd -> "rounded-ee-md"
    theme.SizeSm -> "rounded-ee-sm"
    theme.SizeXs -> "rounded-ee-xs"
    theme.SizeXxs -> "rounded-ee-[0.0625rem]"
    theme.SizeAncestor(_) -> "rounded-ee-inherit"
  }
  |> lustre.Class
}

// -----------------------------------------------------------------------------
//
// -- 🛠️ HELPERS THEME **UIElevation**
//
// -----------------------------------------------------------------------------

pub fn elevation_to_border_tokens(elevation) {
  [elevation_to_border_token(elevation)]
}

/// Converte a elevação do tema em bordas tailwind.
///
pub fn elevation_to_border_token(elevation) {
  case elevation {
    theme.ElevationFlat -> lustre.Class("border-none")
    theme.ElevationLow -> lustre.Class("border-2")
    theme.ElevationMedium -> lustre.Class("border-4")
    theme.ElevationHigh -> lustre.Class("border-8")
    theme.ElevationInner -> lustre.Class("border-12")
    theme.ElevationAncestor(_) -> lustre.Class("border-inherit")
  }
}

pub fn elevation_to_text_shadow_tokens(elevation) {
  [elevation_to_text_shadow_token(elevation)]
}

pub fn elevation_to_text_shadow_token(elevation) {
  case elevation {
    theme.ElevationFlat -> "text-shadow-none" |> lustre.Class
    theme.ElevationInner -> "text-shadow-2xs" |> lustre.Class
    theme.ElevationLow -> "text-shadow-xs" |> lustre.Class
    theme.ElevationMedium -> "text-shadow-md" |> lustre.Class
    theme.ElevationHigh -> "text-shadow-lg" |> lustre.Class
    theme.ElevationAncestor(_) -> "text-shadow-inherit" |> lustre.Class
  }
}

// -----------------------------------------------------------------------------
//
// -- 🛠️ HELPERS THEME **UIStack**
//
// -----------------------------------------------------------------------------

/// Converte o empilhamento do tema no 'z-index' do tailwind.
///
pub fn stack_to_zindex_tokens(stacking: theme.UIStacking) {
  [stack_to_zindex_token(stacking)]
}

pub fn stack_to_zindex_token(stacking: theme.UIStacking) {
  case stacking {
    theme.StackBase -> "z-0"
    theme.StackFloat -> "z-10"
    theme.StackSticky -> "z-20"
    theme.StackDropdown -> "z-30"
    theme.StackOverlay -> "z-40"
    theme.StackModal -> "z-50"
    theme.StackToast -> "z-60"
    theme.StackTooltip -> "z-70"
    theme.StackAncestor(_) -> "z-auto"
  }
  |> lustre.Class
}

// -----------------------------------------------------------------------------
//
// -- 🛠️ HELPERS THEME **UISize**
//
// -----------------------------------------------------------------------------

pub fn size_text_to_classes(is_header) {
  fn(size) {
    case size {
      theme.SizeXxl -> [
        #("text-title-2xl sm:text-title-4xl", is_header),
        #("text-3xl sm:text-4xl", !is_header),
      ]
      theme.SizeXl -> [
        #("text-title-xl sm:text-title-2xl", is_header),
        #("text-2xl sm:text-3xl", !is_header),
      ]
      theme.SizeLg -> [
        #("text-title-lg sm:text-title-xl", is_header),
        #("text-xl sm:text-2xl", !is_header),
      ]
      theme.SizeMd -> [
        #("text-title-md sm:text-title-lg", is_header),
        #("text-md sm:text-lg", !is_header),
      ]
      theme.SizeSm -> [
        #("text-title-sm sm:text-title-md", is_header),
        #("text-sm sm:text-md", !is_header),
      ]
      theme.SizeXs -> [
        #("text-title-xs sm:text-title-sm", is_header),
        #("text-xs sm:text-xs", !is_header),
      ]
      _ -> []
    }
    |> lustre.Classes
  }
}

/// Retona o tamanho do tema em tamanho de texto do tailwind.
///
pub fn size_text_to_class(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "text-2xl sm:text-4xl"
    theme.SizeXl -> "text-xl sm:text-2xl"
    theme.SizeLg -> "text-lg sm:text-xl"
    theme.SizeMd -> "text-md sm:text-lg"
    theme.SizeSm -> "text-sm sm:text-md"
    theme.SizeXs -> "text-xs sm:text-sm"
    theme.SizeXxs -> "text-xs sm:text-xs"
    theme.SizeAncestor(_) -> "text-inherit"
  }
  |> lustre.Class
}

pub fn size_icon_height_class(size) {
  case size {
    theme.SizeAncestor(_) -> "h-inherit"
    theme.SizeXxl -> "h-18"
    theme.SizeXl -> "h-16"
    theme.SizeLg -> "h-14"
    theme.SizeMd -> "h-12"
    theme.SizeSm -> "h-10"
    theme.SizeXs -> "h-8"
    theme.SizeXxs -> "h-6"
  }
  |> lustre.Class
}

pub fn size_icon_width_class(size) {
  case size {
    theme.SizeAncestor(_) -> "w-inherit"
    theme.SizeXxl -> "w-18"
    theme.SizeXl -> "w-16"
    theme.SizeLg -> "w-14"
    theme.SizeMd -> "w-12"
    theme.SizeSm -> "w-10"
    theme.SizeXs -> "w-8"
    theme.SizeXxs -> "w-6"
  }
  |> lustre.Class
}

pub fn size_icon_max_height_class(size) {
  case size {
    theme.SizeXxl -> "max-h-4" |> lustre.Class
    theme.SizeXl -> "max-h-3.5" |> lustre.Class
    theme.SizeLg -> "max-h-3" |> lustre.Class
    theme.SizeMd -> "max-h-2.5" |> lustre.Class
    theme.SizeSm -> "max-h-2" |> lustre.Class
    theme.SizeXs -> "max-h-1.5" |> lustre.Class
    theme.SizeXxs -> "max-h-1" |> lustre.Class
    theme.SizeAncestor(_) -> "max-h-inherit" |> lustre.Class
  }
}

pub fn size_icon_max_width_class(size) {
  case size {
    theme.SizeXxl -> "max-w-4" |> lustre.Class
    theme.SizeXl -> "max-w-3.5" |> lustre.Class
    theme.SizeLg -> "max-w-3" |> lustre.Class
    theme.SizeMd -> "max-w-2.5" |> lustre.Class
    theme.SizeSm -> "max-w-2" |> lustre.Class
    theme.SizeXs -> "max-w-1.5" |> lustre.Class
    theme.SizeXxs -> "max-w-1" |> lustre.Class
    theme.SizeAncestor(_) -> "max-w-inherit" |> lustre.Class
  }
}

// -----------------------------------------------------------------------------
//
// -- 🛠️ HELPERS THEME **UILayout**
//
// -----------------------------------------------------------------------------

pub fn layout_flex_tokens(layout) {
  [layout_flex_class(), ..layout_to_tokens(layout)]
}

pub fn layout_grid_tokens(layout) {
  [layout_flex_class(), ..layout_to_tokens(layout)]
}

pub fn layout_to_tokens(layout: theme.UILayout) {
  case layout {
    theme.LayoutDefault | theme.LayoutAncestor(_) -> []
    theme.LayoutFlow(layout) -> layout_flow_to_tokens(layout)
    theme.LayoutAbsolute(layout) -> absolute_to_layout_token(layout)
  }
}

/// Tema de layout para tokens tailwind.
///
pub fn layout_flow_to_tokens(layout: theme.UIFlow) -> List(lustre.UILustre) {
  case layout {
    theme.Main(justify:) -> alignment_to_justify_tokens(justify)
    theme.CrossItems(align:) -> alignment_to_items_tokens(align)
    theme.CrossContent(align:) -> alignment_to_content_tokens(align)
    theme.Flow(main:, cross_content:, cross_items:) -> [
      alignment_to_justify_token(main),
      alignment_to_content_token(cross_content),
      alignment_to_items_token(cross_items),
    ]
    theme.FlowItems(main:, cross_items:) -> [
      alignment_to_justify_token(main),
      alignment_to_items_token(cross_items),
    ]
    theme.FlowContent(main:, cross_content:) -> [
      alignment_to_justify_token(main),
      alignment_to_content_token(cross_content),
    ]
  }
}

// -----------------------------------------------------------------------------
//
// -- 🛠️ HELPERS THEME **UIAlignment**
//
// -----------------------------------------------------------------------------

pub fn alignment_to_items_tokens(align: theme.UIAlignment) {
  [alignment_to_items_token(align)]
}

/// Alinhamento dos itens no eixo transversal (align-items)
///
pub fn alignment_to_items_token(align: theme.UIAlignment) {
  case align {
    theme.Start -> "items-start"
    theme.End -> "items-end"
    theme.Center -> "items-center"
    theme.Stretch -> "items-stretch"
    // 'space-*' não são aplicáveis.
    theme.SpaceBetween | theme.SpaceAround | theme.SpaceEvenly ->
      "items-stretch"
  }
  |> lustre.Class
}

pub fn alignment_to_content_tokens(align: theme.UIAlignment) {
  [alignment_to_content_token(align)]
}

/// A intenção de alinhamento no eixo transversal (align-content)
///
pub fn alignment_to_content_token(align: theme.UIAlignment) {
  case align {
    theme.Start -> "content-start"
    theme.End -> "content-end"
    theme.Center -> "content-center"
    theme.SpaceBetween -> "content-between"
    theme.SpaceAround -> "content-around"
    theme.SpaceEvenly -> "content-evenly"
    theme.Stretch -> "content-stretch"
  }
  |> lustre.Class
}

pub fn alignment_to_justify_tokens(align: theme.UIAlignment) {
  [alignment_to_justify_token(align)]
}

/// A intenção de alinhamento no eixo principal (justify-content)
///
pub fn alignment_to_justify_token(align: theme.UIAlignment) {
  case align {
    theme.Start -> "justify-start"
    theme.End -> "justify-end"
    theme.Center -> "justify-center"
    theme.SpaceBetween -> "justify-between"
    theme.SpaceAround -> "justify-around"
    theme.SpaceEvenly -> "justify-evenly"
    theme.Stretch -> "justify-stretch"
  }
  |> lustre.Class
}

// -----------------------------------------------------------------------------
//
// -- 🛠️ HELPERS THEME **UIAbsolute**
//
// -----------------------------------------------------------------------------

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

/// Processa o modelo de posicionamento absoluto, já injetando a classe 'absolute'
pub fn absolute_to_layout_token(absolute: theme.UIAbsolute) {
  case absolute {
    theme.AxisX(x) -> [horizontal_to_layout_token(x)]
    theme.AxisY(y) -> [vertical_to_layout_token(y)]
    theme.Axis(horizontal:, vertical:) -> [
      horizontal_to_layout_token(horizontal),
      vertical_to_layout_token(vertical),
    ]
  }
}

/// Processa o eixo X absoluto.
///
/// - Nota: Center usa o translate para centralização.
///
pub fn horizontal_to_layout_token(x: theme.UIAlignment) {
  case x {
    theme.End -> "right-0"
    theme.Center -> "left-1/2 -translate-x-1/2"
    theme.SpaceBetween
    | theme.SpaceAround
    | theme.SpaceEvenly
    | theme.Stretch
    | theme.Start -> "left-0"
  }
  |> lustre.Class
}

/// Processa o eixo Y absoluto.
///
pub fn vertical_to_layout_token(y: theme.UIAlignment) {
  case y {
    theme.End -> "bottom-0"
    theme.Center -> "top-1/2 -translate-y-1/2"
    theme.SpaceBetween
    | theme.SpaceAround
    | theme.SpaceEvenly
    | theme.Stretch
    | theme.Start -> "top-0"
  }
  |> lustre.Class
}

// -----------------------------------------------------------------------------
//
// -- HELPERS TAILWIND (HARD CODE)
//
// -----------------------------------------------------------------------------

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

//
// -- A11y
//

/// Estado de carregamento.
///
pub fn aria_busy(is_loading: Bool) {
  case is_loading {
    True -> lustre.Attribute("aria-busy", "true")
    False -> lustre.Attribute("aria-busy", "false")
  }
}

/// Descrever elementos visuais (ex: imagens) em leitores de tela.
///
pub fn aria_label(label: String) {
  lustre.Attribute("aria-label", label)
}

/// Descrever elementos usando ref. a outro elemento, exemplo `<h2 id="..." />`.
///
pub fn aria_labelledby(id: String) {
  lustre.Attribute("aria-labelledby", id)
}

/// Ocultar elementos visuais (ex: ícones decorativos) de leitores de tela.
///
pub fn aria_hidden() {
  lustre.Attribute("aria-hidden", "true")
}

/// Indica se o componente está expandido ou não, útil para sidebar menu.
///
pub fn aria_expanded(expand: Bool) {
  case expand {
    True -> lustre.Attribute("aria-expanded", "true")
    False -> lustre.Attribute("aria-expanded", "false")
  }
}
