////
//// ✍ GBR: UI Typography Module
////
//// Olá, neste módulo temos o componente visual para escrevermos textos.
////
//// > Imagine este módulo como se fosse uma máquina de escrever, com várias
//// opções de fontes, tamanhos, etc.
////
//// ```gleam
//// pub fn title(state) {
////   let title = H2
////   let variant = theme.primary()
////   let appearance = theme.filled()
////
////   theme.new()
////   |> theme.with_design_to_tokens(design_classes)
////   |> theme.with_variant(variant:)
////   |> theme.with_appearance(appearance:)
////   |> theme.with_state(state)
////   |> view(title, theme: _, attributes: [], elements: [])
//// }
////
//// fn design_classes(v, a, s) {
////   case v, a, s {
////     theme.VariantPrimary, theme.AppearanceFilled, theme.StateIdle ->
////       "text-primary-500"
////     theme.VariantPrimary, theme.AppearanceFilled, theme.StateHover ->
////       "hover:text-primary-600 text-primary-500"
////     _, _, _ -> "text-secondary-500"
////   }
////   |> theme.Class
////   |> theme.token_to_list
//// }
//// ```
////

import gleam/option.{Some}

import lustre/attribute as a
import lustre/element as el
import lustre/element/html as h

import gbr/ui/theme

/// UI typograph: tipo para escrevermos na tela.
///
/// - H1..H4: São os cabeçalhos e níveis.
/// - Pre: São textos usados para representar códigos, etc.
/// - Span: São textos comuns.
/// - Label: São textos utilizados c/ os inputs.
/// - Paragraph: São os textos em formato de parágrafo.
pub type UITypography {
  H1
  H2
  H3
  H4
  H5
  H6
  Pre(size: theme.UISize)
  Span(size: theme.UISize)
  Label(size: theme.UISize)
  Paragraph(size: theme.UISize)
}

//
// --- Api
//

/// View UI: Elemento tipográfico.
///
/// - typo: O tipo de tipografia, o que vamos escrever na tela.
/// - theme: Os dados do tema a ser aplicado na tipografia.
/// - attributes: Mais atributos para a tipografia, incluídos ao final.
///
pub fn view(
  typo: UITypography,
  theme theme,
  attributes attributes,
  elements elements,
) {
  let theme =
    theme
    |> theme.with_size(Some(to_size(typo)))

  case typo {
    H1 -> theme.to_lustre(theme, attributes, elements, h.h1)
    H2 -> theme.to_lustre(theme, attributes, elements, h.h2)
    H3 -> theme.to_lustre(theme, attributes, elements, h.h3)
    H4 -> theme.to_lustre(theme, attributes, elements, h.h4)
    H5 -> theme.to_lustre(theme, attributes, elements, h.h5)
    H6 -> theme.to_lustre(theme, attributes, elements, h.h6)
    Pre(_) -> theme.to_lustre(theme, attributes, elements, h.pre)
    Span(_) -> theme.to_lustre(theme, attributes, elements, h.span)
    Label(_) -> theme.to_lustre(theme, attributes, elements, h.label)
    Paragraph(_) -> theme.to_lustre(theme, attributes, elements, h.p)
  }
}

// -----------------------------------------------------------------------------
//
// -- Api
//
// -----------------------------------------------------------------------------

/// Construtor universal de tipografia.
///
pub fn text(
  typo: UITypography,
  theme: theme.UITheme(theme.UILustre),
  text,
  attributes,
) {
  view(typo, theme, attributes, [h.text(text)])
}

// -----------------------------------------------------------------------------
//
// -- Header
//
// -----------------------------------------------------------------------------

/// Header 1
///
pub fn h1(theme, with attributes: List(a.Attribute(msg)), elements elements) {
  view(H1, theme, attributes, elements)
}

/// Header 2
///
pub fn h2(
  theme,
  attributes attributes: List(a.Attribute(msg)),
  elements elements,
) -> el.Element(msg) {
  view(H2, theme, attributes, elements)
}

/// Header 3
///
pub fn h3_with(
  theme,
  attributes attributes: List(a.Attribute(msg)),
  with elements,
) {
  view(H3, theme, attributes, elements)
}

/// Header 4
///
pub fn h4(
  theme,
  attributes attributes: List(a.Attribute(msg)),
  elements elements,
) -> el.Element(msg) {
  view(H4, theme, attributes, elements)
}

/// Header 5
///
pub fn h5(
  theme,
  attributes attributes: List(a.Attribute(msg)),
  elements elements,
) -> el.Element(msg) {
  view(H5, theme, attributes, elements)
}

/// Header 6
///
pub fn h6(
  theme,
  attributes attributes: List(a.Attribute(msg)),
  elements elements,
) -> el.Element(msg) {
  view(H6, theme, attributes, elements)
}

// -----------------------------------------------------------------------------
//
// -- Span
//
// -----------------------------------------------------------------------------

/// Span
///
pub fn span(
  theme,
  size size,
  attributes attributes: List(a.Attribute(msg)),
  elements elements,
) {
  view(Span(size), theme, attributes, elements)
}

// -----------------------------------------------------------------------------
//
// -- Pre
//
// -----------------------------------------------------------------------------

/// Pre
///
pub fn pre(
  theme,
  size size,
  attributes attributes: List(a.Attribute(msg)),
  elements elements,
) -> el.Element(msg) {
  view(Pre(size), theme, attributes, elements)
}

// -----------------------------------------------------------------------------
//
// -- Paragrafo
//
// -----------------------------------------------------------------------------

/// Paragraph
///
pub fn p(
  theme,
  size,
  attributes attributes: List(a.Attribute(msg)),
  elements elements,
) -> el.Element(msg) {
  view(Paragraph(size), theme, attributes, elements)
}

// -----------------------------------------------------------------------------
//
// -- Label
//
// -----------------------------------------------------------------------------

/// Label
///
pub fn label(
  theme,
  size,
  attributes attributes: List(a.Attribute(msg)),
  elements elements,
) -> el.Element(msg) {
  view(Label(size), theme, attributes, elements)
}

//
// -- HELPERS
//

/// Retorna se a tipografia é de um tipo de cabeçalho.
///
/// - typo: Dados da tipografia.
///
pub fn is_header(typo) {
  case typo {
    H1 | H2 | H3 | H4 | H5 | H6 -> True
    Pre(_) | Span(_) | Label(_) | Paragraph(_) -> False
  }
}

/// Recupera um cabeçalho pelo tamanho passado como argumento.
///
/// - size: Tamanho desejado do cabeçalho de retorno.
///
pub fn header_from_size(size: theme.UISize) {
  case size {
    theme.SizeXxl -> H1
    theme.SizeXl -> H2
    theme.SizeLg -> H3
    theme.SizeMd -> H4
    theme.SizeSm -> H5
    theme.SizeXs | _ -> H6
  }
}

/// Retorna o tamnaho a partir da tipografia, se existir.
///
/// - typo: Dados sobre a tipografia.
///
pub fn to_size(typo: UITypography) -> theme.UISize {
  case typo {
    H1 -> theme.SizeXxl
    H2 -> theme.SizeXl
    H3 -> theme.SizeLg
    H4 -> theme.SizeMd
    H5 -> theme.SizeSm
    H6 -> theme.SizeXs
    Pre(size:) | Label(size:) | Span(size:) | Paragraph(size:) -> size
  }
}
