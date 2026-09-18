////
////
////

import gleam/dynamic/decode

import gbr/ui/storybook.{decode_field, decode_field_try}
import gbr/ui/theme

pub fn decode_field_variant(args, field, fallback) {
  decode_field(args, field, fallback, decode_variant)
}

pub fn decode_field_appearance(args, field, fallback) {
  decode_field(args, field, fallback, decode_appearance)
}

pub fn decode_field_state(args, field, fallback) {
  decode_field(args, field, fallback, decode_state)
}

pub fn decode_field_size(args, field, fallback) {
  decode_field(args, field, fallback, decode_size)
}

pub fn decode_field_shape(args, field, fallback) {
  let size = decode_field_size(args, field <> ".size", theme.SizeMd)
  let layout =
    decode_field_layout(args, field <> ".layout", theme.LayoutDefault)

  decode_field(args, field, fallback, decode_shape(size, layout))
}

pub fn decode_field_elevation(args, field, fallback) {
  let size = decode_field_size(args, field <> ".size", theme.SizeMd)

  decode_field(args, field, fallback, decode_elevation(size))
}

pub fn decoode_field_stacking(args, field, fallback) {
  decode_field(args, field, fallback, decode_stacking)
}

pub fn decode_field_layout(args, field, fallback) {
  let flow =
    decode_field_layout_flow(args, field <> ".flow", theme.Main(theme.Center))
  let absolute =
    decode_field_layout_absolute(
      args,
      field <> ".absolute",
      theme.AxisX(theme.Center),
    )

  decode_field(args, field, fallback, decode_layout(flow, absolute))
}

pub fn decode_field_layout_flow(args, field, fallback) {
  let value = storybook.decode(args, field, "main", decode.string)

  case value {
    "main" -> {
      let main =
        decode_field_layout_align(
          args |> echo,
          field <> ".cross_" <> value <> ".align",
          theme.Center,
        )
      decode_field(
        args,
        field,
        fallback,
        decode_flow(main, theme.Center, theme.Center),
      )
    }
    "flow" -> {
      echo field <> "." <> value
      let main =
        decode_field_layout_align(
          args,
          field <> "." <> value <> ".main.align",
          theme.Center,
        )
      let flow_items =
        decode_field_layout_align(
          args,
          field <> "." <> value <> ".items." <> "align",
          theme.Center,
        )
      let flow_content =
        decode_field_layout_align(
          args,
          field <> "." <> value <> ".content." <> "align",
          theme.Center,
        )

      decode_field(
        args,
        field,
        fallback,
        decode_flow(main, flow_items, flow_content),
      )
    }
    "flow_" <> _ -> {
      let main =
        decode_field_layout_align(
          args,
          field <> "." <> value <> ".main.align",
          theme.Center,
        )
      let flow =
        decode_field_layout_align(
          args,
          field <> value <> "." <> "align",
          theme.Center,
        )

      decode_field(args, field, fallback, decode_flow(main, flow, flow))
    }
    "cross_" <> _ -> {
      let main =
        decode_field_layout_align(
          args,
          field <> "." <> value <> ".main.align",
          theme.Center,
        )
      decode_field(
        args,
        field,
        fallback,
        decode_flow(main, theme.Center, theme.Center),
      )
    }
    _ -> fallback
  }
}

pub fn decode_field_layout_absolute(args, field, fallback) {
  // fallback p/ quando selecionamos somente axisx, axis(x,y)
  let horizontal = case decode_field_try(args, field <> ".xx", decode.string) {
    Ok(horizontal) -> decode_align(horizontal)
    Error(_) -> decode_field_layout_align(args, field <> ".x", theme.Center)
  }
  // fallback p/ quando selecionamos somente axisy ou axis(x,y)
  let vertical = case decode_field_try(args, field <> ".yy", decode.string) {
    Ok(vertical) -> decode_align(vertical)
    Error(_) -> decode_field_layout_align(args, field <> ".y", theme.Center)
  }

  decode_field(args, field, fallback, decode_absolute(horizontal, vertical))
}

pub fn decode_field_layout_align(args, field, fallback) {
  decode_field(args, field, fallback, decode_align)
}

pub fn decode_variant(variant) {
  case variant {
    "primary" -> theme.VariantPrimary
    "secondary" -> theme.VariantSecondary
    "tertiary" -> theme.VariantTertiary
    "info" -> theme.VariantInfo
    "success" -> theme.VariantSuccess
    "warn" -> theme.VariantWarning
    "error" -> theme.VariantError
    _ -> theme.VariantDefault
  }
}

pub fn decode_appearance(appearance) {
  case appearance {
    "filled" -> theme.AppearanceFilled
    "ghost" -> theme.AppearanceGhost
    "light" -> theme.AppearanceLight
    "slit" -> theme.AppearanceSlit
    "thin" -> theme.AppearanceThin
    _ -> theme.AppearanceDefault
  }
}

pub fn decode_state(state) {
  case state {
    "disable" -> theme.StateDisabled
    "load" -> theme.StateLoading
    "focus" -> theme.StateFocus
    "hover" -> theme.StateHover
    "pressed" -> theme.StatePressed
    _ -> theme.StateIdle
  }
}

pub fn decode_shape(size, layout) {
  fn(value) {
    case value {
      "circle" -> theme.ShapeCircle
      "pill" -> theme.ShapePill
      "sharp" -> theme.ShapeSharp
      "shape" -> theme.Shape(size:, layout:)
      _ -> theme.ShapeDefault
    }
  }
}

pub fn decode_align(align) {
  case align {
    "start" -> theme.Start
    "end" -> theme.End
    "between" -> theme.SpaceBetween
    "around" -> theme.SpaceAround
    "evenly" -> theme.SpaceEvenly
    "stretch" -> theme.Stretch
    _ -> theme.Center
  }
}

pub fn decode_absolute(horizontal, vertical) {
  fn(absolute) {
    case absolute {
      "axis" -> theme.Axis(horizontal:, vertical:)
      "axisx" -> theme.AxisX(horizontal)
      "axisy" -> theme.AxisY(vertical)
      _ -> theme.AxisX(theme.Center)
    }
  }
}

/// flow_main|flow_items
/// flow=main|flow_items=items;flow_content=content
pub fn decode_flow(main, cross_items, cross_content) {
  fn(flow) {
    case flow {
      "flow" -> theme.Flow(main:, cross_items:, cross_content:)
      "flow_items" -> theme.FlowItems(main:, cross_items:)
      "flow_content" -> theme.FlowContent(main:, cross_content:)
      "cross_items" -> theme.CrossItems(main)
      "cross_content" -> theme.CrossContent(main)
      "main" -> theme.Main(main)
      _ -> theme.Main(theme.Center)
    }
  }
}

pub fn decode_layout(flow, absolute) {
  fn(layout) {
    case layout {
      "flow" -> theme.LayoutFlow(flow)
      "absolute" -> theme.LayoutAbsolute(absolute)
      _ -> theme.LayoutDefault
    }
  }
}

pub fn decode_size(value) {
  case value {
    "xxs" -> theme.SizeXxs
    "xs" -> theme.SizeXs
    "sm" -> theme.SizeSm
    "md" -> theme.SizeMd
    "lg" -> theme.SizeLg
    "xl" -> theme.SizeXl
    "2xl" -> theme.SizeXxl
    _ -> theme.SizeMd
  }
}

pub fn decode_elevation(size) {
  fn(value) {
    case value {
      "flat" -> theme.ElevationFlat
      "inner" -> theme.ElevationInner
      "high" -> theme.ElevationHigh(size)
      "low" -> theme.ElevationLow(size)
      _ -> theme.ElevationMedium(size)
    }
  }
}

pub fn decode_stacking(value) {
  case value {
    "tooltip" -> theme.StackTooltip
    "toast" -> theme.StackToast
    "modal" -> theme.StackModal
    "overlay" -> theme.StackOverlay
    "dropdown" -> theme.StackDropdown
    "sticky" -> theme.StackSticky
    "float" -> theme.StackFloat
    _ -> theme.StackBase
  }
}
