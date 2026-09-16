////
//// GBR: UI Theme Token Css Module
////

import gbr/ui/theme

pub fn layout_flex_inline() {
  theme.Style("display", "inline-flex")
}

pub fn layout_to_token_value(layout: theme.UIFlow) {
  case layout {
    theme.Main(justify:) ->
      alignment_to_css_value(justify)
      |> theme.Style("justify-content", _)
    theme.CrossItems(align:) ->
      alignment_to_css_value(align)
      |> theme.Style("align-self", _)
    theme.CrossContent(align:) ->
      alignment_to_css_value(align)
      |> theme.Style("align-content", _)
    theme.Flow(main:, cross_content:, cross_items:) ->
      theme.Styles([
        #("justify-content", alignment_to_css_value(main)),
        #("align-content", alignment_to_css_value(cross_content)),
        #("align-self", alignment_to_css_value(cross_items)),
      ])
    theme.FlowItems(main:, cross_items:) ->
      theme.Styles([
        #("justify-content", alignment_to_css_value(main)),
        #("align-self", alignment_to_css_value(cross_items)),
      ])
    theme.FlowContent(main:, cross_content:) ->
      theme.Styles([
        #("justify-content", alignment_to_css_value(main)),
        #("align-content", alignment_to_css_value(cross_content)),
      ])
  }
}

pub fn alignment_to_css_value(align: theme.UIAlignment) -> String {
  case align {
    theme.Start -> "flex-start"
    theme.End -> "flex-end"
    theme.Center -> "center"
    theme.SpaceBetween -> "space-between"
    theme.SpaceAround -> "space-around"
    theme.SpaceEvenly -> "space-evenly"
    theme.Stretch -> "stretch"
  }
}
