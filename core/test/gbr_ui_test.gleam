import gleeunit
import gleeunit/should

import gbr/ui/theme

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn theme_paint_test() {
  let t =
    theme.new()
    |> theme.with_variant(theme.VariantPrimary)
    |> theme.with_appearance(theme.AppearanceFilled)
    |> theme.with_state(theme.StateIdle)
    |> theme.with_base_to_tokens(fn() { ["base-class"] })
    |> theme.with_design_to_tokens(fn(v, a, s) {
      case v, a, s {
        theme.VariantPrimary, theme.AppearanceFilled, theme.StateIdle -> [
          "bg-primary-500", "text-white",
        ]
        _, _, _ -> ["bg-gray-500"]
      }
    })

  let tokens = theme.paint(t)

  tokens
  |> should.equal(["base-class", "bg-primary-500", "text-white"])
}

pub fn theme_fallback_test() {
  let t =
    theme.new()
    |> theme.with_variant(theme.VariantSecondary)
    |> theme.with_appearance(theme.AppearanceFilled)
    |> theme.with_state(theme.StateIdle)
    |> theme.with_design_to_tokens(fn(v, a, s) {
      case v, a, s {
        theme.VariantPrimary, theme.AppearanceFilled, theme.StateIdle -> [
          "bg-primary-500",
        ]
        _, _, _ -> ["bg-gray-500"]
      }
    })

  let tokens = theme.paint(t)

  tokens
  |> should.equal(["bg-gray-500"])
}
