////
//// UI tailwindcss checkbox module
////

import lustre/attribute as a
import lustre/element as el
import lustre/element/html as h
import lustre/element/svg as s

import gbr/ui/tailwindcss/engine
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
  // 1. A PONTE LÓGICA -> VISUAL
  // Se está marcado, pintamos o fundo (Filled). Se não, fica vazado (Ghost).
  let appearance = case is_checked {
    True -> theme.AppearanceFilled
    False -> theme.AppearanceGhost
  }

  // 2. O MOTOR V8 DO QUADRADINHO
  let box_classes = paint_box(variant, appearance)

  // 3. O TRUQUE DO SVG (Animação suave)
  // Ao invés de remover o SVG do DOM quando for False, nós apenas
  // zeramos a opacidade. Isso permite que o Tailwind faça um fade-in lindo!
  let svg_opacity = case is_checked {
    True -> a.class("opacity-100")
    False -> a.class("opacity-0")
  }

  // 4. A ESTRUTURA DO DOM (Acessibilidade + Design)
  h.div([a.class("flex cursor-pointer select-none items-center")], [
    h.div([a.class("relative"), ..attributes], [
      // O INPUT REAL (Invisível, mas controlável pelo teclado e formulários)
      h.input([
        a.id(id),
        a.type_("checkbox"),
        // Esconde da tela, mas mantém acessível!
        a.class("sr-only"),
        a.checked(is_checked),
      ]),

      // O QUADRADO FALSO (Pintado pelo nosso Motor)
      h.div([box_classes], [
        // O ÍCONE SVG DE CHECKMARK (Herdando a cor do texto com `currentColor`)
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

fn paint_box(
  variant: UIVariant,
  appearance: theme.UIAppearance,
) -> a.Attribute(msg) {
  // Base: Flexbox para centralizar o SVG, borda e transição
  let base = [
    #(
      "flex items-center justify-center border-[1.25px] border-border transition-all duration-200",
      True,
    ),
  ]

  // Geometria: Tamanho exato do Checkbox do Tailadmin
  let size = [#("h-5 w-5", True)]

  // Forma: Levemente arredondado
  let shape = [#("rounded", True)]

  // A Pintura:
  let cosmetics = case variant, appearance {
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

  engine.new(base)
  |> engine.with_size(size)
  |> engine.with_shape(shape)
  |> engine.with_cosmetics(cosmetics)
  |> engine.resolve()
}
