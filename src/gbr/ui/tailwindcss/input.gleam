////
//// 📥 UI tailwindcss input module
////
//// Olá, neste módulo podemos encontrar os inputs adminstrativos usados
//// para soluções enterprise.

import gleam/option.{type Option, None, Some}

import lustre/attribute as a
import lustre/element as el
import lustre/element/html as h

import gbr/ui/input
import gbr/ui/tailwindcss/engine
import gbr/ui/tailwindcss/typo

import gbr/ui/theme.{
  type UIAppearance, type UIShape, type UISize, type UIState, type UIVariant,
}

pub type UIInput =
  input.UIInput

pub const new = input.new

pub const with_label = input.with_label

pub const with_value = input.with_value

pub const with_placeholder = input.with_placeholder

pub const with_note = input.with_note

pub const is_valid = input.is_valid

pub const without_note = input.without_note

pub const note = input.note

pub const note_success = input.note_success

pub const note_warn = input.note_warn

pub const note_error = input.note_error

/// Converte a representação de um input de texto administrativo em um elemento lustre.
///
/// - input: O tipo de input administrativo.
/// - attributes: Mais atributos para este input.
pub fn text(
  input: input.UIInput,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  let input.UIInput(id:, value:, label:, note:, placeholder:, ..) = input
  let placeholder = placeholder_to_attribute(placeholder)

  view_default(
    id,
    input.InputText,
    icon: None,
    label:,
    value:,
    note:,
    attributes: [placeholder, ..attributes],
  )
}

/// Converte os dados passados em um elemento lustre de input seguindo os padrões
/// do tema administrativo:
///
/// - size: theme.SizeSm
/// - state: theme.StateIdle
/// - variant: theme.VariantDefault
/// - appearance: theme.AppearanceGhost
/// - shape: theme.ShapeRounded(theme.SizeMd, theme.DirectionCentral)
pub fn view_default(
  id,
  type_,
  label label,
  value value,
  note note,
  icon icon,
  attributes attributes,
) -> el.Element(msg) {
  view(
    id,
    type_,
    value:,
    label:,
    icon:,
    note:,
    attributes:,
    variant: theme.VariantDefault,
    size: theme.SizeSm,
    shape: theme.ShapeRounded(
      size: theme.SizeMd,
      direction: theme.DirectionCentral,
    ),
    state: theme.StateIdle,
    appearance: theme.AppearanceGhost,
  )
}

/// Visualizar uma representação de um input como elemento lustre.
///
/// - id: Identificador html.
/// - type_: `UIInputType`, o tipo do input representado.
/// - value: O valor opicional do input, quando `None` o input está intocado.
/// - label: O label opicional do input.
/// - note: A nota de rodapé opicional,
/// - icon: O ícone opicional.
/// - size: O tamanho do input.
/// - shape: O formato do input.
/// - state: O estado do input.
/// - variant: A variante do tema do input.
/// - appearance: A aparência do tema do input.
/// - attributes: Mais atributes lustre deste input.
pub fn view(
  id: String,
  type_: input.UIInputType,
  value value: Option(String),
  label label: Option(String),
  note note: Option(input.UIInputNote),
  icon icon: Option(el.Element(msg)),
  size size: UISize,
  shape shape: UIShape,
  state state: UIState,
  variant variant: UIVariant,
  appearance appearance: UIAppearance,
  attributes attributes: List(a.Attribute(msg)),
) {
  let classes = paint_theme(size:, shape:, state:, variant:, appearance:)
  let label = view_label(id, label)
  let note = view_note(note)
  let icon = option.unwrap(icon, el.none())

  h.div([a.class("flex flex-col w-full relative")], [
    label,
    h.div([a.class("relative w-full")], [
      input.to_element(id, type_, value:, attributes: [classes, ..attributes]),
      icon,
    ]),

    note,
  ])
}

// PRIVATE
//

fn view_label(id, label) {
  case label {
    Some(label) -> {
      typo.label(label, attributes: [a.for(id), a.class("mb-1 block")])
    }
    None -> el.none()
  }
}

fn view_note(note) {
  note
  |> option.map(fn(note) {
    let variant = input.note_to_variant(note)
    typo.span_with_variant(note.text, variant, attributes: [])
  })
  // |> option.unwrap(el.none())
  |> option.unwrap(
    h.div([a.class("h-5")], []),
    // typo.span_with_variant("", theme.VariantDefault, attributes: []),
  )
}

// ==========================================
// ⚙️ ENGINE UX V8 Inputs
// ==========================================

fn paint_theme(
  size size: UISize,
  shape shape: UIShape,
  state state: UIState,
  variant variant: UIVariant,
  appearance appearance: UIAppearance,
) -> a.Attribute(msg) {
  // 1. BASE (A base transparente e responsiva do Tailadmin)
  let base = base_classes()

  // 2. GEOMETRIA (Tamanho)
  // Nota: Inputs de texto usam Md. Checkboxes usarão tamanhos fixos menores.
  let size = size_classes(size)

  // 3. FORMA (Bordas)
  let shape = shape_classes(shape)

  // 4. A PINTURA DO INPUT (A Mágica do Focus e Validação)
  let cosmetics = cosmetics_classes(variant:, state:, appearance:)

  engine.new(base)
  |> engine.with_size(size)
  |> engine.with_shape(shape)
  |> engine.with_cosmetics(cosmetics)
  |> engine.resolve()
}

fn base_classes() {
  [#("w-full h-10 bg-transparent outline-none ", True)]
}

fn size_classes(size) {
  case size {
    theme.SizeLg -> [#("py-3 pl-4 pr-12 text-lg", True)]
    // O Input Padrão
    theme.SizeMd -> [#("py-2.5 pl-3 pr-10 text-base", True)]
    theme.SizeSm -> [#("py-2 pl-2 pr-8 text-sm", True)]
    // Tamanho fixo perfeito para o Checkbox!
    theme.SizeXs -> [#("w-5 h-5", True)]
    _ -> []
  }
}

fn shape_classes(shape) {
  case shape {
    theme.ShapeRounded(size, _) -> [
      #("rounded-lg", size == theme.SizeLg),
      #("rounded-md", size == theme.SizeMd),
      #("rounded-sm", size == theme.SizeSm),
    ]
    theme.ShapeSharp -> [#("rounded-xs", True)]
    theme.ShapePill -> [#("rounded-xl", True)]
    theme.ShapeCircle -> [#("rounded-full", True)]
    theme.ShapeAncestor -> [#("rounded-[inherit]", True)]
  }
}

fn cosmetics_classes(variant variant, state state, appearance appearance) {
  case variant, appearance, state {
    // --- ESTADO GLOBAL DESATIVADO ---
    // Removemos os grays e centralizamos a opacidade
    _, _, theme.StateDisabled -> [
      #(
        "bg-surface-muted border-border-muted "
          <> "text-content-muted cursor-not-allowed opacity-70",
        True,
      ),
    ]

    // ==========================================
    // ⚪ INPUTS NEUTROS (O caminho feliz do Tailadmin)
    // ==========================================
    theme.VariantDefault, theme.AppearanceGhost, theme.StateIdle -> [
      #(
        "bg-transparent  "
          <> "text-content placeholder:text-content-muted "
          <> "border border-border focus:border-primary-400 h-10 "
          <> "focus:ring-3 focus:outline-hidden shadow-theme-xs focus:ring-primary-500/10",
        True,
      ),
    ]

    // ==========================================
    // 🔴 INPUTS COM ERRO (Validação de Formulário)
    // ==========================================
    theme.VariantError, theme.AppearanceGhost, theme.StateIdle -> [
      #(
        "border border-danger-500 text-danger-500 focus:border-danger-500 focus:ring-danger-500/10",
        True,
      ),
    ]

    // ==========================================
    // 🟢 INPUTS COM SUCESSO
    // ==========================================
    theme.VariantSuccess, theme.AppearanceGhost, theme.StateIdle -> [
      #(
        "border border-success-500 text-success-500 focus:border-success-500 focus:ring-success-500/10",
        True,
      ),
    ]

    // ==========================================
    // ☑️ O CHECKBOX (Filled - Marcado)
    // ==========================================
    theme.VariantPrimary, theme.AppearanceFilled, theme.StateIdle -> [
      #("bg-primary-500 border-primary-500 text-primary-content", True),
    ]

    // Fallback
    _, _, _ -> [#("border border-transparent bg-transparent", True)]
  }
}

fn placeholder_to_attribute(placeholder) {
  case placeholder {
    Some(placeholder) -> a.placeholder(placeholder)
    None -> a.none()
  }
}
