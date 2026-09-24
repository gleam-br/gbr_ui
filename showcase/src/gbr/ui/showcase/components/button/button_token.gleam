////
////
////

import gbr/ui/theme
import gbr/ui/theme/lustre
import gbr/ui/theme/lustre/tailwind/token

pub fn button_design_tokens(v, a, s) {
  [
    case v, a, s {
      theme.VariantPrimary, _, _ ->
        lustre.Class("bg-green-500 dark:bg-green-800")
      theme.VariantSecondary, _, _ ->
        lustre.Class("bg-amber-200 dark:bg-amber-300")
      theme.VariantTertiary, _, _ ->
        lustre.Class("bg-gray-900 dark:bg-black-300 text-white")
      _, _, _ -> lustre.Class("bg-gray-600 border-gray-900")
    },
  ]
}

pub fn button_size_tokens(s) {
  let size_to_height = case s {
    theme.SizeXxl -> lustre.Class("h-24 p-6")
    theme.SizeXl -> lustre.Class("h-20 p-5")
    theme.SizeLg -> lustre.Class("h-18 p-4")
    theme.SizeMd -> lustre.Class("h-16 p-3")
    theme.SizeSm -> lustre.Class("h-14 p-2")
    theme.SizeXs -> lustre.Class("h-12 p-1")
    theme.SizeXxs -> lustre.Class("h-10 p-1")
  }
  let size_to_text = token.size_text_to_classes(token.TextBase)

  [
    size_to_text(s),
    size_to_height,
  ]
}
