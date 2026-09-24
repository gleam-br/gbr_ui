////
//// GBR: UI Theme Lustre Module
////
//// # Descrição
////
//// Módulo que sobre-escreve funções do módulo lustre/element/html utilizando o
//// tipo `ui.UITheme` como argumento. Utiliza o tipo `UILustre` os tokens (ADT)
//// que representam as funções lustre. Exemplo:
////
//// Sem `ui.UITheme`:
////
//// ```gleam
//// import lustre/element/html as h
////
//// pub fn main() {
////   let theme = [
////     // codigos p/ selecionar tema primário ou defaul (fallback)
////     ...
////   ]
////
////   h.span(theme, [h.text("Olá mundo!")])
//// }
//// ```
////
//// Com `ui.Theme`:
////
//// ```gleam
//// import gbr/ui/lustre as h
////
//// pub fn main() {
////   ui.new()
////   |> ui.with_variant(ui.primary())
////   |> ui.with_appearance(ui.ghost())
////   |> ui.with_design_to_tokens(fn(v, a, _) {
////     case v, a {
////       ui.VariantPrimary, _ -> [
////         h.Style("display", "block"),
////         h.Class("text-primary-700"),
////         h.Classes([#("hover:text-primary-800", a == ui.AppearanceGhost)]),
////       ]
////       _, _ -> "text-gray-800"
////     }
////   })
////   |> h.span([],[h.text("Olá mundo!")])
//// }
//// ```
////
//// -----------------------------------------------------------------------------
////
//// ## Implementaçâo Do Tema Usando o Lustre
////
//// **Lustre + UIThemeBuilder**
////
//// Utilizamos os design tokens do tema como uma estrutura de uma tupla
//// `#(String, Bool)`, compatível com a assinatura da função `attribute.classes`
//// do lustre.
////
//// ```gleam
//// pub fn to_lustre(
////   theme: UITheme(UILustre),
////   attributes: List(a.Attribute(a)),
////   elements: List(element.Element(a)),
////   to_lustre: fn(List(a.Attribute(a)), List(element.Element(a))) ->
////   element.Element(a),
//// ) -> element.Element(a) {
////   let engine_lustre = fn(token) {
////     case token {
////       Class(token) -> a.class(token)
////       Classes(token) -> a.classes(token)
////       Styles(token) -> a.styles(token)
////       Style(key, value) -> a.style(key, value)
////       Empty -> a.none()
////     }
////   }
////   ui.view(theme, fn(tokens: List(UILustre)) {
////     let attributes =
////       list.map(tokens, engine_lustre)
////       |> list.append(attributes)
////
////     to_lustre(attributes, elements)
////   })
//// }
//// ```
////
//// A função acima é o coração deste módulo, ela converte a lista de tokens,
//// representando os design tokens lustre gerados pelo tema, em um atributo
//// lustre `attribute.Attribute(msg)`, usando `attribute.classes`, `a.class`,
//// `a.styles`, etc.
////
//// Abaixo segue como o tema utiliza a injeção desta implementação
////
//// ```gleam
//// import lustre/attribute as a
//// import lustre/element/html as h
////
//// pub fn new_theme_admin() {
////   theme.new()
////   |> theme.with_size_to_tokens(size_classes)
////   |> theme.with_shape_to_tokens(rounded_classes)
////   |> theme.with_elevation_to_tokens(border_classes)
////   |> theme.with_stacking_to_tokens(stack_classes)
////   |> theme.with_design_to_tokens(design_classes)
//// }
////
//// pub fn size_classes(size) {
////   case size {
////     ui.SizeMd -> "h-120 w-240"
////     ui.SizeSm -> "h-90 w-120"
////     // ...
////   }
//// }
//// // ...
////
//// pub fn alert(text) {
////   // Estilos externos
////   let attributes = [ a.class("mb-2") ]
////
////   // O texto do alerta (inner)
////   let elements = [h.text(text)]
////
////   let to_alert = fn(theme) {
////     // Motor de design tokens para um elemento lustre
////     to_lustre(theme, attributes, elements, h.div)
////     |> theme.view(theme, _)
////   }
////
////   new_theme_admin()
////   |> theme.with_variant(theme.VariantPrimary)
////   |> theme.with_appearance(theme.AppearanceFill)
////   |> theme.with_state(theme.StateFocus)
////   |> theme.with_size(theme.SizeLg)
////   |> theme.with_shape(theme.ShapePill)
////   |> theme.with_elevation(theme.ElevationFlat)
////   |> theme.with_stacking(theme.StackXxl)
////   |> to_alert()
//// }
//// ```
////
//// ## Regra da Propriedade do CSS
////
//// - **Componente é dono de si mesmo:** Ele dita o seu próprio padding,
//// background, text-color e border-radius. Se o usuário quer um botão menor,
//// ele deve usar a ADT `theme.SizeSm`.
//// - **Usuário é dono do espaço exterior (DOM):** O argumento `attributes` serve
//// EXCLUSIVAMENTE para injetar:
////   - **Margens:** mt-4, mb-2 (porque o botão não sabe se ele está perto ou
//// longe de outro elemento).
////   - **Posicionamento:** absolute, flex.
////   - **Metadados do DOM:** id="meu-botao", aria-label, data-testid.
////   - **Eventos extras:** on_mouse_enter, on_blur.
////

import gleam/list
import gleam/string

import lustre/attribute as a
import lustre/element
import lustre/element/html as h

import gbr/ui/theme.{type UITheme}

// -----------------------------------------------------------------------------
//
// -- 🛠️ ENGINE LUSTRE (DESIGN TOKEN)
//
// -----------------------------------------------------------------------------

/// Tipos que representam os design tokens convertidos para atributos lustre.
///
/// - Classes: Convertido para a.classes
/// - Styles: Convertido para a.styles
/// - Style: Convertido para a.style
/// - Class: Convertido para a.class
///
pub type UILustre {
  Classes(List(#(String, Bool)))
  Styles(List(#(String, String)))
  Style(String, String)
  Class(String)
  Attribute(String, String)
  Empty
}

/// Conversor dos design tokens para um elementos lustre.
///
/// - theme: Design tokens gerados a partir do tema + o construtor de temas.
/// - attributes: Atributos do elemento lustre.
/// - elements: Elementos internos, caso necessário.
/// - to_lustre: Construtor do elemento lustre.
///
pub fn to_lustre(
  theme: UITheme(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
  to_lustre: fn(List(a.Attribute(a)), List(element.Element(a))) ->
    element.Element(a),
) -> element.Element(a) {
  let engine_lustre = fn(token) {
    case token {
      Class(token) -> a.class(token)
      Classes(token) -> a.classes(token)
      Styles(token) -> a.styles(token)
      Style(key, value) -> a.style(key, value)
      Attribute(key, value) -> a.attribute(key, value)
      Empty -> a.none()
    }
  }

  use tokens <- theme.view(theme)

  // fold class
  let assert Class(class) =
    list.fold(tokens, Class(""), fn(acc, token) {
      case token {
        Class(class) -> {
          let assert Class(acc) = acc as "acc"
          // TODO remove duplicates
          let class = string.trim(class)

          Class(acc <> class)
        }
        _ -> acc
      }
    })
    as "fold"

  let attributes =
    list.map(tokens, engine_lustre)
    |> list.append(attributes)

  to_lustre([a.class(class), ..attributes], elements)
}

// -----------------------------------------------------------------------------
//
// -- 🛠️ Componentes base
//
// -----------------------------------------------------------------------------

pub fn text(text: String) {
  h.text(text)
}

// -----------------------------------------------------------------------------
//
// 🧱 COMPONENTES (Lustre + UITheme + UIBuilder)
//
// -----------------------------------------------------------------------------

pub fn div(
  theme: UITheme(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.div)
}

pub fn main(
  theme: UITheme(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.main)
}

//
// -- Layout
//

/// Define um cabeçalho para o documento ou seção.
///
pub fn header(
  theme: UITheme(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.header)
}

/// Define uma seção no documento.
///
pub fn section(
  theme: UITheme(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.section)
}

/// Define um rodapé para o documento ou seção.
///
pub fn footer(
  theme: UITheme(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.footer)
}

/// Define um conteúdo independente, auto-contindo.
///
pub fn article(
  theme: UITheme(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.article)
}

/// Define um conteúdo a parte do conteúdo principal.
///
pub fn aside(
  theme: UITheme(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.aside)
}

/// Define um conjunto de links de navegação.
///
pub fn nav(
  theme: UITheme(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.nav)
}

/// Define detalhes adicionais que pode ser aberto para visualização.
///
/// - Usado em conjunto com o `summary()`. Algumas interfaces oferecem uma
/// descrição de resumo, `summary`, padrão.
///
pub fn details(
  theme: UITheme(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.details)
}

/// Define o cabeçalho para o elemento `details()`, caso necessário.
///
pub fn summary(
  theme: UITheme(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.summary)
}

//
// -- Lista
//

pub fn ul(
  theme: UITheme(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.ul)
}

pub fn li(
  theme: UITheme(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.li)
}

//
// -- Typoq
//

pub fn h1(theme, attributes, elements) {
  to_lustre(theme, attributes, elements, h.h1)
}

pub fn h2(theme, attributes, elements) {
  to_lustre(theme, attributes, elements, h.h2)
}

pub fn h3(theme, attributes, elements) {
  to_lustre(theme, attributes, elements, h.h3)
}

pub fn h4(theme, attributes, elements) {
  to_lustre(theme, attributes, elements, h.h4)
}

pub fn h5(theme, attributes, elements) {
  to_lustre(theme, attributes, elements, h.h5)
}

pub fn h6(theme, attributes, elements) {
  to_lustre(theme, attributes, elements, h.h6)
}

pub fn pre(theme, attributes, elements) {
  to_lustre(theme, attributes, elements, h.pre)
}

pub fn span(theme, attributes, elements) {
  to_lustre(theme, attributes, elements, h.span)
}

pub fn label(theme, attributes, elements) {
  to_lustre(theme, attributes, elements, h.label)
}

pub fn p(theme, attributes, elements) {
  to_lustre(theme, attributes, elements, h.p)
}

//
// -- Imagem
//

pub fn img(
  theme: UITheme(UILustre),
  attributes: List(a.Attribute(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, [], fn(a, _) { h.img(a) })
}

pub fn svg(
  theme: UITheme(UILustre),
  with attributes: List(a.Attribute(a)),
  inner elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.svg)
}

//
// -- Tabela
//

pub fn table(
  theme: UITheme(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.table)
}

pub fn th(
  theme: UITheme(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.th)
}

pub fn tr(
  theme: UITheme(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.tr)
}

pub fn td(
  theme: UITheme(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.td)
}

//
// -- Input
//

pub fn input(
  theme: UITheme(UILustre),
  attributes: List(a.Attribute(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, [], fn(a, _) { h.input(a) })
}

pub fn select(
  theme: UITheme(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.select)
}

/// <select...><option .../></select>
pub fn option(
  theme: UITheme(UILustre),
  label: String,
  attributes: List(a.Attribute(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, [], fn(a, _) { h.option(a, label) })
}

/// <textarea>...</textarea>
pub fn textarea(
  theme: UITheme(UILustre),
  text: String,
  a: List(a.Attribute(a)),
) -> element.Element(a) {
  to_lustre(theme, a, [], fn(a, _) { h.textarea(a, text) })
}

pub fn button(
  theme: UITheme(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.button)
}

pub fn a(
  theme: UITheme(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.a)
}
