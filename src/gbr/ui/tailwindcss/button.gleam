////
//// 🎛️ UI tailwindcss button module
////
//// Olá, aqui temos o módulo que permite mostrarmos botões na tela utilizando
//// `lustre/element/html.button`.

import gleam/option.{Some}

import lustre/attribute as a
import lustre/element as el
import lustre/element/html as h

import gbr/ui/button
import gbr/ui/theme.{type UIAppearance, type UIShape}

/// O tipo que representa um botão com ícone administrativo, podemos ter:
///
/// - text: Texto interno do botão
/// - icon: O elemento lustre, que deve representar o ícone interno.
/// - direction: O `theme.UIDirection`, onde o ícone deve ser desenhado.
pub opaque type UIButtonWithIcon(msg) {
  UIButtonIcon(
    text: String,
    icon: el.Element(msg),
    direction: theme.UIDirection,
  )
}

/// Inserir um elemento lustre representando um ícone.
///
/// - text: Texto do botão.
/// - ícone: Ícone do botão.
pub fn with_icon(text: String, icon: el.Element(msg)) {
  UIButtonIcon(text:, icon:, direction: theme.DirectionX(theme.Left))
}

/// Visualizar um botão de submit de texto utilizando o tema primário.
///
/// - text: Texto do botão.
/// - attributes: Mais atributos deste botão.
pub fn text_submit(
  text: String,
  attributes attributes: List(a.Attribute(msg)),
) {
  primary(button.ButtonSubmit, attributes, inner: [h.text(text)])
}

/// Visualizar um botão de texto utilizando o tema primário.
///
/// - text: Texto do botão.
/// - attributes: Mais atributos deste botão.
pub fn text(text: String, attributes attributes: List(a.Attribute(msg))) {
  primary(button.ButtonNormal, attributes, inner: [h.text(text)])
}

/// Visualizar um botão de texto utilizando o tema ghost (outlined).
///
/// - text: Texto do botão.
/// - attributes: Mais atributos deste botão.
pub fn text_ghost(text: String, attributes attributes: List(a.Attribute(msg))) {
  text_with_appearance(text, appearance: theme.AppearanceGhost, attributes:)
}

/// Visualizar um botão de texto utilizando o tema light (brilhante).
///
/// - text: Texto do botão.
/// - attributes: Mais atributos deste botão.
pub fn text_light(text: String, attributes attributes: List(a.Attribute(msg))) {
  text_with_appearance(text, appearance: theme.AppearanceLight, attributes:)
}

/// Visualizar um botão de texto utilizando o tema light (brilhante).
///
/// - text: Texto do botão.
/// - appearance: A aparência do tema para o botão de texto.
/// - attributes: Mais atributos deste botão.
pub fn text_with_appearance(
  text: String,
  appearance appearance: UIAppearance,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  primary_with_appearance(button.ButtonNormal, appearance, attributes:, inner: [
    h.text(text),
  ])
}

/// Visualizar um botão somente c/ ícone utilizando o tema primário.
///
/// - icon: Elemento lustre que representa o ícone.
/// - attributes: Mais atributes lustre p/ o botão.
pub fn icon(
  icon: el.Element(msg),
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  primary(button.ButtonNormal, attributes, inner: [icon])
}

/// Visualizar um botão de texto c/ ícone utilizando o tema primário.
///
/// - button: O tipo de botão c/ texto e ícone.
/// - attributes: Mais atributes lustre p/ o botão.
pub fn text_icon(
  button button: UIButtonWithIcon(msg),
  attributes attributes: List(a.Attribute(msg)),
) {
  let inner = case button.direction {
    theme.DirectionX(theme.Right) -> [
      h.text(button.text),
      button.icon,
    ]
    _ -> [
      button.icon,
      h.text(button.text),
    ]
  }

  primary(button.ButtonNormal, attributes, inner:)
}

pub fn text_with_shape(
  text: String,
  shape shape: UIShape,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  primary_with_shape(button.ButtonNormal, shape, attributes:, inner: [
    h.text(text),
  ])
}

pub fn text_ghost_with_shape(
  text: String,
  shape shape: UIShape,
  attributes attributes: List(a.Attribute(msg)),
) {
  primary_with_appearance_and_shape(
    button.ButtonNormal,
    appearance: theme.AppearanceGhost,
    shape:,
    attributes:,
    elements: [h.text(text)],
  )
}

/// Visualizar um botão utilizando o tema primário e passando atributos e os
/// elementos lustre internos do botão.
///
/// - with: Atributos lustre do botão.
/// - inner: Elementos lustre internos do botão.
///
/// **OBSERVAÇÃO**: O tema (engine v8) do botão já insere classes de formatação
/// e estilo dos textos que forem inseridos internamente ao botão.
/// Portanto, caso seus atributos passados aqui **não surtirem efeito**, considere
/// ser o padrão de estilo visual já imposto pelo tema administrativo aos textos
/// internos do botão.
pub fn primary(
  button: button.UIButton,
  with attributes: List(a.Attribute(msg)),
  inner inner: List(el.Element(msg)),
) {
  primary_with_appearance(button, theme.AppearanceFilled, attributes:, inner:)
}

/// Visualizar um botão utilizando o tema ghost (outlined) e passando atributos e os
/// elementos lustre internos do botão.
///
/// - with: Atributos lustre do botão.
/// - inner: Elementos lustre internos do botão.
///
/// **OBSERVAÇÃO**: O tema (engine v8) do botão já insere classes de formatação
/// e estilo dos textos que forem inseridos internamente ao botão.
/// Portanto, caso seus atributos passados aqui **não surtirem efeito**, considere
/// ser o padrão de estilo visual já imposto pelo tema administrativo aos textos
/// internos do botão.
pub fn ghost(
  with attributes: List(a.Attribute(msg)),
  inner inner: List(el.Element(msg)),
) {
  primary_with_appearance(
    button.ButtonNormal,
    theme.AppearanceGhost,
    attributes:,
    inner:,
  )
}

/// Visualizar um botão utilizando o tema light (brilhante) e passando atributos e os
/// elementos lustre internos do botão.
///
/// - with: Atributos lustre do botão.
/// - inner: Elementos lustre internos do botão.
///
/// **OBSERVAÇÃO**: O tema (engine v8) do botão já insere classes de formatação
/// e estilo dos textos que forem inseridos internamente ao botão.
/// Portanto, caso seus atributos passados aqui **não surtirem efeito**, considere
/// ser o padrão de estilo visual já imposto pelo tema administrativo aos textos
/// internos do botão.
pub fn light(
  with attributes: List(a.Attribute(msg)),
  inner inner: List(el.Element(msg)),
) {
  primary_with_appearance(
    button.ButtonNormal,
    theme.AppearanceLight,
    attributes:,
    inner:,
  )
}

/// Visualizar um botão utilizando o tema de aparência de estilo passado como argumento,
/// além de passar os atributos e os elementos lustre internos do botão.
///
/// - appearance: A aparência do tema escolhido, e.g. AppearanceFilled, AppearanceGhost.
/// - attributes: Atributos lustre do botão.
/// - elements: Elementos lustre internos do botão.
///
/// **OBSERVAÇÃO**: O tema (engine v8) do botão já insere classes de formatação
/// e estilo dos textos que forem inseridos internamente ao botão.
/// Portanto, caso seus atributos passados aqui **não surtirem efeito**, considere
/// ser o padrão de estilo visual já imposto pelo tema administrativo aos textos
/// internos do botão.
pub fn primary_with_appearance(
  button: button.UIButton,
  appearance: UIAppearance,
  attributes attributes: List(a.Attribute(msg)),
  inner elements: List(el.Element(msg)),
) {
  primary_with_appearance_and_shape(
    button,
    attributes:,
    elements:,
    appearance:,
    shape: theme.ShapeRounded(
      size: theme.SizeLg,
      direction: theme.DirectionDefault,
    ),
  )
}

/// Visualizar um botão utilizando o tema do formato (shape) passado como argumento,
/// além de passar os atributos e os elementos lustre internos do botão.
///
/// - shape: O formato do tema escolhido, e.g. ShapeRounded(size:,direction:), ShapePill.
/// - attributes: Atributos lustre do botão.
/// - elements: Elementos lustre internos do botão.
///
/// **OBSERVAÇÃO**: O tema (engine v8) do botão já insere classes de formatação
/// e estilo dos textos que forem inseridos internamente ao botão.
/// Portanto, caso seus atributos passados aqui **não surtirem efeito**, considere
/// ser o padrão de estilo visual já imposto pelo tema administrativo aos textos
/// internos do botão.
pub fn primary_with_shape(
  button: button.UIButton,
  shape: UIShape,
  attributes attributes: List(a.Attribute(msg)),
  inner elements: List(el.Element(msg)),
) -> el.Element(msg) {
  primary_with_appearance_and_shape(
    button,
    shape:,
    attributes:,
    elements:,
    appearance: theme.AppearanceFilled,
  )
}

/// Visualizar um botão utilizando o tema do formato (shape) e aparência do estilo
/// passado como argumento, além de passar os atributos e os elementos lustre
/// internos do botão.
///
/// - shape: O formato do tema escolhido, e.g. ShapeRounded(size:,direction:), ShapePill.
/// - appearance: A aparência do estilo do tema, e.g. AppearanceFilled, AppearanceGhost.
/// - attributes: Atributos lustre do botão.
/// - elements: Elementos lustre internos do botão.
///
/// **OBSERVAÇÃO**: O tema (engine v8) do botão já insere classes de formatação
/// e estilo dos textos que forem inseridos internamente ao botão.
/// Portanto, caso seus atributos passados aqui **não surtirem efeito**, considere
/// ser o padrão de estilo visual já imposto pelo tema administrativo aos textos
/// internos do botão.
pub fn primary_with_appearance_and_shape(
  button: button.UIButton,
  appearance appearance: UIAppearance,
  shape shape: UIShape,
  attributes attributes: List(a.Attribute(msg)),
  elements elements: List(el.Element(msg)),
) {
  view(
    button,
    shape:,
    appearance:,
    attributes:,
    elements:,
    variant: theme.VariantPrimary,
    size: theme.SizeMd,
    state: theme.StateIdle,
  )
}

/// Visualizar um botão utilizando a matriz inteira p/ a escolha do tema
/// de estilo passados como argumentos, além de passar os atributos e os elementos
/// lustre internos do botão.
///
/// - size: O tamanho do tema, e.g. SizeMd, SizeLg.
/// - shape: O formato do tema, e.g. ShapePill, ShapeSharp.
/// - state: O estado do tema, e.g. StateLoading, StateIdle.
/// - variant: A variante do tema, e.g. VariantDefault, VariantPrimary.
/// - appearance: A aparência do tema, e.g. AppearanceFilled, AppearanceGhost.
/// - attributes: Atributos lustre do botão.
/// - elements: Elementos lustre internos do botão.
///
/// **OBSERVAÇÃO**: O tema (engine v8) do botão já insere classes de formatação
/// e estilo dos textos que forem inseridos internamente ao botão.
/// Portanto, caso seus atributos passados aqui **não surtirem efeito**, considere
/// ser o padrão de estilo visual já imposto pelo tema administrativo aos textos
/// internos do botão.
pub fn view(
  button: button.UIButton,
  size size: theme.UISize,
  shape shape: theme.UIShape,
  state state: theme.UIState,
  variant variant: theme.UIVariant,
  appearance appearance: theme.UIAppearance,
  attributes attributes: List(a.Attribute(msg)),
  elements elements: List(el.Element(msg)),
) -> el.Element(msg) {
  new_theme()
  |> theme.with_design(variant:, appearance:, state:)
  |> theme.with_size(Some(size))
  |> theme.with_shape(Some(shape))
  |> button.to_element(button, _, attributes, elements)
}

// PRIVATE
//

fn new_theme() {
  theme.new()
  // 1. BASE (Transições suaves que o Tailadmin usa em todos os botões)
  |> theme.with_base_to_tokens(base_classes)
  // 2. GEOMETRIA (Tamanho - paddings do Tailadmin)
  |> theme.with_size_to_tokens(size_classes)
  // 3. FORMA (Bordas)
  |> theme.with_shape_to_tokens(shape_classes)
  // 4. A FUSÃO (Cor x Preenchimento x Estado)
  |> theme.with_design_to_tokens(cosmetics_classes)
}

fn base_classes() {
  [
    #(
      "inline-flex items-center justify-center transition-all duration-200 gap-2 "
        <> "disabled:cursor-not-allowed shadow-theme-xs",
      True,
    ),
  ]
  |> theme.Classes
  |> theme.token_to_list
}

fn size_classes(size) {
  case size {
    theme.SizeLg -> [#("py-3 px-5", True)]
    theme.SizeMd -> [#("py-2.5 px-4", True)]
    theme.SizeSm -> [#("py-2 px-3", True)]
    _ -> []
  }
  |> theme.Classes
  |> theme.token_to_list
}

// 3. FORMA (Bordas)
fn shape_classes(shape) {
  case shape {
    theme.ShapeCircle | theme.ShapePill -> [#("rounded-full", True)]
    theme.ShapeSharp -> [#("rounded-none", True)]
    theme.ShapeRounded(size:, direction:) -> [
      #(
        "rounded-lg",
        size == theme.SizeLg && direction == theme.DirectionDefault,
      ),
      #(
        "rounded-r-lg",
        size == theme.SizeLg && direction == theme.DirectionX(theme.Right),
      ),
      #(
        "rounded-l-lg",
        size == theme.SizeLg && direction == theme.DirectionX(theme.Left),
      ),
      #(
        "rounded-md",
        size == theme.SizeMd && direction == theme.DirectionDefault,
      ),
      #(
        "rounded-r-md",
        size == theme.SizeMd && direction == theme.DirectionX(theme.Right),
      ),
      #(
        "rounded-l-md",
        size == theme.SizeMd && direction == theme.DirectionX(theme.Left),
      ),
      #(
        "rounded-sm",
        size == theme.SizeSm && direction == theme.DirectionDefault,
      ),
      #(
        "rounded-r-sm",
        size == theme.SizeSm && direction == theme.DirectionX(theme.Right),
      ),
      #(
        "rounded-l-sm",
        size == theme.SizeSm && direction == theme.DirectionX(theme.Left),
      ),
    ]
    theme.ShapeAncestor(_) -> [#("rounded-[inherit]", True)]
  }
  |> theme.Classes
  |> theme.token_to_list
}

// Substituímos os "white" e "gray" pelos tokens de conteúdo
const const_class_button_text_primary = "text-pretty md:text-balance text-ellipsis md:text-clip text-theme-sm font-medium text-primary-content"

const const_class_button_text_ghost = "text-pretty md:text-balance text-ellipsis md:text-clip text-theme-sm font-medium text-content"

// 4. A FUSÃO NUCLEAR SEMÂNTICA (Cor x Material x Tempo)
fn cosmetics_classes(variant variant, appearance appearance, state state) {
  case variant, appearance, state {
    // --- ESTADO GLOBAL DESATIVADO ---
    _, _, theme.StateDisabled -> [
      #(const_class_button_text_ghost, True),
      #(
        "bg-surface-muted border-border cursor-not-allowed text-content-muted opacity-60",
        True,
      ),
    ]

    // ==========================================
    // 🔵 FAMÍLIA PRIMARY (O "Primary" do Tailadmin)
    // ==========================================
    // 1. FILLED (Fundo Sólido)
    theme.VariantPrimary, theme.AppearanceFilled, theme.StateIdle -> [
      #(const_class_button_text_primary, True),
      #("bg-primary-500 hover:bg-primary-600 border border-transparent", True),
    ]
    theme.VariantPrimary, theme.AppearanceFilled, theme.StateHover -> [
      #(const_class_button_text_primary, True),
      #("bg-primary-600 border border-transparent", True),
    ]

    // 2. LIGHT (Fundo Suave/Soft do Tailadmin)
    theme.VariantPrimary, theme.AppearanceLight, theme.StateIdle -> [
      #(const_class_button_text_ghost, True),
      #(
        "bg-primary-500/10 text-primary-600 hover:bg-primary-500/20 border border-transparent",
        True,
      ),
    ]

    // 3. GHOST (Outline do Tailadmin - Os botões de OAuth!)
    theme.VariantPrimary, theme.AppearanceGhost, theme.StateIdle -> [
      #(const_class_button_text_ghost, True),
      #(
        "bg-surface hover:bg-surface-muted border border-border shadow-theme-xs",
        True,
      ),
    ]

    // ==========================================
    // 🔴 FAMÍLIA ERROR (O "Danger" do Tailadmin)
    // ==========================================
    // 1. FILLED
    theme.VariantError, theme.AppearanceFilled, theme.StateIdle -> [
      #(const_class_button_text_primary, True),
      #("bg-danger-500 hover:bg-danger-600 border border-transparent", True),
    ]
    // 2. GHOST
    theme.VariantError, theme.AppearanceGhost, _ -> [
      #(const_class_button_text_ghost, True),
      #("bg-transparent border border-danger-500 text-danger-500", True),
    ]

    // ==========================================
    // ⚪ FAMÍLIA DEFAULT / NEUTRA (Botão Secundário)
    // ==========================================
    theme.VariantDefault, theme.AppearanceFilled, _ -> [
      #(const_class_button_text_ghost, True),
      #("bg-surface-muted hover:bg-surface-muted/80 border border-border", True),
    ]
    theme.VariantDefault, theme.AppearanceGhost, _ -> [
      #(const_class_button_text_ghost, True),
      #("bg-transparent hover:bg-surface-muted border border-border", True),
    ]

    // Fallback Curinga
    _, _, _ -> [#("bg-transparent text-content", True)]
  }
  |> theme.Classes
  |> theme.token_to_list
}
