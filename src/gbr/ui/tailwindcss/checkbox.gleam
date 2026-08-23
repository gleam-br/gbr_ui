////
//// UI tailwindcss checkbox module
////

import lustre/attribute as a
import lustre/element as el
import lustre/element/html as h
import lustre/element/svg as s

import gbr/ui/tailwindcss/typo
import gbr/ui/theme.{type UIVariant}

pub fn primary(
  id: String,
  text: String,
  is_checked: Bool,
  attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  view(
    id,
    [
      typo.label(text, [a.for(id), a.class("ml-2 cursor-pointer")]),
    ],
    is_checked,
    variant: theme.VariantPrimary,
    attributes:,
  )
}

/// O Componente Público do Checkbox
pub fn view(
  id: String,
  label: List(el.Element(msg)),
  is_checked: Bool,
  variant variant: UIVariant,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  let appearance = case is_checked {
    True -> theme.AppearanceFilled
    False -> theme.AppearanceGhost
  }

  let box_classes =
    new_theme()
    |> theme.with_variant(variant:)
    |> theme.with_appearance(appearance:)
    |> theme.paint()
    |> a.classes()

  let svg_opacity = case is_checked {
    True -> a.class("opacity-100")
    False -> a.class("opacity-0")
  }

  h.div([a.class("flex cursor-pointer select-none items-center")], [
    h.div([a.class("relative"), ..attributes], [
      h.input([
        a.id(id),
        a.type_("checkbox"),
        a.class("sr-only"),
        a.checked(is_checked),
      ]),

      h.div([box_classes], [
        s.svg(
          [
            a.class("fill-current transition-opacity duration-200 ease-in-out"),
            svg_opacity,
            a.width(10),
            a.height(10),
            a.attribute("viewBox", "0 0 10 10"),
            a.attribute("xmlns", "http://www.w3.org/2000/svg"),
          ],
          [
            s.path([
              a.attribute(
                "d",
                "M3.33331 8.5C3.13331 8.5 2.95831 8.425 2.80831 8.275L0.283306 5.75C-0.0916941 5.375 -0.0916941 4.775 0.283306 4.4C0.658306 4.025 1.25831 4.025 1.63331 4.4L3.33331 6.1L8.33331 1.1C8.70831 0.725 9.30831 0.725 9.68331 1.1C10.0583 1.475 10.0583 2.075 9.68331 2.45L4.03331 8.1C3.88331 8.275 3.65831 8.5 3.33331 8.5Z",
              ),
            ]),
          ],
        ),
      ]),
    ]),
    ..label
  ])
}

// ==========================================
// ⚙️ O V8 PRIVADO DO QUADRADINHO
// ==========================================

fn new_theme() {
  theme.new()
  |> theme.with_base_to_tokens(base_classes)
  |> theme.with_design_to_tokens(cosmetics)
  |> theme.with_shape_to_tokens(shape_classes)
  |> theme.with_size_to_tokens(size_classes)
}

fn base_classes() {
  [
    #(
      "flex items-center justify-center border-[1.25px] border-border transition-all duration-200",
      True,
    ),
  ]
}

fn size_classes(_size) {
  [#("h-5 w-5", True)]
}

fn shape_classes(_shape) {
  [#("rounded", True)]
}

fn cosmetics(variant, appearance, _state) {
  case variant, appearance {
    // ☑️ MARCADO (AppearanceFilled)
    theme.VariantPrimary, theme.AppearanceFilled -> [
      #("border-brand-500 bg-brand-500 text-white", True),
    ]

    // O SVG herda o text-white
    theme.VariantError, theme.AppearanceFilled -> [
      #("border-red-500 bg-red-500 text-white", True),
    ]

    // 🔲 DESMARCADO (AppearanceGhost - Vazado)
    // Usamos Default para o caminho feliz sem erro
    theme.VariantDefault, theme.AppearanceGhost -> [
      #("border-stroke bg-transparent dark:border-strokedark", True),
    ]

    theme.VariantError, theme.AppearanceGhost -> [
      #("border-red-500 bg-transparent text-transparent", True),
    ]

    // Fallback
    _, _ -> [#("border-gray-300 bg-transparent", True)]
  }
}
