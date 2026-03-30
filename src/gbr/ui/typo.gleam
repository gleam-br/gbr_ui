////
//// ✍🏻 UI core typography elements
////
//// Olá, aqui temos o componente visual para escrevermos textos na tela
//// do usuário. Imagine este módulo como se fosse uma máquina de escrever
//// com várias opções de fontes, tamanhos, etc.
////
//// Aqui só lidamos com DOM (HTML + a11y)

import lustre/attribute as a
import lustre/element as el
import lustre/element/html as h

import gbr/ui/theme.{type UISize}

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
  Pre(UISize)
  Span(UISize)
  Label(UISize)
  Paragraph(UISize)
}

/// Aqui mostramos um texto sem estilo algum aplicado.
///
/// - tag: O tipo de tipografia que vamos mostrar na tela.
/// - text: O conteúdo de texto que vamos mostrar na tela.
/// - attributes: Lista de atributos do elemento de tipografia.
@internal
pub fn to_element(
  typo: UITypography,
  text: String,
  with attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  let elements = [h.text(text)]

  // Se a W3C mudar alguma regra de acessibilidade global para textos,
  // alteramos AQUI e o sistema inteiro herda.
  case typo {
    H1 -> h.h1(attributes, elements)
    H2 -> h.h2(attributes, elements)
    H3 -> h.h3(attributes, elements)
    H4 -> h.h4(attributes, elements)
    Pre(_) -> h.pre(attributes, elements)
    Span(_) -> h.span(attributes, elements)
    Label(_) -> h.label(attributes, elements)
    Paragraph(_) -> h.p(attributes, elements)
  }
}
