////
//// ⌨ UI admin typography module
////
//// Olá, aqui temos o componente visual para escrevermos textos na tela
//// do usuário. Imagine este módulo como se fosse uma máquina de escrever
//// com várias opções de fontes, tamanhos, etc.
////
//// Mas com um estilo de telas administrativas, de um sistema enterprise.

import gleam/list
import gleam/string

import lustre/attribute as a
import lustre/element as el

import gbr/ui/core/typo.{type UITypography as UITypo}

import gbr/ui/core/theme.{
  type UIAppearance, type UIDirection, type UISize, type UIState, type UIVariant,
}

/// Header 1
///
pub fn h1(text: String, with attributes: List(a.Attribute(msg))) {
  view_primary(typo.H1, text, attributes:)
}

/// Header 2
///
pub fn h2(
  text: String,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  view_primary(typo.H2, text, attributes:)
}

/// Header 3
///
pub fn h3(
  text: String,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  view_primary(typo.H3, text, attributes:)
}

/// Header 4
///
pub fn h4(
  text: String,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  view_primary(typo.H4, text, attributes:)
}

pub fn span_with_size(
  text: String,
  size: UISize,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  view_primary(typo.Span(size), text, attributes:)
}

/// Span
///
pub fn span(
  text: String,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  span_with_size(text, theme.SizeAncestor, attributes:)
}

pub fn pre_with_size(
  text: String,
  size: UISize,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  view_primary(typo.Pre(size), text, attributes:)
}

/// Pre
///
pub fn pre(
  text: String,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  pre_with_size(text, theme.SizeAncestor, attributes:)
}

pub fn p_with_size(
  text: String,
  size: UISize,
  attributes attributes: List(a.Attribute(msg)),
) {
  view_primary(typo.Paragraph(size), text, attributes:)
}

/// Paragraph
///
pub fn p(
  text: String,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  p_with_size(text, theme.SizeAncestor, attributes:)
}

pub fn label_with_size(
  text: String,
  size: UISize,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  view_primary(typo.Label(size), text, attributes:)
}

/// Label
///
pub fn label(
  text: String,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  label_with_size(text, theme.SizeAncestor, attributes:)
}

/// View admin typo primary representa uma tipografia com estilos do tema
/// principal como padrão.
///
/// - typo: Tipo da tipografia.
/// - text: Texto a ser mostrado.
/// - with: Mais atributos para o texto.
pub fn view_primary(
  typo: UITypo,
  text: String,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  view(
    typo,
    text,
    theme.StateAncestor,
    theme.VariantPrimary,
    theme.DirectionAncestor,
    theme.AppearanceFilled,
    attributes,
  )
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
  direction direction: UIDirection,
  appearance appearance: UIAppearance,
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  let with =
    paint_theme(
      variant:,
      appearance:,
      state:,
      size: get_size(typo),
      direction:,
      attributes: [
        a.class("antialiased"),
        a.classes(header_classes(typo)),
        ..attributes
      ],
    )

  typo.to_element(typo, text, with:)
}

/// Recupera a lista de tipografias disponíveis.
///
pub fn get_typos() {
  let spans =
    theme.get_sizes()
    |> list.map(typo.Span)
  let pres =
    theme.get_sizes()
    |> list.map(typo.Pre)
  let paragraphs =
    theme.get_sizes()
    |> list.map(typo.Paragraph)
  let headers = [typo.H1, typo.H2, typo.H3, typo.H4]

  list.append(headers, spans)
  |> list.append(paragraphs)
  |> list.append(pres)
}

/// Get size from typograph, if exists.
///
pub fn get_size(typo: UITypo) -> UISize {
  case typo {
    typo.H1 | typo.H2 | typo.H3 | typo.H4 -> theme.SizeAncestor
    typo.Pre(size) | typo.Label(size) | typo.Span(size) | typo.Paragraph(size) ->
      size
  }
}

// PRIVATE
//

/// Aqui pintamos nosso tema para os elementos de tipografia.
///
/// - size: O tamanho do elemento.
/// - state: O estado do elemento.
/// - variant: A variante do tema do elemento.
/// - direction: A direção do elemento.
/// - appearance: A aparência do estilo do elemento.
fn paint_theme(
  size size: theme.UISize,
  state state: theme.UIState,
  variant variant: theme.UIVariant,
  direction _direction: theme.UIDirection,
  appearance appearance: theme.UIAppearance,
  attributes attributes: List(a.Attribute(msg)),
) -> List(a.Attribute(msg)) {
  [
    // size
    case size {
      theme.SizeAncestor -> "text-base"
      theme.SizeXxl -> "text-2xl"
      theme.SizeXl -> "text-xl"
      theme.SizeLg -> "text-lg"
      theme.SizeBase -> "text-base"
      theme.SizeSm -> "text-sm"
      theme.SizeXs -> "text-xs"
    }
      |> a.class(),
    // todo shape
    // todo elevation
    // variant
    case variant, appearance, state {
      theme.VariantAncestor, _, _ -> "text-gray-800 dark:text-white/90"
      theme.VariantPrimary, _, _ -> "text-brand-950 dark:text-brand-400"
      theme.VariantSecondary, _, _ -> "text-brand-800 dark:text-brand-300"
      theme.VariantTertiary, _, _ -> "text-brand-700 dark:text-brand-200"
      theme.VariantInfo, _, _ -> "text-success-800 dark:text-success-300"
      theme.VariantSuccess, _, _ -> "text-success-800 dark:text-success-300"
      theme.VariantWarning, _, _ -> "text-warning-800 dark:text-warning-300"
      theme.VariantError, _, _ -> "text-red-950 dark:text-red-400"
    }
      |> a.class(),
    // appearance
    case appearance, size {
      theme.AppearanceAncestor, _ -> "text-noraml"
      theme.AppearanceFilled, _ -> "text-bold"
      theme.AppearanceSlit, _ -> "truncate"
      theme.AppearanceGhost, size -> ghost_appearance(size)
      theme.AppearanceLight, size -> light_appearance(size)
      theme.AppearanceFlat, size -> flat_appearance(size)
      theme.AppearanceThin, size -> thin_appearance(size)
    }
      |> a.class(),
    ..attributes
  ]
}

fn header_classes(typo) {
  case typo {
    typo.H1 -> [#(const_class_h1, True)]
    typo.H2 -> [#(const_class_h2, True)]
    typo.H3 -> [#(const_class_h3, True)]
    typo.H4 -> [#(const_class_h4, True)]
    _ -> []
  }
}

/// Constante p/ pintar o cabeçalho <h1/>
const const_class_h1 = "text-title-xl sm:text-title-2xl" <> const_h

/// Constante p/ pintar o cabeçalho <h2/>
const const_class_h2 = "text-title-lg sm:text-title-xl" <> const_h

/// Constante p/ pintar o cabeçalho <h3/>
const const_class_h3 = "text-title-md sm:text-title-lg" <> const_h

/// Constante p/ pintar o cabeçalho <h4/>
const const_class_h4 = "text-title-sm sm:text-title-md" <> const_h

const const_h = " mb-2"

fn light_appearance(size) {
  case size {
    theme.SizeAncestor -> "text-light"
    theme.SizeXxl | theme.SizeXl | theme.SizeLg -> "text-extralight"
    theme.SizeBase | theme.SizeSm | theme.SizeXs -> "text-light"
  }
}

fn flat_appearance(size) {
  case size {
    theme.SizeXxl | theme.SizeXl | theme.SizeLg -> "text-pretty"
    theme.SizeBase | theme.SizeSm -> "text-balance"
    theme.SizeXs -> "text-wrap"
    theme.SizeAncestor -> "text-nowrap"
  }
}

fn thin_appearance(size: UISize) {
  case size {
    theme.SizeAncestor | theme.SizeBase | theme.SizeSm | theme.SizeXs ->
      "text-extrathin"

    theme.SizeXxl | theme.SizeXl | theme.SizeLg -> "text-thin"
  }
}

fn ghost_appearance(size) {
  let shadow =
    size_suffix(size)
    |> string.append("text-shadow-", _)

  string.join(["text-bold", shadow], " ")
}

fn size_suffix(size) {
  case size {
    theme.SizeXxl -> "6xl"
    theme.SizeXl -> "4xl"
    theme.SizeLg -> "2xl"
    theme.SizeBase -> "xl"
    theme.SizeSm -> "lg"
    theme.SizeXs -> "md"
    theme.SizeAncestor -> "sm"
  }
}
