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
// -- 🛠️ HELPERS THEME **UISize**
//
// -----------------------------------------------------------------------------

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

// -----------------------------------------------------------------------------
//
// -- 🛠️ HELPERS THEME **UIShape**
//
// -----------------------------------------------------------------------------

/// Retorna o token da superfície do tema em arredondamento do tailwind.
///
pub fn shape_to_rounded_token(shape: theme.UIShape) {
  case shape {
    theme.ShapeCircle -> theme.Class("rounded-full")
    theme.ShapePill -> theme.Class("rounded-3xl")
    theme.ShapeSharp -> theme.Class("rounded-none")
    theme.ShapeAncestor(_) -> theme.Class("rounded-inherit")
    theme.Shape(size, layout) -> size_layout_to_rounded_token(size, layout)
  }
}

/// Converte a superfície do tema em arredondamentos do container do tailwind.
///
pub fn shape_to_rounded_tokens(shape: theme.UIShape) {
  shape_to_rounded_token(shape)
  |> theme.token_to_list
}

// -----------------------------------------------------------------------------
//
// -- 🛠️ HELPERS THEME **UIElevation**
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
    theme.ElevationFlat -> theme.Class("border-none")
    theme.ElevationLow -> theme.Class("border-2")
    theme.ElevationMedium -> theme.Class("border-4")
    theme.ElevationHigh -> theme.Class("border-8")
    theme.ElevationInner -> theme.Class("border-12")
    theme.ElevationAncestor(_) -> theme.Class("border-inherit")
    theme.Elevation(size, layout) -> size_layout_to_border_token(size, layout)
  }
}

pub fn elevation_to_text_shadow_tokens(elevation) {
  elevation_to_text_shadow_token(elevation)
  |> theme.token_to_list
}

pub fn elevation_to_text_shadow_token(elevation) {
  case elevation {
    theme.ElevationFlat -> "text-shadow-none" |> theme.Class
    theme.ElevationInner -> "text-shadow-2xs" |> theme.Class
    theme.ElevationLow -> "text-shadow-xs" |> theme.Class
    theme.ElevationMedium -> "text-shadow-md" |> theme.Class
    theme.ElevationHigh -> "text-shadow-lg" |> theme.Class
    theme.ElevationAncestor(_) -> "text-shadow-inherit" |> theme.Class
    theme.Elevation(size:, layout: _) ->
      case size {
        theme.SizeAncestor(anc) ->
          elevation_to_text_shadow_token(theme.ElevationAncestor(anc))
        theme.SizeXxl -> "text-shadow-lg/40" |> theme.Class
        theme.SizeXl -> "text-shadow-lg/30" |> theme.Class
        theme.SizeLg -> "text-shadow-lg/20" |> theme.Class
        theme.SizeMd -> "text-shadow-md/20" |> theme.Class
        theme.SizeSm -> "text-shadow-sm/20" |> theme.Class
        theme.SizeXs -> "text-shadow-xs/20" |> theme.Class
      }
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

pub fn size_to_height_width_tokens(size: theme.UISize) {
  size_to_height_width_token(size)
  |> theme.token_to_list
}

pub fn size_to_height_token(size) {
  case size {
    theme.SizeAncestor(_) -> "h-inherit"
    theme.SizeXxl -> "h-18"
    theme.SizeXl -> "h-16"
    theme.SizeLg -> "h-14"
    theme.SizeMd -> "h-12"
    theme.SizeSm -> "h-10"
    theme.SizeXs -> "h-8"
  }
  |> theme.Class
}

pub fn size_to_width_token(size) {
  case size {
    theme.SizeAncestor(_) -> "w-inherit"
    theme.SizeXxl -> "w-18"
    theme.SizeXl -> "w-16"
    theme.SizeLg -> "w-14"
    theme.SizeMd -> "w-12"
    theme.SizeSm -> "w-10"
    theme.SizeXs -> "w-8"
  }
  |> theme.Class
}

// -----------------------------------------------------------------------------
//
// -- 🛠️ HELPERS THEME **UILayout**
//
// -----------------------------------------------------------------------------

pub fn layout_to_tokens(layout: theme.UILayout) {
  case layout {
    theme.LayoutDefault | theme.LayoutAncestor(_) -> [theme.Empty]
    theme.LayoutFlow(layout) -> layout_flow_to_token(layout)
    theme.LayoutAbsolute(layout) -> absolute_to_layout_token(layout)
  }
}

pub fn layout_flow_to_tokens(layout: theme.UIFlow) {
  layout_flow_to_token(layout)
  |> theme.token_to_list
}

/// Tema de layout para tokens tailwind.
///
pub fn layout_flow_to_token(layout: theme.UIFlow) {
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
  alignment_to_items_token(align)
  |> theme.token_to_list
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
  |> theme.Class
}

pub fn alignment_to_content_tokens(align: theme.UIAlignment) {
  alignment_to_content_token(align)
  |> theme.token_to_list
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
  |> theme.Class
}

pub fn alignment_to_justify_tokens(align: theme.UIAlignment) {
  alignment_to_justify_token(align)
  |> theme.token_to_list
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
  |> theme.Class
}

// -----------------------------------------------------------------------------
//
// -- 🛠️ HELPERS THEME **UIAbsolute**
//
// -----------------------------------------------------------------------------

/// Processa o modelo de posicionamento absoluto, já injetando a classe 'absolute'
pub fn absolute_to_layout_token(absolute: theme.UIAbsolute) {
  let absolute = case absolute {
    theme.AxisX(x) -> [horizontal_to_layout_token(x)]
    theme.AxisY(y) -> [vertical_to_layout_token(y)]
    theme.Axis(horizontal:, vertical:) -> [
      horizontal_to_layout_token(horizontal),
      vertical_to_layout_token(vertical),
    ]
  }

  [theme.Class("absolute"), ..absolute]
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
  |> theme.Class
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
  |> theme.Class
}

// -----------------------------------------------------------------------------
//
// -- 🛠️ HELPERS THEME `border-` UISize x UILayout
//
// -----------------------------------------------------------------------------

pub fn size_layout_to_border_token(size: theme.UISize, layout: theme.UILayout) {
  case layout {
    theme.LayoutDefault -> theme.Empty
    theme.LayoutAncestor(_) -> theme.Class("border-inherit")
    theme.LayoutFlow(flow) -> size_layout_flow_to_border_token(size, flow)
    theme.LayoutAbsolute(absolute) ->
      size_absolute_to_border_token(size, absolute)
  }
}

pub fn size_layout_flow_to_border_token(
  size: theme.UISize,
  layout: theme.UIFlow,
) {
  case layout {
    // Para simplificar a herança de layout, priorizamos o eixo 'main'
    theme.Flow(main, _, _)
    | theme.FlowItems(main, _)
    | theme.FlowContent(main, _) -> size_alignment_to_border_token(size, main)

    theme.Main(align) | theme.CrossContent(align) | theme.CrossItems(align) ->
      size_alignment_to_border_token(size, align)
  }
}

pub fn size_alignment_to_border_token(
  size: theme.UISize,
  alignment: theme.UIAlignment,
) {
  case alignment {
    theme.Start -> size_to_border_start(size)
    theme.End -> size_to_border_end(size)
    theme.SpaceBetween -> size_to_border_start_start(size)
    theme.SpaceAround -> size_to_border_start_end(size)
    theme.SpaceEvenly -> size_border_end_end(size)
    theme.Stretch -> size_to_border_end_start(size)
    theme.Center -> size_to_border_all(size)
  }
}

pub fn size_absolute_to_border_token(
  size: theme.UISize,
  absolute: theme.UIAbsolute,
) {
  case absolute {
    theme.AxisY(theme.Start) -> size_to_border_top(size)
    theme.AxisY(theme.End) -> size_to_border_bottom(size)
    theme.AxisX(theme.Start) -> size_to_border_left(size)
    theme.AxisX(theme.End) -> size_to_border_right(size)

    // Combinações (X, Y) mapeadas para os cantos exatos
    theme.Axis(theme.Start, theme.Start) -> size_to_border_top_left(size)
    theme.Axis(theme.Start, theme.End) -> size_to_border_bottom_left(size)
    theme.Axis(theme.End, theme.Start) -> size_to_border_top_right(size)
    theme.Axis(theme.End, theme.End) -> size_to_border_bottom_right(size)

    // combinação Center e outras
    _ -> size_to_border_all(size)
  }
}

pub fn size_to_border_all(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-2xl"
    theme.SizeXl -> "border-xl"
    theme.SizeLg -> "border-lg"
    theme.SizeMd -> "border-md"
    theme.SizeSm -> "border-sm"
    theme.SizeXs -> "border-xs"
    theme.SizeAncestor(_) -> "border-inherit"
  }
  |> theme.Class
}

pub fn size_to_border_top(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-t-2xl"
    theme.SizeXl -> "border-t-xl"
    theme.SizeLg -> "border-t-lg"
    theme.SizeMd -> "border-t-md"
    theme.SizeSm -> "border-t-sm"
    theme.SizeXs -> "border-t-xs"
    theme.SizeAncestor(_) -> "border-t-inherit"
  }
  |> theme.Class
}

pub fn size_to_border_bottom(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-b-2xl"
    theme.SizeXl -> "border-b-xl"
    theme.SizeLg -> "border-b-lg"
    theme.SizeMd -> "border-b-md"
    theme.SizeSm -> "border-b-sm"
    theme.SizeXs -> "border-b-xs"
    theme.SizeAncestor(_) -> "border-b-inherit"
  }
  |> theme.Class
}

pub fn size_to_border_left(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-l-2xl"
    theme.SizeXl -> "border-l-xl"
    theme.SizeLg -> "border-l-lg"
    theme.SizeMd -> "border-l-md"
    theme.SizeSm -> "border-l-sm"
    theme.SizeXs -> "border-l-xs"
    theme.SizeAncestor(_) -> "border-l-inherit"
  }
  |> theme.Class
}

pub fn size_to_border_right(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-r-2xl"
    theme.SizeXl -> "border-r-xl"
    theme.SizeLg -> "border-r-lg"
    theme.SizeMd -> "border-r-md"
    theme.SizeSm -> "border-r-sm"
    theme.SizeXs -> "border-r-xs"
    theme.SizeAncestor(_) -> "border-r-inherit"
  }
  |> theme.Class
}

pub fn size_to_border_top_left(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-tl-2xl"
    theme.SizeXl -> "border-tl-xl"
    theme.SizeLg -> "border-tl-lg"
    theme.SizeMd -> "border-tl-md"
    theme.SizeSm -> "border-tl-sm"
    theme.SizeXs -> "border-tl-xs"
    theme.SizeAncestor(_) -> "border-tl-inherit"
  }
  |> theme.Class
}

pub fn size_to_border_top_right(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-tr-2xl"
    theme.SizeXl -> "border-tr-xl"
    theme.SizeLg -> "border-tr-lg"
    theme.SizeMd -> "border-tr-md"
    theme.SizeSm -> "border-tr-sm"
    theme.SizeXs -> "border-tr-xs"
    theme.SizeAncestor(_) -> "border-tr-inherit"
  }
  |> theme.Class
}

pub fn size_to_border_bottom_left(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-bl-2xl"
    theme.SizeXl -> "border-bl-xl"
    theme.SizeLg -> "border-bl-lg"
    theme.SizeMd -> "border-bl-md"
    theme.SizeSm -> "border-bl-sm"
    theme.SizeXs -> "border-bl-xs"
    theme.SizeAncestor(_) -> "border-bl-inherit"
  }
  |> theme.Class
}

pub fn size_to_border_bottom_right(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-br-2xl"
    theme.SizeXl -> "border-br-xl"
    theme.SizeLg -> "border-br-lg"
    theme.SizeMd -> "border-br-md"
    theme.SizeSm -> "border-br-sm"
    theme.SizeXs -> "border-br-xs"
    theme.SizeAncestor(_) -> "border-br-inherit"
  }
  |> theme.Class
}

pub fn size_to_border_start(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-s-2xl"
    theme.SizeXl -> "border-s-xl"
    theme.SizeLg -> "border-s-lg"
    theme.SizeMd -> "border-s-md"
    theme.SizeSm -> "border-s-sm"
    theme.SizeXs -> "border-s-xs"
    theme.SizeAncestor(_) -> "border-s-inherit"
  }
  |> theme.Class
}

pub fn size_to_border_end(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-e-2xl"
    theme.SizeXl -> "border-e-xl"
    theme.SizeLg -> "border-e-lg"
    theme.SizeMd -> "border-e-md"
    theme.SizeSm -> "border-e-sm"
    theme.SizeXs -> "border-e-xs"
    theme.SizeAncestor(_) -> "border-e-inherit"
  }
  |> theme.Class
}

pub fn size_to_border_start_start(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-ss-2xl"
    theme.SizeXl -> "border-ss-xl"
    theme.SizeLg -> "border-ss-lg"
    theme.SizeMd -> "border-ss-md"
    theme.SizeSm -> "border-ss-sm"
    theme.SizeXs -> "border-ss-xs"
    theme.SizeAncestor(_) -> "border-ss-inherit"
  }
  |> theme.Class
}

pub fn size_to_border_start_end(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-se-2xl"
    theme.SizeXl -> "border-se-xl"
    theme.SizeLg -> "border-se-lg"
    theme.SizeMd -> "border-se-md"
    theme.SizeSm -> "border-se-sm"
    theme.SizeXs -> "border-se-xs"
    theme.SizeAncestor(_) -> "border-se-inherit"
  }
  |> theme.Class
}

pub fn size_to_border_end_start(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-es-2xl"
    theme.SizeXl -> "border-es-xl"
    theme.SizeLg -> "border-es-lg"
    theme.SizeMd -> "border-es-md"
    theme.SizeSm -> "border-es-sm"
    theme.SizeXs -> "border-es-xs"
    theme.SizeAncestor(_) -> "border-es-inherit"
  }
  |> theme.Class
}

pub fn size_border_end_end(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-ee-2xl"
    theme.SizeXl -> "border-ee-xl"
    theme.SizeLg -> "border-ee-lg"
    theme.SizeMd -> "border-ee-md"
    theme.SizeSm -> "border-ee-sm"
    theme.SizeXs -> "border-ee-xs"
    theme.SizeAncestor(_) -> "border-ee-inherit"
  }
  |> theme.Class
}

// -----------------------------------------------------------------------------
//
// -- 🛠️ HELPERS THEME `rounded-` UISize x UILayout
//
// -----------------------------------------------------------------------------

pub fn size_layout_to_rounded_token(
  size: theme.UISize,
  layout: theme.UILayout,
) {
  case layout {
    theme.LayoutDefault -> theme.Empty
    theme.LayoutAncestor(_) -> theme.Class("rounded-inherit")
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
    theme.SizeAncestor(_) -> "rounded-inherit"
  }
  |> theme.Class
}

pub fn size_to_rounded_top(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-t-2xl"
    theme.SizeXl -> "rounded-t-xl"
    theme.SizeLg -> "rounded-t-lg"
    theme.SizeMd -> "rounded-t-md"
    theme.SizeSm -> "rounded-t-sm"
    theme.SizeXs -> "rounded-t-xs"
    theme.SizeAncestor(_) -> "rounded-t-inherit"
  }
  |> theme.Class
}

pub fn size_to_rounded_bottom(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-b-2xl"
    theme.SizeXl -> "rounded-b-xl"
    theme.SizeLg -> "rounded-b-lg"
    theme.SizeMd -> "rounded-b-md"
    theme.SizeSm -> "rounded-b-sm"
    theme.SizeXs -> "rounded-b-xs"
    theme.SizeAncestor(_) -> "rounded-b-inherit"
  }
  |> theme.Class
}

pub fn size_to_rounded_left(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-l-2xl"
    theme.SizeXl -> "rounded-l-xl"
    theme.SizeLg -> "rounded-l-lg"
    theme.SizeMd -> "rounded-l-md"
    theme.SizeSm -> "rounded-l-sm"
    theme.SizeXs -> "rounded-l-xs"
    theme.SizeAncestor(_) -> "rounded-l-inherit"
  }
  |> theme.Class
}

pub fn size_to_rounded_right(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-r-2xl"
    theme.SizeXl -> "rounded-r-xl"
    theme.SizeLg -> "rounded-r-lg"
    theme.SizeMd -> "rounded-r-md"
    theme.SizeSm -> "rounded-r-sm"
    theme.SizeXs -> "rounded-r-xs"
    theme.SizeAncestor(_) -> "rounded-r-inherit"
  }
  |> theme.Class
}

pub fn size_to_rounded_top_left(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-tl-2xl"
    theme.SizeXl -> "rounded-tl-xl"
    theme.SizeLg -> "rounded-tl-lg"
    theme.SizeMd -> "rounded-tl-md"
    theme.SizeSm -> "rounded-tl-sm"
    theme.SizeXs -> "rounded-tl-xs"
    theme.SizeAncestor(_) -> "rounded-tl-inherit"
  }
  |> theme.Class
}

pub fn size_to_rounded_top_right(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-tr-2xl"
    theme.SizeXl -> "rounded-tr-xl"
    theme.SizeLg -> "rounded-tr-lg"
    theme.SizeMd -> "rounded-tr-md"
    theme.SizeSm -> "rounded-tr-sm"
    theme.SizeXs -> "rounded-tr-xs"
    theme.SizeAncestor(_) -> "rounded-tr-inherit"
  }
  |> theme.Class
}

pub fn size_to_rounded_bottom_left(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-bl-2xl"
    theme.SizeXl -> "rounded-bl-xl"
    theme.SizeLg -> "rounded-bl-lg"
    theme.SizeMd -> "rounded-bl-md"
    theme.SizeSm -> "rounded-bl-sm"
    theme.SizeXs -> "rounded-bl-xs"
    theme.SizeAncestor(_) -> "rounded-bl-inherit"
  }
  |> theme.Class
}

pub fn size_to_rounded_bottom_right(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-br-2xl"
    theme.SizeXl -> "rounded-br-xl"
    theme.SizeLg -> "rounded-br-lg"
    theme.SizeMd -> "rounded-br-md"
    theme.SizeSm -> "rounded-br-sm"
    theme.SizeXs -> "rounded-br-xs"
    theme.SizeAncestor(_) -> "rounded-br-inherit"
  }
  |> theme.Class
}

pub fn size_to_rounded_start(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-s-2xl"
    theme.SizeXl -> "rounded-s-xl"
    theme.SizeLg -> "rounded-s-lg"
    theme.SizeMd -> "rounded-s-md"
    theme.SizeSm -> "rounded-s-sm"
    theme.SizeXs -> "rounded-s-xs"
    theme.SizeAncestor(_) -> "rounded-s-inherit"
  }
  |> theme.Class
}

pub fn size_to_rounded_end(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-e-2xl"
    theme.SizeXl -> "rounded-e-xl"
    theme.SizeLg -> "rounded-e-lg"
    theme.SizeMd -> "rounded-e-md"
    theme.SizeSm -> "rounded-e-sm"
    theme.SizeXs -> "rounded-e-xs"
    theme.SizeAncestor(_) -> "rounded-e-inherit"
  }
  |> theme.Class
}

pub fn size_to_rounded_start_start(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-ss-2xl"
    theme.SizeXl -> "rounded-ss-xl"
    theme.SizeLg -> "rounded-ss-lg"
    theme.SizeMd -> "rounded-ss-md"
    theme.SizeSm -> "rounded-ss-sm"
    theme.SizeXs -> "rounded-ss-xs"
    theme.SizeAncestor(_) -> "rounded-ss-inherit"
  }
  |> theme.Class
}

pub fn size_to_rounded_start_end(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-se-2xl"
    theme.SizeXl -> "rounded-se-xl"
    theme.SizeLg -> "rounded-se-lg"
    theme.SizeMd -> "rounded-se-md"
    theme.SizeSm -> "rounded-se-sm"
    theme.SizeXs -> "rounded-se-xs"
    theme.SizeAncestor(_) -> "rounded-se-inherit"
  }
  |> theme.Class
}

pub fn size_to_rounded_end_start(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-es-2xl"
    theme.SizeXl -> "rounded-es-xl"
    theme.SizeLg -> "rounded-es-lg"
    theme.SizeMd -> "rounded-es-md"
    theme.SizeSm -> "rounded-es-sm"
    theme.SizeXs -> "rounded-es-xs"
    theme.SizeAncestor(_) -> "rounded-es-inherit"
  }
  |> theme.Class
}

pub fn size_rounded_end_end(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-ee-2xl"
    theme.SizeXl -> "rounded-ee-xl"
    theme.SizeLg -> "rounded-ee-lg"
    theme.SizeMd -> "rounded-ee-md"
    theme.SizeSm -> "rounded-ee-sm"
    theme.SizeXs -> "rounded-ee-xs"
    theme.SizeAncestor(_) -> "rounded-ee-inherit"
  }
  |> theme.Class
}

// -----------------------------------------------------------------------------
//
// -- HELPERS TAILWIND (HARD CODE)
//
// -----------------------------------------------------------------------------

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
