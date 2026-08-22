////
//// ✍🏻 UI tailwindcss typography module
////
//// Olá, aqui temos o componente visual para escrevermos textos na tela
//// do usuário. Imagine este módulo como se fosse uma máquina de escrever
//// com várias opções de fontes, tamanhos, etc.
////
//// Mas com um estilo de telas administrativas, de um sistema enterprise.
////
//// Temos **8100** tipografias

import gleam/list

import lustre/attribute as a
import lustre/element as el
import lustre/element/html as h

import gbr/ui/typo.{type UITypography as UITypo}

import gbr/ui/theme.{
  type UIAppearance, type UISize, type UIState, type UIVariant,
}

/// Header 1
///
pub fn h1(text: String, with attributes: List(a.Attribute(msg))) {
  view(
    typo.H1,
    text,
    state: theme.StateIdle,
    variant: theme.VariantDefault,
    appearance: theme.AppearanceFilled,
    attributes:,
  )
}

/// Header 2
///
pub fn h2(
  text: String,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  view(
    typo.H2,
    text,
    state: theme.StateIdle,
    variant: theme.VariantDefault,
    appearance: theme.AppearanceFilled,
    attributes:,
  )
}

/// Header 3
///
pub fn h3(
  text: String,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  view(
    typo.H3,
    text,
    state: theme.StateIdle,
    variant: theme.VariantDefault,
    appearance: theme.AppearanceFilled,
    attributes:,
  )
}

/// Header 4
///
pub fn h4(
  text: String,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  view(
    typo.H4,
    text,
    state: theme.StateIdle,
    variant: theme.VariantDefault,
    appearance: theme.AppearanceFilled,
    attributes:,
  )
}

/// Span
///
pub fn span(
  text: String,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  span_with_size(text, get_size_default(), attributes:)
}

pub fn span_with_variant(
  text: String,
  variant: UIVariant,
  attributes attributes: List(a.Attribute(msg)),
) {
  view(
    typo.Span(get_size_default()),
    text,
    variant:,
    attributes:,
    state: theme.StateIdle,
    appearance: theme.AppearanceDefault,
  )
}

pub fn span_with_size(
  text: String,
  size: UISize,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  view_default(typo.Span(size), text, attributes:)
}

/// Pre
///
pub fn pre(
  text: String,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  pre_with_size(text, get_size_default(), attributes:)
}

pub fn pre_with_size(
  text: String,
  size: UISize,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  view_default(typo.Pre(size), text, attributes:)
}

/// Paragraph
///
pub fn p(
  text: String,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  p_with_size(text, get_size_default(), attributes:)
}

pub fn p_with_size(
  text: String,
  size: UISize,
  attributes attributes: List(a.Attribute(msg)),
) {
  view_default(typo.Paragraph(size), text, attributes:)
}

pub fn p_ghost(text: String, attributes attributes: List(a.Attribute(msg))) {
  p_with_appearance(text, theme.AppearanceGhost, attributes)
}

pub fn p_with_variant(
  text: String,
  variant: UIVariant,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  view(
    typo.Paragraph(get_size_default()),
    text,
    variant:,
    attributes:,
    appearance: theme.AppearanceDefault,
    state: theme.StateIdle,
  )
}

pub fn p_with_appearance(
  text: String,
  appearance: UIAppearance,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  view(
    typo.Paragraph(get_size_default()),
    text,
    appearance:,
    attributes:,
    variant: theme.VariantDefault,
    state: theme.StateIdle,
  )
}

/// Label
///
pub fn label(
  text: String,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  label_with_size(text, get_size_default(), attributes:)
}

pub fn label_with_size(
  text: String,
  size: UISize,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  view(
    typo.Label(size),
    text,
    state: theme.StateIdle,
    variant: theme.VariantDefault,
    appearance: theme.AppearanceDefault,
    attributes:,
  )
}

/// View admin typo primary representa uma tipografia com estilos do tema
/// principal como padrão.
///
/// - typo: Tipo da tipografia.
/// - text: Texto a ser mostrado.
/// - with: Mais atributos para o texto.
pub fn view_default(
  typo: UITypo,
  text: String,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  view(
    typo,
    text,
    state: theme.StateIdle,
    variant: theme.VariantDefault,
    appearance: theme.AppearanceDefault,
    attributes: attributes,
  )
}

pub fn get_size_default() {
  theme.SizeSm
}

/// View UI typography element
///
/// - typo: Tipo que vamos escrever na tela.
/// - text: O conteúdo que será escrito na tela.
/// - state: O estado do elemento.
/// - variant: A variante de tema do elemento.
/// - appearance: A aparência de estilo do elemento.
/// - attributes: Mais atributos para o texto.
pub fn view(
  typo: UITypo,
  text: String,
  state state: UIState,
  variant variant: UIVariant,
  appearance appearance: UIAppearance,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  new_theme(typo)
  |> theme.with_design(variant:, appearance:, state:)
  |> typo.to_element(typo, _, with: attributes, inner: [h.text(text)])
}

/// Get size from typograph, if exists.
///
pub fn get_size(typo: UITypo) -> UISize {
  case typo {
    typo.H1 -> theme.SizeXxl
    typo.H2 -> theme.SizeXl
    typo.H3 -> theme.SizeLg
    typo.H4 -> theme.SizeMd
    typo.Pre(size)
    | typo.Label(size)
    | typo.Span(size)
    | typo.Paragraph(size) -> size
  }
}

// PRIVATE
//

fn new_theme(typo) {
  theme.new()
  |> theme.with_base_to_tokens(base_classes)
  |> theme.with_size_to_tokens(size_classes(_, is_header(typo)))
  |> theme.with_stacking_to_tokens(stack_classes)
  |> theme.with_elevation_to_tokens(elevation_classes)
  |> theme.with_design_to_tokens(cosmetic_classes)
}

fn base_classes() {
  [
    #("text-pretty md:text-balance text-ellipsis md:text-clip", True),
  ]
  |> theme.Classes
  |> theme.token_to_list
}

fn stack_classes(stacking) {
  let class = case stacking {
    theme.StackBase -> "z-1"
    theme.StackXxs -> "z-9"
    theme.StackXs -> "z-99"
    theme.StackSm -> "z-999"
    theme.StackLg -> "z-9999"
    theme.StackXl -> "z-99999"
    theme.StackXxl -> "z-999999"
    theme.StackAncestor(_) -> "z-inherit"
  }

  [#(class, True)]
  |> theme.Classes
  |> theme.token_to_list
}

fn elevation_classes(elevation) {
  let class = case elevation {
    theme.ElevationFlat -> "text-shadow-none"
    theme.ElevationInner -> "text-shadow-2xs"
    theme.ElevationLow -> "text-shadow-xs"
    theme.ElevationMedium -> "text-shadow-md"
    theme.ElevationHigh -> "text-shadow-lg"
    theme.ElevationAncestor(_) -> "text-shadow-inherit"
  }

  [#(class, True)]
  |> theme.Classes
  |> theme.token_to_list
}

fn is_header(typo) {
  case typo {
    typo.H1 | typo.H2 | typo.H3 | typo.H4 -> True
    _ -> False
  }
}

// A GEOMETRIA DO TEXTO (Tamanho, Peso e Altura da Linha)
fn size_classes(size, is_header) {
  case size {
    theme.SizeXxl -> [
      #("text-title-xl sm:text-title-2xl", is_header),
      #("text-3xl sm:text-4xl", !is_header),
    ]
    theme.SizeXl -> [
      #("text-title-lg sm:text-title-xl", is_header),
      #("text-2xl sm:text-3xl", !is_header),
    ]
    theme.SizeLg -> [
      #("text-title-md sm:text-title-lg", is_header),
      #("text-xl sm:text-2xl", !is_header),
    ]
    theme.SizeMd -> [
      #("text-title-sm sm:text-title-md", is_header),
      #("text-base", !is_header),
    ]
    theme.SizeSm -> [
      #("text-sm", True),
    ]
    theme.SizeXs -> [
      #("text-xs", True),
    ]
    _ -> []
  }
  |> theme.Classes
  |> theme.token_to_list
}

// A PINTURA DO TEXTO (Cor, Densidade e Estado)
fn cosmetic_classes(variant variant, appearance appearance, state state) {
  let variant = case variant {
    theme.VariantInfo | theme.VariantDefault -> [#("text-content", True)]
    theme.VariantPrimary -> [#("text-primary-900", True)]
    theme.VariantSecondary -> [
      #("text-secondary-800", True),
    ]
    theme.VariantTertiary -> [
      #("text-surface-muted", True),
    ]
    // Cores de Feedback
    theme.VariantSuccess -> [#("text-success-900", True)]
    theme.VariantWarning -> [#("text-warning-800", True)]
    theme.VariantError -> [#("text-danger-800", True)]

    theme.VariantAncestor(_) -> [#("text-inherit", True)]
  }

  let appearance = case appearance {
    theme.AppearanceDefault -> [#("font-normal", True)]
    theme.AppearanceSlit -> [#("font-normal text-ellipsis", True)]
    theme.AppearanceGhost -> [#("font-light opacity-65", True)]
    theme.AppearanceLight -> [#("font-light", True)]
    theme.AppearanceFlat -> [#("font-medium", True)]
    theme.AppearanceThin -> [#("font-thin", True)]
    theme.AppearanceFilled -> [#("font-semibold", True)]
    theme.AppearanceAncestor(_) -> []
  }

  let state = case state {
    theme.StateLoading | theme.StateDisabled -> [
      #("cursor-not-allowed opacity-70", True),
    ]
    // TODO: Pensar se no futuro a tipografia muda no hover (ex: links)
    theme.StateHover -> []
    theme.StateFocus -> []
    theme.StatePressed -> []
    theme.StateIdle | theme.StateAncestor(_) -> []
  }

  [variant, appearance, state]
  |> list.flatten()
  |> theme.Classes
  |> theme.token_to_list
}
