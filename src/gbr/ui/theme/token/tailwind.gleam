////
//// 🎨 GBR: UI Token Tailwincss Module
////
//// Tudo bem, aqui temos nossos design tokens em formato tailwindcss.
////
//// Strings estáticas (A-OT / JIT friendly do Tailwind v4)
////

import gbr/ui/theme

// -----------------------------------------------------------------------------
//
// -- 🛠️ HELPERS THEME
//
// -- Auxiliares p/ design tokens convertidos em classes tailwindcss.
//
// -----------------------------------------------------------------------------

pub fn elevation_to_border_tokens(elevation) {
  elevation_to_border_token(elevation)
  |> theme.token_to_list
}

/// Converte a elevação do tema em bordas tailwind.
///
pub fn elevation_to_border_token(elevation) {
  case elevation {
    theme.ElevationFlat -> "border-none"
    theme.ElevationLow -> "border-2"
    theme.ElevationMedium -> "border-4"
    theme.ElevationHigh -> "border-8"
    theme.ElevationInner -> "border-12"
    theme.ElevationAncestor(_) -> "border-inherit"
  }
  |> theme.Class
}

pub fn size_to_height_width_tokens(size: theme.UISize) {
  size_to_height_width_token(size)
  |> theme.token_to_list
}

/// Converte o tamanho do tema em altura e largura tailwind.
///
pub fn size_to_height_width_token(size: theme.UISize) {
  case size {
    theme.SizeAncestor(_) -> "h-inherit w-inherit"
    theme.SizeXxl -> "h-18 w-18"
    theme.SizeXl -> "h-16 w-16"
    theme.SizeLg -> "h-14 w-14"
    theme.SizeMd -> "h-12 w-12"
    theme.SizeSm -> "h-10 w-10"
    theme.SizeXs -> "h-8 h-8"
  }
  |> theme.Class
}

/// Retorna o token da superfície do tema em arredondamento do tailwind.
///
pub fn shape_to_rounded_token(shape: theme.UIShape) {
  case shape {
    theme.ShapeCircle -> "rounded-full"
    theme.ShapePill -> "rounded-3xl"
    theme.ShapeSharp -> "rounded-none"
    theme.ShapeAncestor(_) -> "rounded-inherit"
    theme.ShapeRounded(size, layout) -> layout_to_rounded_class(size, layout)
  }
  |> theme.Class
}

/// Converte a superfície do tema em arredondamentos do container do tailwind.
///
pub fn shape_to_rounded_tokens(shape: theme.UIShape) {
  shape_to_rounded_token(shape)
  |> theme.token_to_list
}

/// Retorna o token do tamanho do tema em espaçamentos (padding) tailwind.
///
pub fn size_padding_to_token(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "px-7 py-5"
    theme.SizeXl -> "px-6 py-4"
    theme.SizeLg -> "px-5 py-3"
    theme.SizeMd -> "px-4 py-2"
    theme.SizeSm -> "px-3 py-1"
    theme.SizeXs -> "px-2 py-0"
    theme.SizeAncestor(_) -> "p-inherit"
  }
  |> theme.Class
}

pub fn size_text_to_tokens(size: theme.UISize) {
  size_text_to_token(size)
  |> theme.token_to_list
}

/// Retona o tamanho do tema em tamanho de texto do tailwind.
///
pub fn size_text_to_token(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "text-3xl sm:text-4xl"
    theme.SizeXl -> "text-2xl sm:text-3xl"
    theme.SizeLg -> "text-xl sm:text-2xl"
    theme.SizeMd -> "text-md sm:text-lg"
    theme.SizeSm -> "text-sm sm:text-md"
    theme.SizeXs -> "text-xs sm:text-sm"
    theme.SizeAncestor(_) -> "text-inherit"
  }
  |> theme.Class
}

/// Converte o empilhamento do tema no 'z-index' do tailwind.
///
pub fn stack_to_zindex_tokens(stacking: theme.UIStacking) {
  stack_to_zindex_token(stacking)
  |> theme.token_to_list
}

pub fn stack_to_zindex_token(stacking: theme.UIStacking) {
  case stacking {
    theme.StackBase -> "z-0"
    theme.StackXxs -> "z-10"
    theme.StackXs -> "z-20"
    theme.StackSm -> "z-30"
    theme.StackLg -> "z-40"
    theme.StackXl -> "z-50"
    theme.StackXxl -> "z-60"
    theme.StackAncestor(_) -> "z-auto"
  }
  |> theme.Class
}

//
// -- HELPERS TAILWIND
//

pub fn layout_grid_class() {
  theme.Class("grid")
}

pub fn layout_flex_row_class() {
  theme.Class("flex flex-row lg:flex-col")
}

pub fn layout_flex_col_class() {
  theme.Class("flex flex-col lg:flex-row")
}

pub fn layout_flex_inline_class() {
  theme.Class("inline-flex")
}

//
// -- Auxiliares (Interno)
//

fn layout_to_rounded_class(size, layout: theme.UILayout) {
  case layout {
    theme.LayoutDefault -> ""
    theme.LayoutAncestor(_) -> "rounded-inherit"
    theme.LayoutFlow(layout) -> layout_flow_to_rounded_class(size, layout)
    theme.LayoutAbsolute(layout) ->
      layout_absolute_to_rounded_class(size, layout)
  }
}

fn layout_flow_to_rounded_class(size, layout: theme.UIFlow) {
  case layout {
    theme.Flow(main:, cross: _) -> layout_alignment_to_rounded_class(size, main)
    theme.Main(justify:) -> layout_alignment_to_rounded_class(size, justify)
    theme.Cross(align:) -> layout_alignment_to_rounded_class(size, align)
  }
}

fn layout_alignment_to_rounded_class(size, alignment: theme.UIAlignment) {
  case alignment, size {
    theme.Start, theme.SizeAncestor(theme.AncestorInherit) ->
      "rounded-s-inherit"
    theme.Start, theme.SizeAncestor(_) -> "rounded-s"
    theme.Start, theme.SizeXxl -> "rounded-s-2xl"
    theme.Start, theme.SizeXl -> "rounded-s-xl"
    theme.Start, theme.SizeLg -> "rounded-s-lg"
    theme.Start, theme.SizeMd -> "rounded-s-md"
    theme.Start, theme.SizeSm -> "rounded-s-sm"
    theme.Start, theme.SizeXs -> "rounded-s-xs"
    theme.End, theme.SizeAncestor(theme.AncestorInherit) -> "rounded-e-inherit"
    theme.End, theme.SizeAncestor(_) -> "rounded-e"
    theme.End, theme.SizeXxl -> "rounded-e-2xl"
    theme.End, theme.SizeXl -> "rounded-e-xl"
    theme.End, theme.SizeLg -> "rounded-e-lg"
    theme.End, theme.SizeMd -> "rounded-e-md"
    theme.End, theme.SizeSm -> "rounded-e-sm"
    theme.End, theme.SizeXs -> "rounded-e-xs"
    theme.SpaceBetween, theme.SizeAncestor(theme.AncestorInherit) ->
      "rounded-ss-inherit"
    theme.SpaceBetween, theme.SizeAncestor(_) -> "rounded-ss"
    theme.SpaceBetween, theme.SizeXxl -> "rounded-ss-2xl"
    theme.SpaceBetween, theme.SizeXl -> "rounded-ss-xl"
    theme.SpaceBetween, theme.SizeLg -> "rounded-ss-lg"
    theme.SpaceBetween, theme.SizeMd -> "rounded-ss-md"
    theme.SpaceBetween, theme.SizeSm -> "rounded-ss-sm"
    theme.SpaceBetween, theme.SizeXs -> "rounded-ss-xs"
    theme.SpaceAround, theme.SizeAncestor(theme.AncestorInherit) ->
      "rounded-se-inherit"
    theme.SpaceAround, theme.SizeAncestor(_) -> "rounded-se"
    theme.SpaceAround, theme.SizeXxl -> "rounded-se-2xl"
    theme.SpaceAround, theme.SizeXl -> "rounded-se-xl"
    theme.SpaceAround, theme.SizeLg -> "rounded-se-lg"
    theme.SpaceAround, theme.SizeMd -> "rounded-se-md"
    theme.SpaceAround, theme.SizeSm -> "rounded-se-sm"
    theme.SpaceAround, theme.SizeXs -> "rounded-se-xs"
    theme.SpaceEvenly, theme.SizeAncestor(theme.AncestorInherit) ->
      "rounded-ee-inherit"
    theme.SpaceEvenly, theme.SizeAncestor(_) -> "rounded-ee"
    theme.SpaceEvenly, theme.SizeXxl -> "rounded-ee-2xl"
    theme.SpaceEvenly, theme.SizeXl -> "rounded-ee-xl"
    theme.SpaceEvenly, theme.SizeLg -> "rounded-ee-lg"
    theme.SpaceEvenly, theme.SizeMd -> "rounded-ee-md"
    theme.SpaceEvenly, theme.SizeSm -> "rounded-ee-sm"
    theme.SpaceEvenly, theme.SizeXs -> "rounded-ee-xs"
    theme.Stretch, theme.SizeAncestor(theme.AncestorInherit) ->
      "rounded-es-inherit"
    theme.Stretch, theme.SizeAncestor(_) -> "rounded-es"
    theme.Stretch, theme.SizeXxl -> "rounded-es-2xl"
    theme.Stretch, theme.SizeXl -> "rounded-es-xl"
    theme.Stretch, theme.SizeLg -> "rounded-es-lg"
    theme.Stretch, theme.SizeMd -> "rounded-es-md"
    theme.Stretch, theme.SizeSm -> "rounded-es-sm"
    theme.Stretch, theme.SizeXs -> "rounded-es-xs"
    theme.Center, _ ->
      layout_absolute_to_rounded_class(size, theme.AxisX(theme.Center))
  }
}

/// Fallback to rounded
/// Helper interno com pattern matching para bordas
///
/// TODO: Mudar para theme.UILayout e implementar o restante dos tokens tailwind
///
fn layout_absolute_to_rounded_class(size, absolute) {
  case absolute, size {
    // Top
    theme.AxisY(theme.Start), theme.SizeXxl -> "rounded-t-2xl"
    theme.AxisY(theme.Start), theme.SizeXl -> "rounded-t-xl"
    theme.AxisY(theme.Start), theme.SizeLg -> "rounded-t-lg"
    theme.AxisY(theme.Start), theme.SizeMd -> "rounded-t-md"
    theme.AxisY(theme.Start), theme.SizeSm -> "rounded-t-sm"
    theme.AxisY(theme.Start), theme.SizeXs -> "rounded-t-xs"
    theme.AxisY(theme.Start), theme.SizeAncestor(_) -> "rounded-t-inherit"

    // Bottom
    theme.AxisY(theme.End), theme.SizeXxl -> "rounded-b-2xl"
    theme.AxisY(theme.End), theme.SizeXl -> "rounded-b-xl"
    theme.AxisY(theme.End), theme.SizeLg -> "rounded-b-lg"
    theme.AxisY(theme.End), theme.SizeMd -> "rounded-b-md"
    theme.AxisY(theme.End), theme.SizeSm -> "rounded-b-sm"
    theme.AxisY(theme.End), theme.SizeXs -> "rounded-b-xs"
    theme.AxisY(theme.End), theme.SizeAncestor(_) -> "rounded-b-inherit"

    // Left
    theme.AxisX(theme.Start), theme.SizeXxl -> "rounded-l-2xl"
    theme.AxisX(theme.Start), theme.SizeXl -> "rounded-l-xl"
    theme.AxisX(theme.Start), theme.SizeLg -> "rounded-l-lg"
    theme.AxisX(theme.Start), theme.SizeMd -> "rounded-l-md"
    theme.AxisX(theme.Start), theme.SizeSm -> "rounded-l-sm"
    theme.AxisX(theme.Start), theme.SizeXs -> "rounded-l-xs"
    theme.AxisX(theme.Start), theme.SizeAncestor(_) -> "rounded-l-inherit"

    // Right
    theme.AxisX(theme.End), theme.SizeXxl -> "rounded-r-2xl"
    theme.AxisX(theme.End), theme.SizeXl -> "rounded-r-xl"
    theme.AxisX(theme.End), theme.SizeLg -> "rounded-r-lg"
    theme.AxisX(theme.End), theme.SizeMd -> "rounded-r-md"
    theme.AxisX(theme.End), theme.SizeSm -> "rounded-r-sm"
    theme.AxisX(theme.End), theme.SizeXs -> "rounded-r-xs"
    theme.AxisX(theme.End), theme.SizeAncestor(_) -> "rounded-r-inherit"

    // x,y
    theme.Axis(theme.Start, theme.Start), theme.SizeXxl -> "rounded-tl-2xl"
    theme.Axis(theme.Start, theme.Start), theme.SizeXl -> "rounded-tl-xl"
    theme.Axis(theme.Start, theme.Start), theme.SizeLg -> "rounded-tl-lg"
    theme.Axis(theme.Start, theme.Start), theme.SizeMd -> "rounded-tl-md"
    theme.Axis(theme.Start, theme.Start), theme.SizeSm -> "rounded-tl-sm"
    theme.Axis(theme.Start, theme.Start), theme.SizeXs -> "rounded-tl-xs"
    theme.Axis(theme.Start, theme.Start), theme.SizeAncestor(_) ->
      "rounded-tl-inherit"
    theme.Axis(theme.Start, theme.End), theme.SizeXxl -> "rounded-bl-2xl"
    theme.Axis(theme.Start, theme.End), theme.SizeXl -> "rounded-bl-xl"
    theme.Axis(theme.Start, theme.End), theme.SizeLg -> "rounded-bl-lg"
    theme.Axis(theme.Start, theme.End), theme.SizeMd -> "rounded-bl-md"
    theme.Axis(theme.Start, theme.End), theme.SizeSm -> "rounded-bl-sm"
    theme.Axis(theme.Start, theme.End), theme.SizeXs -> "rounded-bl-xs"
    theme.Axis(theme.Start, theme.End), theme.SizeAncestor(_) ->
      "rounded-bl-inherit"
    theme.Axis(theme.End, theme.Start), theme.SizeXxl -> "rounded-tr-2xl"
    theme.Axis(theme.End, theme.Start), theme.SizeXl -> "rounded-tr-xl"
    theme.Axis(theme.End, theme.Start), theme.SizeLg -> "rounded-tr-lg"
    theme.Axis(theme.End, theme.Start), theme.SizeMd -> "rounded-tr-md"
    theme.Axis(theme.End, theme.Start), theme.SizeSm -> "rounded-tr-sm"
    theme.Axis(theme.End, theme.Start), theme.SizeXs -> "rounded-tr-xs"
    theme.Axis(theme.End, theme.Start), theme.SizeAncestor(_) ->
      "rounded-tr-inherit"
    theme.Axis(theme.End, theme.End), theme.SizeXxl -> "rounded-br-2xl"
    theme.Axis(theme.End, theme.End), theme.SizeXl -> "rounded-br-xl"
    theme.Axis(theme.End, theme.End), theme.SizeLg -> "rounded-br-lg"
    theme.Axis(theme.End, theme.End), theme.SizeMd -> "rounded-br-md"
    theme.Axis(theme.End, theme.End), theme.SizeSm -> "rounded-br-sm"
    theme.Axis(theme.End, theme.End), theme.SizeXs -> "rounded-br-xs"
    theme.Axis(theme.End, theme.End), theme.SizeAncestor(_) ->
      "rounded-br-inherit"
    // Default (Arredonda todos os cantos)
    theme.AxisX(theme.Center), theme.SizeXxl
    | theme.AxisY(theme.Center), theme.SizeXxl
    -> "rounded-2xl"
    theme.AxisX(theme.Center), theme.SizeXl
    | theme.AxisY(theme.Center), theme.SizeXl
    -> "rounded-xl"
    theme.AxisX(theme.Center), theme.SizeLg
    | theme.AxisY(theme.Center), theme.SizeLg
    -> "rounded-lg"
    theme.AxisX(theme.Center), theme.SizeMd
    | theme.AxisY(theme.Center), theme.SizeMd
    -> "rounded-md"
    theme.AxisX(theme.Center), theme.SizeSm
    | theme.AxisY(theme.Center), theme.SizeSm
    -> "rounded-sm"
    theme.AxisX(theme.Center), theme.SizeXs
    | theme.AxisY(theme.Center), theme.SizeXs
    -> "rounded-xs"
    theme.AxisX(theme.Center), theme.SizeAncestor(_)
    | theme.AxisY(theme.Center), theme.SizeAncestor(_)
    -> "rounded-inherit"
    // Fallbacks para arredondamentos em todos cantos
    theme.Axis(horizontal: theme.Start, vertical: theme.Center), size
    | theme.Axis(horizontal: theme.End, vertical: theme.Center), size
    | theme.Axis(horizontal: theme.Center, vertical: _), size
    -> layout_absolute_to_rounded_class(size, theme.AxisX(theme.Center))
    // Fallback para combinações complexas não utilizadas
    _, _ -> "rounded"
  }
}
