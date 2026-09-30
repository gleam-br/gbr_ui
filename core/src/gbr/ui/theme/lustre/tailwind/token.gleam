////
//// UI Lustre Tailwind Module
////

import gbr/ui/theme
import gbr/ui/theme/lustre
import gleam/option

// -----------------------------------------------------------------------------
//
// -- 🛠️ HELPERS THEME **UIShape**
//
// -----------------------------------------------------------------------------

/// Retorna o token da superfície do tema em arredondamento do tailwind.
///
pub fn shape_rounded_to_tokens(shape: theme.UIShape) {
  case shape {
    theme.ShapeCircle -> [lustre.Class("rounded-full")]
    theme.ShapePill -> [lustre.Class("rounded-4xl")]
    theme.ShapeRounded -> [lustre.Class("rounded-2xl")]
    theme.ShapeSharp -> [lustre.Class("rounded-none")]
    theme.Shape(#(size, layout)) -> size_layout_to_rounded_tokens(size, layout)
  }
}

// -----------------------------------------------------------------------------
// **ROUNDED-**
//
// -- 🛠️ HELPERS THEME `rounded-` UISize x UILayout
//
// -----------------------------------------------------------------------------

pub fn size_layout_to_rounded_tokens(size, layout) {
  case layout {
    theme.LayoutFlow(flow) -> [size_layout_flow_to_rounded_token(size, flow)]
    theme.LayoutAbsolute(absolute) ->
      size_absolute_to_rounded_tokens(size, absolute)
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

pub fn size_absolute_to_rounded_tokens(
  size: theme.UISize,
  absolute: theme.UIAbsolute,
) {
  case absolute {
    theme.Axis(theme.Center, theme.Start) | theme.AxisY(theme.Start) -> [
      size_to_rounded_top(size),
    ]
    theme.Axis(theme.Start, theme.Center) | theme.AxisX(theme.Start) -> [
      size_to_rounded_left(size),
    ]
    theme.Axis(theme.Center, theme.End) | theme.AxisY(theme.End) -> [
      size_to_rounded_bottom(size),
    ]
    theme.Axis(theme.End, theme.Center) | theme.AxisX(theme.End) -> [
      size_to_rounded_right(size),
    ]

    // Combinações (X, Y) mapeadas para os cantos exatos
    theme.Axis(theme.Start, theme.Start) -> [size_to_rounded_top_left(size)]
    theme.Axis(theme.Start, theme.End) -> [size_to_rounded_bottom_left(size)]
    theme.Axis(theme.SpaceBetween, theme.Start)
    | theme.Axis(theme.Start, theme.SpaceBetween) -> [
      size_to_rounded_top_left(size),
      size_to_rounded_bottom_right(size),
    ]
    theme.Axis(theme.Start, theme.SpaceAround) -> [
      size_to_rounded_top(size),
      size_to_rounded_left(size),
    ]

    theme.Axis(theme.End, theme.Start) -> [size_to_rounded_top_right(size)]
    theme.Axis(theme.End, theme.End) -> [size_to_rounded_bottom_right(size)]
    theme.Axis(theme.SpaceBetween, theme.End)
    | theme.Axis(theme.End, theme.SpaceBetween) -> [
      size_to_rounded_bottom_left(size),
      size_to_rounded_top_right(size),
    ]
    theme.Axis(theme.End, theme.SpaceAround) -> [
      size_to_rounded_top(size),
      size_to_rounded_right(size),
    ]

    theme.Axis(theme.SpaceAround, theme.Start) -> [
      size_to_rounded_bottom(size),
      size_to_rounded_right(size),
    ]
    theme.Axis(theme.SpaceAround, theme.End) -> [
      size_to_rounded_bottom(size),
      size_to_rounded_left(size),
    ]

    // fallback p/ combinações usando evenly e stretch
    _ -> [size_to_rounded_all(size)]
  }
}

pub fn size_to_rounded_all(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-3xl"
    theme.SizeXl -> "rounded-2xl"
    theme.SizeLg -> "rounded-xl"
    theme.SizeMd -> "rounded-lg"
    theme.SizeSm -> "rounded-md"
    theme.SizeXs -> "rounded-sm"
    theme.SizeXxs -> "rounded-xs"
  }
  |> lustre.Class
}

pub fn size_to_rounded_top(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-t-3xl"
    theme.SizeXl -> "rounded-t-2xl"
    theme.SizeLg -> "rounded-t-xl"
    theme.SizeMd -> "rounded-t-lg"
    theme.SizeSm -> "rounded-t-md"
    theme.SizeXs -> "rounded-t-sm"
    theme.SizeXxs -> "rounded-t-xs"
  }
  |> lustre.Class
}

pub fn size_to_rounded_bottom(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-b-3xl"
    theme.SizeXl -> "rounded-b-2xl"
    theme.SizeLg -> "rounded-b-xl"
    theme.SizeMd -> "rounded-b-lg"
    theme.SizeSm -> "rounded-b-md"
    theme.SizeXs -> "rounded-b-sm"
    theme.SizeXxs -> "rounded-b-xs"
  }
  |> lustre.Class
}

pub fn size_to_rounded_left(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-l-3xl"
    theme.SizeXl -> "rounded-l-2xl"
    theme.SizeLg -> "rounded-l-xl"
    theme.SizeMd -> "rounded-l-lg"
    theme.SizeSm -> "rounded-l-md"
    theme.SizeXs -> "rounded-l-sm"
    theme.SizeXxs -> "rounded-l-xs"
  }
  |> lustre.Class
}

pub fn size_to_rounded_right(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-r-3xl"
    theme.SizeXl -> "rounded-r-2xl"
    theme.SizeLg -> "rounded-r-xl"
    theme.SizeMd -> "rounded-r-lg"
    theme.SizeSm -> "rounded-r-md"
    theme.SizeXs -> "rounded-r-sm"
    theme.SizeXxs -> "rounded-r-xs"
  }
  |> lustre.Class
}

pub fn size_to_rounded_top_left(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-tl-3xl"
    theme.SizeXl -> "rounded-tl-2xl"
    theme.SizeLg -> "rounded-tl-xl"
    theme.SizeMd -> "rounded-tl-lg"
    theme.SizeSm -> "rounded-tl-md"
    theme.SizeXs -> "rounded-tl-sm"
    theme.SizeXxs -> "rounded-tl-xs"
  }
  |> lustre.Class
}

pub fn size_to_rounded_top_right(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-tr-3xl"
    theme.SizeXl -> "rounded-tr-2xl"
    theme.SizeLg -> "rounded-tr-xl"
    theme.SizeMd -> "rounded-tr-lg"
    theme.SizeSm -> "rounded-tr-md"
    theme.SizeXs -> "rounded-tr-sm"
    theme.SizeXxs -> "rounded-tr-xs"
  }
  |> lustre.Class
}

pub fn size_to_rounded_bottom_left(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-bl-3xl"
    theme.SizeXl -> "rounded-bl-2xl"
    theme.SizeLg -> "rounded-bl-xl"
    theme.SizeMd -> "rounded-bl-lg"
    theme.SizeSm -> "rounded-bl-md"
    theme.SizeXs -> "rounded-bl-sm"
    theme.SizeXxs -> "rounded-bl-xs"
  }
  |> lustre.Class
}

pub fn size_to_rounded_bottom_right(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-br-3xl"
    theme.SizeXl -> "rounded-br-2xl"
    theme.SizeLg -> "rounded-br-xl"
    theme.SizeMd -> "rounded-br-lg"
    theme.SizeSm -> "rounded-br-md"
    theme.SizeXs -> "rounded-br-sm"
    theme.SizeXxs -> "rounded-br-xs"
  }
  |> lustre.Class
}

pub fn size_to_rounded_start(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-s-3xl"
    theme.SizeXl -> "rounded-s-2xl"
    theme.SizeLg -> "rounded-s-xl"
    theme.SizeMd -> "rounded-s-lg"
    theme.SizeSm -> "rounded-s-md"
    theme.SizeXs -> "rounded-s-sm"
    theme.SizeXxs -> "rounded-s-xs"
  }
  |> lustre.Class
}

pub fn size_to_rounded_end(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-e-3xl"
    theme.SizeXl -> "rounded-e-2xl"
    theme.SizeLg -> "rounded-e-xl"
    theme.SizeMd -> "rounded-e-lg"
    theme.SizeSm -> "rounded-e-md"
    theme.SizeXs -> "rounded-e-sm"
    theme.SizeXxs -> "rounded-e-xs"
  }
  |> lustre.Class
}

pub fn size_to_rounded_start_start(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-ss-3xl"
    theme.SizeXl -> "rounded-ss-2xl"
    theme.SizeLg -> "rounded-ss-xl"
    theme.SizeMd -> "rounded-ss-lg"
    theme.SizeSm -> "rounded-ss-md"
    theme.SizeXs -> "rounded-ss-sm"
    theme.SizeXxs -> "rounded-ss-xs"
  }
  |> lustre.Class
}

pub fn size_to_rounded_start_end(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-se-3xl"
    theme.SizeXl -> "rounded-se-2xl"
    theme.SizeLg -> "rounded-se-xl"
    theme.SizeMd -> "rounded-se-lg"
    theme.SizeSm -> "rounded-se-md"
    theme.SizeXs -> "rounded-se-sm"
    theme.SizeXxs -> "rounded-se-xs"
  }
  |> lustre.Class
}

pub fn size_to_rounded_end_start(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-es-3xl"
    theme.SizeXl -> "rounded-es-2xl"
    theme.SizeLg -> "rounded-es-xl"
    theme.SizeMd -> "rounded-es-lg"
    theme.SizeSm -> "rounded-es-md"
    theme.SizeXs -> "rounded-es-sm"
    theme.SizeXxs -> "rounded-es-xs"
  }
  |> lustre.Class
}

pub fn size_rounded_end_end(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "rounded-ee-3xl"
    theme.SizeXl -> "rounded-ee-2xl"
    theme.SizeLg -> "rounded-ee-xl"
    theme.SizeMd -> "rounded-ee-lg"
    theme.SizeSm -> "rounded-ee-md"
    theme.SizeXs -> "rounded-ee-sm"
    theme.SizeXxs -> "rounded-ee-xs"
  }
  |> lustre.Class
}

// -----------------------------------------------------------------------------
//
// -- 🛠️ HELPERS THEME **UIElevation**
//
// -----------------------------------------------------------------------------

/// Converte a elevação do tema em bordas tailwind.
///
pub fn elevation_to_shadow_border_tokens(elevation) {
  case elevation {
    theme.ElevationFlat(border) -> to_border_token(border)

    theme.ElevationInner(border) -> [
      lustre.Class("shadow-inner"),
      ..to_border_token(border)
    ]
    theme.ElevationThin(border) -> [
      lustre.Class("shadow-sm"),
      ..to_border_token(border)
    ]
    theme.ElevationLow(border) -> [
      lustre.Class("shadow-md"),
      ..to_border_token(border)
    ]
    theme.ElevationMedium(border) -> [
      lustre.Class("shadow-lg"),
      ..to_border_token(border)
    ]
    theme.ElevationHigh(border) -> [
      lustre.Class("shadow-xl"),
      ..to_border_token(border)
    ]
  }
}

pub fn elevation_to_text_shadow_tokens(elevation) {
  case elevation {
    theme.ElevationFlat(border) -> to_border_token(border)

    theme.ElevationInner(border) -> [
      lustre.Class("text-shadow-inner"),
      ..to_border_token(border)
    ]
    theme.ElevationThin(border) -> [
      lustre.Class("text-shadow-xs"),
      ..to_border_token(border)
    ]
    theme.ElevationLow(border) -> [
      lustre.Class("text-shadow-xs"),
      ..to_border_token(border)
    ]
    theme.ElevationMedium(border) -> [
      lustre.Class("text-shadow-md"),
      ..to_border_token(border)
    ]
    theme.ElevationHigh(border) -> [
      lustre.Class("text-shadow-lg"),
      ..to_border_token(border)
    ]
  }
}

fn to_border_token(border) {
  border
  |> size_layout_convert_to(size_layout_to_border_tokens)
}

// -----------------------------------------------------------------------------
// **BORDER-**
//
// -- 🛠️ HELPERS THEME `border-` UISize x UILayout
//
// -----------------------------------------------------------------------------

pub fn size_layout_to_border_tokens(size, layout) {
  case layout {
    theme.LayoutFlow(flow) -> [size_layout_flow_to_border_token(size, flow)]
    theme.LayoutAbsolute(absolute) ->
      size_absolute_to_border_tokens(size, absolute)
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

pub fn size_absolute_to_border_tokens(
  size: theme.UISize,
  absolute: theme.UIAbsolute,
) {
  case absolute {
    theme.Axis(theme.Center, theme.Start) | theme.AxisY(theme.Start) -> [
      size_to_border_top(size),
    ]
    theme.Axis(theme.Start, theme.Center) | theme.AxisX(theme.Start) -> [
      size_to_border_left(size),
    ]
    theme.Axis(theme.Center, theme.End) | theme.AxisY(theme.End) -> [
      size_to_border_bottom(size),
    ]
    theme.Axis(theme.End, theme.Center) | theme.AxisX(theme.End) -> [
      size_to_border_right(size),
    ]

    // Combinações (X, Y) mapeadas para os cantos exatos
    theme.Axis(theme.Start, theme.Start) -> [size_to_border_top_left(size)]
    theme.Axis(theme.Start, theme.End) -> [size_to_border_bottom_left(size)]
    theme.Axis(theme.SpaceBetween, theme.Start)
    | theme.Axis(theme.Start, theme.SpaceBetween) -> [
      size_to_border_top_left(size),
      size_to_border_bottom_right(size),
    ]
    theme.Axis(theme.Start, theme.SpaceAround) -> [
      size_to_border_top(size),
      size_to_border_left(size),
    ]

    theme.Axis(theme.End, theme.Start) -> [size_to_border_top_right(size)]
    theme.Axis(theme.End, theme.End) -> [size_to_border_bottom_right(size)]
    theme.Axis(theme.SpaceBetween, theme.End)
    | theme.Axis(theme.End, theme.SpaceBetween) -> [
      size_to_border_bottom_left(size),
      size_to_border_top_right(size),
    ]
    theme.Axis(theme.End, theme.SpaceAround) -> [
      size_to_border_top(size),
      size_to_border_right(size),
    ]

    theme.Axis(theme.SpaceAround, theme.Start) -> [
      size_to_border_bottom(size),
      size_to_border_right(size),
    ]
    theme.Axis(theme.SpaceAround, theme.End) -> [
      size_to_border_bottom(size),
      size_to_border_left(size),
    ]

    // fallback p/ combinações usando evenly e stretch
    _ -> [size_to_border_all(size)]
  }
}

pub fn size_to_border_all(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-7"
    theme.SizeXl -> "border-6"
    theme.SizeLg -> "border-5"
    theme.SizeMd -> "border-4"
    theme.SizeSm -> "border-3"
    theme.SizeXs -> "border-2"
    theme.SizeXxs -> "border-1"
  }
  |> lustre.Class
}

pub fn size_to_border_top(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-t-7"
    theme.SizeXl -> "border-t-6"
    theme.SizeLg -> "border-t-5"
    theme.SizeMd -> "border-t-4"
    theme.SizeSm -> "border-t-3"
    theme.SizeXs -> "border-t-2"
    theme.SizeXxs -> "border-t-1"
  }
  |> lustre.Class
}

pub fn size_to_border_bottom(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-b-7"
    theme.SizeXl -> "border-b-6"
    theme.SizeLg -> "border-b-5"
    theme.SizeMd -> "border-b-4"
    theme.SizeSm -> "border-b-3"
    theme.SizeXs -> "border-b-2"
    theme.SizeXxs -> "border-b-1"
  }
  |> lustre.Class
}

pub fn size_to_border_left(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-l-7"
    theme.SizeXl -> "border-l-6"
    theme.SizeLg -> "border-l-5"
    theme.SizeMd -> "border-l-4"
    theme.SizeSm -> "border-l-3"
    theme.SizeXs -> "border-l-2"
    theme.SizeXxs -> "border-l-1"
  }
  |> lustre.Class
}

pub fn size_to_border_right(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-r-7"
    theme.SizeXl -> "border-r-6"
    theme.SizeLg -> "border-r-5"
    theme.SizeMd -> "border-r-4"
    theme.SizeSm -> "border-r-3"
    theme.SizeXs -> "border-r-2"
    theme.SizeXxs -> "border-r-1"
  }
  |> lustre.Class
}

pub fn size_to_border_top_left(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-tl-7"
    theme.SizeXl -> "border-tl-6"
    theme.SizeLg -> "border-tl-5"
    theme.SizeMd -> "border-tl-4"
    theme.SizeSm -> "border-tl-3"
    theme.SizeXs -> "border-tl-2"
    theme.SizeXxs -> "border-tl-1"
  }
  |> lustre.Class
}

pub fn size_to_border_top_right(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-tr-7"
    theme.SizeXl -> "border-tr-6"
    theme.SizeLg -> "border-tr-5"
    theme.SizeMd -> "border-tr-4"
    theme.SizeSm -> "border-tr-3"
    theme.SizeXs -> "border-tr-2"
    theme.SizeXxs -> "border-tr-1"
  }
  |> lustre.Class
}

pub fn size_to_border_bottom_left(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-bl-7"
    theme.SizeXl -> "border-bl-6"
    theme.SizeLg -> "border-bl-5"
    theme.SizeMd -> "border-bl-4"
    theme.SizeSm -> "border-bl-3"
    theme.SizeXs -> "border-bl-2"
    theme.SizeXxs -> "border-bl-1"
  }
  |> lustre.Class
}

pub fn size_to_border_bottom_right(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-br-7"
    theme.SizeXl -> "border-br-6"
    theme.SizeLg -> "border-br-5"
    theme.SizeMd -> "border-br-4"
    theme.SizeSm -> "border-br-3"
    theme.SizeXs -> "border-br-2"
    theme.SizeXxs -> "border-br-1"
  }
  |> lustre.Class
}

pub fn size_to_border_start(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-s-7"
    theme.SizeXl -> "border-s-6"
    theme.SizeLg -> "border-s-5"
    theme.SizeMd -> "border-s-4"
    theme.SizeSm -> "border-s-3"
    theme.SizeXs -> "border-s-2"
    theme.SizeXxs -> "border-s-1"
  }
  |> lustre.Class
}

pub fn size_to_border_end(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-e-7"
    theme.SizeXl -> "border-e-6"
    theme.SizeLg -> "border-e-5"
    theme.SizeMd -> "border-e-4"
    theme.SizeSm -> "border-e-3"
    theme.SizeXs -> "border-e-2"
    theme.SizeXxs -> "border-e-1"
  }
  |> lustre.Class
}

pub fn size_to_border_start_start(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-ss-7"
    theme.SizeXl -> "border-ss-6"
    theme.SizeLg -> "border-ss-5"
    theme.SizeMd -> "border-ss-4"
    theme.SizeSm -> "border-ss-3"
    theme.SizeXs -> "border-ss-2"
    theme.SizeXxs -> "border-ss-1"
  }
  |> lustre.Class
}

pub fn size_to_border_start_end(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-se-7"
    theme.SizeXl -> "border-se-6"
    theme.SizeLg -> "border-se-5"
    theme.SizeMd -> "border-se-4"
    theme.SizeSm -> "border-se-3"
    theme.SizeXs -> "border-se-2"
    theme.SizeXxs -> "border-se-1"
  }
  |> lustre.Class
}

pub fn size_to_border_end_start(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-es-7"
    theme.SizeXl -> "border-es-6"
    theme.SizeLg -> "border-es-5"
    theme.SizeMd -> "border-es-4"
    theme.SizeSm -> "border-es-3"
    theme.SizeXs -> "border-es-2"
    theme.SizeXxs -> "border-es-1"
  }
  |> lustre.Class
}

pub fn size_border_end_end(size: theme.UISize) {
  case size {
    theme.SizeXxl -> "border-ee-7"
    theme.SizeXl -> "border-ee-6"
    theme.SizeLg -> "border-ee-5"
    theme.SizeMd -> "border-ee-4"
    theme.SizeSm -> "border-ee-3"
    theme.SizeXs -> "border-ee-2"
    theme.SizeXxs -> "border-ee-1"
  }
  |> lustre.Class
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
  }
  |> lustre.Class
}

// -----------------------------------------------------------------------------
//
// -- 🛠️ HELPERS THEME **UISize**
//
// -----------------------------------------------------------------------------

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
        #("text-3xl sm:text-4xl", text_token == TextBase),
      ]
      theme.SizeXl -> [
        #("text-theme-xl sm:text-theme-2xl", text_token == TextTheme),
        #("text-title-xl sm:text-title-2xl", text_token == TextTitle),
        #("text-2xl sm:text-3xl", text_token == TextBase),
      ]
      theme.SizeLg -> [
        #("text-theme-lg sm:text-theme-xl", text_token == TextTheme),
        #("text-title-lg sm:text-title-xl", text_token == TextTitle),
        #("text-xl sm:text-2xl", text_token == TextBase),
      ]
      theme.SizeMd -> [
        #("text-theme-md sm:text-theme-lg", text_token == TextTheme),
        #("text-title-md sm:text-title-lg", text_token == TextTitle),
        #("text-md sm:text-lg", text_token == TextBase),
      ]
      theme.SizeSm -> [
        #("text-theme-sm sm:text-theme-md", text_token == TextTheme),
        #("text-title-sm sm:text-title-md", text_token == TextTitle),
        #("text-sm sm:text-md", text_token == TextBase),
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
  }
  |> lustre.Class
}

pub fn size_icon_height_class(size) {
  case size {
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
  }
}

pub fn size_to_shadown_token(size) {
  case size {
    theme.SizeXxl -> "shadow-2xl"
    theme.SizeXl -> "shadow-xl"
    theme.SizeLg -> "shadow-lg"
    theme.SizeMd -> "shadow-md"
    theme.SizeSm -> "shadow-sm"
    theme.SizeXs -> "shadow-xs"
    theme.SizeXxs -> "shadow-2xs"
  }
  |> lustre.Class()
}

fn size_layout_convert_to(size_layout, convert_to) -> List(lustre.UILustre) {
  option.map(size_layout, fn(border) {
    let #(size, layout) = border
    convert_to(size, layout)
  })
  |> option.unwrap([])
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
