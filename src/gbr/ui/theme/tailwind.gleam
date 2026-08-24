////
//// 🎨 GBR: UI Tailwincss Module
////
//// Tudo bem, aqui temos nossos design tokens em formato tailwindcss.
////
//// Strings estáticas (A-OT / JIT friendly do Tailwind v4)
////

import gbr/ui/theme

//
// -- HELPERS (Tipos )
//

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

// -----------------------------------------------------------------------------
//
// -- 🛠️ HELPER LAYOUTS
//
// -----------------------------------------------------------------------------

/// Conversor p/ os tokens tailwind baseado no `Layout`.
///
pub fn layout(layout: Layout) -> String {
  case layout {
    Flex(layout) -> layout_flex(layout)
    Grid -> "grid"
  }
}

/// Retorna os tokens a partir do layout flex.
///
pub fn layout_flex(layout: Flex) -> String {
  case layout {
    Row -> "flex flex-row lg:flex-col"
    Col -> "flex flex-col lg:flex-row"
    Inline -> "inline-flex"
  }
}

// -----------------------------------------------------------------------------
//
// -- 🛠️ HELPERS THEME
//
// -- Auxiliares p/ design tokens convertidos em classes tailwindcss.
//
// -----------------------------------------------------------------------------

/// Converte a elevação do tema em bordas tailwind.
///
pub fn elevation_to_border_classes(elevation) {
  let token = case elevation {
    theme.ElevationFlat -> "border-none"
    theme.ElevationLow -> "border-2"
    theme.ElevationMedium -> "border-4"
    theme.ElevationHigh -> "border-8"
    theme.ElevationInner -> "border-12"
    theme.ElevationAncestor(_) -> "border-inherit"
  }

  [#(token, True)]
  |> theme.Classes
  |> theme.token_to_list
}

/// Converte o tamanho do tema em altura e largura tailwind.
///
pub fn size_to_height_width_classes(size: theme.UISize) {
  let token = case size {
    theme.SizeAncestor(_) -> "h-inherit w-inherit"
    theme.SizeXxl -> "h-18 w-18"
    theme.SizeXl -> "h-16 w-16"
    theme.SizeLg -> "h-14 w-14"
    theme.SizeMd -> "h-12 w-12"
    theme.SizeSm -> "h-10 w-10"
    theme.SizeXs -> "h-8 h-8"
  }

  [#(token, True)]
  |> theme.Classes
  |> theme.token_to_list
}

/// Retorna o token da superfície do tema em arredondamento do tailwind.
///
pub fn shape_to_rounded_token(shape: theme.UIShape) {
  case shape {
    theme.ShapeCircle -> "rounded-full"
    theme.ShapePill -> "rounded-3xl"
    theme.ShapeSharp -> "rounded-none"
    theme.ShapeAncestor(_) -> "rounded-inherit"
    theme.ShapeRounded(size, direction) -> get_rounded_class(size, direction)
  }
}

/// Converte a superfície do tema em arredondamentos do container do tailwind.
///
pub fn shape_to_rounded_classes(shape: theme.UIShape) {
  [#(shape_to_rounded_token(shape), True)]
  |> theme.Classes
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
}

/// Converte o tamanho do tema em espaçamentos (padding) tailwind.
///
pub fn size_padding_to_classes(size: theme.UISize) {
  [#(size_padding_to_token(size), True)]
  |> theme.Classes
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
}

/// Converte o tamanho do tema em tamanho de texto do tailwind.
///
pub fn size_text_to_classes(size: theme.UISize) {
  [#(size_text_to_token(size), True)]
  |> theme.Classes
  |> theme.token_to_list
}

/// Converte o empilhamento do tema no 'z-index' do tailwind.
///
pub fn stack_to_zindex_classes(stacking: theme.UIStacking) {
  let token = case stacking {
    theme.StackBase -> "z-0"
    theme.StackXxs -> "z-10"
    theme.StackXs -> "z-20"
    theme.StackSm -> "z-30"
    theme.StackLg -> "z-40"
    theme.StackXl -> "z-50"
    theme.StackXxl -> "z-60"
    theme.StackAncestor(_) -> "z-auto"
  }
  [#(token, True)]
  |> theme.Classes
  |> theme.token_to_list
}

//
// -- Auxiliares (Interno)
//

/// Helper interno com pattern matching para bordas
fn get_rounded_class(size, direction) {
  let token = case direction, size {
    // Default (Arredonda todos os cantos)
    theme.DirectionDefault, theme.SizeXxl -> "rounded-2xl"
    theme.DirectionDefault, theme.SizeXl -> "rounded-xl"
    theme.DirectionDefault, theme.SizeLg -> "rounded-lg"
    theme.DirectionDefault, theme.SizeMd -> "rounded-md"
    theme.DirectionDefault, theme.SizeSm -> "rounded-sm"
    theme.DirectionDefault, theme.SizeXs -> "rounded-sm"
    theme.DirectionDefault, _ -> "rounded-inherit"

    // Top
    theme.DirectionY(theme.Top), theme.SizeXxl -> "rounded-t-2xl"
    theme.DirectionY(theme.Top), theme.SizeXl -> "rounded-t-xl"
    theme.DirectionY(theme.Top), theme.SizeLg -> "rounded-t-lg"
    theme.DirectionY(theme.Top), theme.SizeMd -> "rounded-t-md"
    theme.DirectionY(theme.Top), theme.SizeSm -> "rounded-t-sm"
    theme.DirectionY(theme.Top), theme.SizeXs -> "rounded-t-sm"
    theme.DirectionY(theme.Top), _ -> "rounded-t-inherit"

    // Bottom
    theme.DirectionY(theme.Bottom), theme.SizeXxl -> "rounded-b-2xl"
    theme.DirectionY(theme.Bottom), theme.SizeXl -> "rounded-b-xl"
    theme.DirectionY(theme.Bottom), theme.SizeLg -> "rounded-b-lg"
    theme.DirectionY(theme.Bottom), theme.SizeMd -> "rounded-b-md"
    theme.DirectionY(theme.Bottom), theme.SizeSm -> "rounded-b-sm"
    theme.DirectionY(theme.Bottom), theme.SizeXs -> "rounded-b-sm"
    theme.DirectionY(theme.Bottom), _ -> "rounded-b-inherit"

    // Left
    theme.DirectionX(theme.Left), theme.SizeXxl -> "rounded-l-2xl"
    theme.DirectionX(theme.Left), theme.SizeXl -> "rounded-l-xl"
    theme.DirectionX(theme.Left), theme.SizeLg -> "rounded-l-lg"
    theme.DirectionX(theme.Left), theme.SizeMd -> "rounded-l-md"
    theme.DirectionX(theme.Left), theme.SizeSm -> "rounded-l-sm"
    theme.DirectionX(theme.Left), theme.SizeXs -> "rounded-l-sm"
    theme.DirectionX(theme.Left), _ -> "rounded-l-inherit"

    // Right
    theme.DirectionX(theme.Right), theme.SizeXxl -> "rounded-r-2xl"
    theme.DirectionX(theme.Right), theme.SizeXl -> "rounded-r-xl"
    theme.DirectionX(theme.Right), theme.SizeLg -> "rounded-r-lg"
    theme.DirectionX(theme.Right), theme.SizeMd -> "rounded-r-md"
    theme.DirectionX(theme.Right), theme.SizeSm -> "rounded-r-sm"
    theme.DirectionX(theme.Right), theme.SizeXs -> "rounded-r-sm"
    theme.DirectionX(theme.Right), _ -> "rounded-r-inherit"

    // Fallbacks para outras direções mais complexas
    _, _ -> "rounded"
  }

  token
}
