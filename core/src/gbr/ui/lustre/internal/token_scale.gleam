//// Internal scale, rounded, and border token helpers for `lustre/token`.

import gleam/option.{type Option}

import gbr/ui/lustre
import gbr/ui/theme

pub fn rounded_class(prefix: String, size: theme.UISize) -> lustre.UILustre {
  let suffix = case size {
    theme.SizeXxl -> "3xl"
    theme.SizeXl -> "2xl"
    theme.SizeLg -> "xl"
    theme.SizeMd -> "lg"
    theme.SizeSm -> "md"
    theme.SizeXs -> "sm"
    theme.SizeXxs -> "xs"
  }
  lustre.Class(prefix <> suffix)
}

pub fn border_class(prefix: String, size: theme.UISize) -> lustre.UILustre {
  let suffix = case size {
    theme.SizeXxl -> "7"
    theme.SizeXl -> "6"
    theme.SizeLg -> "5"
    theme.SizeMd -> "4"
    theme.SizeSm -> "3"
    theme.SizeXs -> "2"
    theme.SizeXxs -> "1"
  }
  lustre.Class(prefix <> suffix)
}

pub fn shape_rounded_to_tokens(shape: theme.UIShape) -> List(lustre.UILustre) {
  case shape {
    theme.ShapeCircle -> [lustre.Class("rounded-full")]
    theme.ShapePill -> [lustre.Class("rounded-4xl")]
    theme.ShapeRounded -> [lustre.Class("rounded-2xl")]
    theme.ShapeSharp -> [lustre.Class("rounded-none")]
    theme.Shape(#(size, layout)) -> size_layout_to_rounded_tokens(size, layout)
  }
}

pub fn size_layout_to_rounded_tokens(
  size: theme.UISize,
  layout: theme.UILayout,
) -> List(lustre.UILustre) {
  case layout {
    theme.LayoutFlow(flow) -> [size_layout_flow_to_rounded_token(size, flow)]
    theme.LayoutAbsolute(absolute) ->
      size_absolute_to_rounded_tokens(size, absolute)
  }
}

pub fn size_layout_flow_to_rounded_token(
  size: theme.UISize,
  layout: theme.UIFlow,
) -> lustre.UILustre {
  let alignment = flow_main_alignment(layout)
  size_alignment_to_rounded_token(size, alignment)
}

pub fn size_alignment_to_rounded_token(
  size: theme.UISize,
  alignment: theme.UIAlignment,
) -> lustre.UILustre {
  let prefix = case alignment {
    theme.Start -> "rounded-s-"
    theme.End -> "rounded-e-"
    theme.SpaceBetween -> "rounded-ss-"
    theme.SpaceAround -> "rounded-se-"
    theme.SpaceEvenly -> "rounded-ee-"
    theme.Stretch -> "rounded-es-"
    theme.Center -> "rounded-"
  }
  rounded_class(prefix, size)
}

pub fn size_absolute_to_rounded_tokens(
  size: theme.UISize,
  absolute: theme.UIAbsolute,
) -> List(lustre.UILustre) {
  absolute_axis_prefixes(absolute)
  |> map_prefixes(fn(prefix) { rounded_class("rounded-" <> prefix, size) })
}

pub fn elevation_to_shadow_border_tokens(
  elevation: theme.UIElevation,
) -> List(lustre.UILustre) {
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

pub fn elevation_to_text_shadow_tokens(
  elevation: theme.UIElevation,
) -> List(lustre.UILustre) {
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

pub fn size_layout_to_border_tokens(
  size: theme.UISize,
  layout: theme.UILayout,
) -> List(lustre.UILustre) {
  case layout {
    theme.LayoutFlow(flow) -> [size_layout_flow_to_border_token(size, flow)]
    theme.LayoutAbsolute(absolute) ->
      size_absolute_to_border_tokens(size, absolute)
  }
}

pub fn size_layout_flow_to_border_token(
  size: theme.UISize,
  layout: theme.UIFlow,
) -> lustre.UILustre {
  let alignment = flow_main_alignment(layout)
  size_alignment_to_border_token(size, alignment)
}

pub fn size_alignment_to_border_token(
  size: theme.UISize,
  alignment: theme.UIAlignment,
) -> lustre.UILustre {
  let prefix = case alignment {
    theme.Start -> "border-s-"
    theme.End -> "border-e-"
    theme.SpaceBetween -> "border-ss-"
    theme.SpaceAround -> "border-se-"
    theme.SpaceEvenly -> "border-ee-"
    theme.Stretch -> "border-es-"
    theme.Center -> "border-"
  }
  border_class(prefix, size)
}

pub fn size_absolute_to_border_tokens(
  size: theme.UISize,
  absolute: theme.UIAbsolute,
) -> List(lustre.UILustre) {
  absolute_axis_prefixes(absolute)
  |> map_prefixes(fn(prefix) { border_class("border-" <> prefix, size) })
}

fn to_border_token(
  border: Option(theme.UISizeLayout),
) -> List(lustre.UILustre) {
  option.map(border, fn(border) {
    let #(size, layout) = border
    size_layout_to_border_tokens(size, layout)
  })
  |> option.unwrap([])
}

fn flow_main_alignment(layout: theme.UIFlow) -> theme.UIAlignment {
  case layout {
    theme.Flow(main, _, _)
    | theme.FlowItems(main, _)
    | theme.FlowContent(main, _) -> main
    theme.Main(alignment)
    | theme.CrossContent(alignment)
    | theme.CrossItems(alignment) -> alignment
  }
}

fn absolute_axis_prefixes(absolute: theme.UIAbsolute) -> List(String) {
  case absolute {
    theme.Axis(theme.Center, theme.Start) | theme.AxisY(theme.Start) -> ["t-"]
    theme.Axis(theme.Start, theme.Center) | theme.AxisX(theme.Start) -> ["l-"]
    theme.Axis(theme.Center, theme.End) | theme.AxisY(theme.End) -> ["b-"]
    theme.Axis(theme.End, theme.Center) | theme.AxisX(theme.End) -> ["r-"]
    theme.Axis(horizontal, vertical) -> axis_pair_prefixes(horizontal, vertical)
    _ -> [""]
  }
}

fn axis_pair_prefixes(
  horizontal: theme.UIAlignment,
  vertical: theme.UIAlignment,
) -> List(String) {
  case horizontal, vertical {
    theme.Start, theme.Start -> ["tl-"]
    theme.Start, theme.End -> ["bl-"]
    theme.SpaceBetween, theme.Start | theme.Start, theme.SpaceBetween -> [
      "tl-",
      "br-",
    ]
    theme.Start, theme.SpaceAround -> ["t-", "l-"]
    theme.End, theme.Start -> ["tr-"]
    theme.End, theme.End -> ["br-"]
    theme.SpaceBetween, theme.End | theme.End, theme.SpaceBetween -> [
      "bl-",
      "tr-",
    ]
    theme.End, theme.SpaceAround -> ["t-", "r-"]
    theme.SpaceAround, theme.Start -> ["b-", "r-"]
    theme.SpaceAround, theme.End -> ["b-", "l-"]
    _, _ -> [""]
  }
}

fn map_prefixes(
  prefixes: List(String),
  to_token: fn(String) -> lustre.UILustre,
) -> List(lustre.UILustre) {
  case prefixes {
    [] -> []
    [prefix, ..rest] -> [to_token(prefix), ..map_prefixes(rest, to_token)]
  }
}
