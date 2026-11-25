//// Internal stack, size, layout, alignment, and a11y token helpers.

import gbr/ui/lustre
import gbr/ui/theme

pub fn stack_to_zindex_token(stacking: theme.UIStacking) -> lustre.UILustre {
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

pub fn size_text_to_class(size: theme.UISize) -> lustre.UILustre {
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

pub fn size_icon_height_class(size: theme.UISize) -> lustre.UILustre {
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

pub fn size_icon_width_class(size: theme.UISize) -> lustre.UILustre {
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

pub fn size_icon_max_height_class(size: theme.UISize) -> lustre.UILustre {
  case size {
    theme.SizeXxl -> "max-h-4"
    theme.SizeXl -> "max-h-3.5"
    theme.SizeLg -> "max-h-3"
    theme.SizeMd -> "max-h-2.5"
    theme.SizeSm -> "max-h-2"
    theme.SizeXs -> "max-h-1.5"
    theme.SizeXxs -> "max-h-1"
  }
  |> lustre.Class
}

pub fn size_icon_max_width_class(size: theme.UISize) -> lustre.UILustre {
  case size {
    theme.SizeXxl -> "max-w-4"
    theme.SizeXl -> "max-w-3.5"
    theme.SizeLg -> "max-w-3"
    theme.SizeMd -> "max-w-2.5"
    theme.SizeSm -> "max-w-2"
    theme.SizeXs -> "max-w-1.5"
    theme.SizeXxs -> "max-w-1"
  }
  |> lustre.Class
}

pub fn size_to_shadown_token(size: theme.UISize) -> lustre.UILustre {
  case size {
    theme.SizeXxl -> "shadow-2xl"
    theme.SizeXl -> "shadow-xl"
    theme.SizeLg -> "shadow-lg"
    theme.SizeMd -> "shadow-md"
    theme.SizeSm -> "shadow-sm"
    theme.SizeXs -> "shadow-xs"
    theme.SizeXxs -> "shadow-2xs"
  }
  |> lustre.Class
}

pub fn layout_to_tokens(layout: theme.UILayout) -> List(lustre.UILustre) {
  case layout {
    theme.LayoutFlow(flow) -> layout_flow_to_tokens(flow)
    theme.LayoutAbsolute(absolute) -> absolute_to_layout_token(absolute)
  }
}

pub fn layout_flow_to_tokens(layout: theme.UIFlow) -> List(lustre.UILustre) {
  case layout {
    theme.Main(justify:) -> [alignment_to_justify_token(justify)]
    theme.CrossItems(align:) -> [alignment_to_items_token(align)]
    theme.CrossContent(align:) -> [alignment_to_content_token(align)]
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

pub fn alignment_to_items_token(align: theme.UIAlignment) -> lustre.UILustre {
  case align {
    theme.Start -> "items-start"
    theme.End -> "items-end"
    theme.Center -> "items-center"
    theme.Stretch -> "items-stretch"
    theme.SpaceBetween | theme.SpaceAround | theme.SpaceEvenly ->
      "items-stretch"
  }
  |> lustre.Class
}

pub fn alignment_to_content_token(align: theme.UIAlignment) -> lustre.UILustre {
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

pub fn alignment_to_justify_token(align: theme.UIAlignment) -> lustre.UILustre {
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

pub fn absolute_to_layout_token(
  absolute: theme.UIAbsolute,
) -> List(lustre.UILustre) {
  case absolute {
    theme.AxisX(x) -> [horizontal_to_layout_token(x)]
    theme.AxisY(y) -> [vertical_to_layout_token(y)]
    theme.Axis(horizontal:, vertical:) -> [
      horizontal_to_layout_token(horizontal),
      vertical_to_layout_token(vertical),
    ]
  }
}

pub fn horizontal_to_layout_token(x: theme.UIAlignment) -> lustre.UILustre {
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

pub fn vertical_to_layout_token(y: theme.UIAlignment) -> lustre.UILustre {
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
