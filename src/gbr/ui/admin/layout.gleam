////
//// 🧱 🏢 UI admin layout module
////
//// Olá, como vai? Aqui temos o módulo de layouts administrativos para ser
//// utilizado em aplicações enterprise.

import gleam/option.{type Option, None, Some}

import lustre/attribute as a
import lustre/element as el
import lustre/element/html as h

import gbr/ui/core/theme.{type UIStacking}

// ==========================================
// 🏢 MACRO LAYOUTS (App Shells do Admin)
// Estes são donos da tela inteira, cores de fundo e scroll!
// ==========================================

/// UI admin layout primary, este layout é usado para a tela shell(home),
/// onde temos o local do sidebar, header e o conteúdo principal.
///
/// - header: Elemento que representa o header.
/// - sidebar: Elemento que representa o sidebar.
/// - content: Elemento que representa o conteúdo principal.
/// - breadcrumb: TODO
/// - footer: TODO
///
pub fn view_primary(
  header: el.Element(msg),
  sidebar: el.Element(msg),
  content: el.Element(msg),
) -> el.Element(msg) {
  let container_attributes = [
    class_hscreen_overflow_hidden_flex(),
    class_background_primary(),
  ]
  let main_attributes = [
    class_flex_col_1(),
    class_overflow_x_hidden_y_auto(),
    a.class("relative"),
  ]
  h.div(container_attributes, [
    // sidebar area
    sidebar,
    // content area
    h.div(main_attributes, [
      // TODO: oerlay mobile, close when outside menu
      header,
      // main area
      h.main([], [
        // html.div([class(main_body_class)], [
        // TODO: breadcrumb
        content,
        // ]),
      ]),
      // TODO: footer area
    ]),
  ])
}

/// UI admin layout secondary
///
/// - inner: Elementos internos do layout.
/// - container: Atributos do container principal.
/// - inner_with: Attributos do container dos elementos internos.
pub fn view_secondary(
  inner inner: List(el.Element(msg)),
  container container_attributes: List(a.Attribute(msg)),
  inner_with inner_attributes: List(a.Attribute(msg)),
) {
  let container_attributes = [
    a.class("sm:p-0"),
    class_background_secondary(),
    class_hscreen_wfull_center_justify(),
    ..container_attributes
  ]

  h.div(inner_attributes, [
    h.div(container_attributes, inner),
  ])
}

/// UI content layout contendo um ou mais cabeçalhos, conteúdos principais
/// e rodapés.
///
/// Este layout é usado junto com o layout.primary para preencher o conteúdo
/// principal da home segura.
///
/// - content: Conteúdos principais.
/// - header: Componentes do cabeçalho.
/// - footer: Componentes do rodapé.
///
pub fn view_content(
  content: List(el.Element(msg)),
  header: List(el.Element(msg)),
  footer: List(el.Element(msg)),
  attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  let container_attributes = [
    a.class(
      "w-full h-full pt-4 my-2 rounded-2xl border border-gray-200 bg-white "
      <> "dark:border-gray-800 dark:bg-white/[0.03]",
    ),
    ..attributes
  ]
  let header_attributes = [
    a.class("flex gap-2 px-5 mb-4 items-center justify-between"),
  ]
  let content_attributes = [
    a.class(
      "p-5 space-y-4 border-t border-gray-100 dark:border-gray-700 custom-scrollbar "
      <> "max-w-full overflow-x-auto overflow-y-visible",
    ),
  ]
  let footer_attributes = [
    a.class("border-t border-gray-200 px-6 py-4 dark:border-gray-800"),
  ]
  let header = case header {
    [] -> el.none()
    header -> h.div(header_attributes, header)
  }
  let content = case content {
    [] -> el.none()
    content -> h.div(content_attributes, content)
  }
  let footer = case footer {
    [] -> el.none()
    footer -> h.div(footer_attributes, footer)
  }

  h.div(container_attributes, [header, content, footer])
}

/// UI admin layout page contendo um título e elementos filhos.
///
/// Muito utilizada juntamente com layout.primary para compor seu conteúdo
/// principal, seguindo o estilo menu selecionado e página principal carregada.
///
/// - title: Título da página.
/// - inner: Elementos internos da página.
///
pub fn view_page(
  title: String,
  inner: List(el.Element(msg)),
  attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  let container_attributes = [
    a.class("mx-auto max-w-(--breakpoint-2xl) p-2 md:pt-2 md:p-4"),
    ..attributes
  ]
  let title_attributes = [
    a.class("flex flex-wrap items-center justify-between gap-3 pb-1"),
  ]
  let title_elements = [
    h.h2([a.class("text-xl font-semibold text-gray-800 dark:text-white/90")], [
      h.text(title),
    ]),
  ]

  h.div(container_attributes, [h.div(title_attributes, title_elements), ..inner])
}

/// UI admin layout hero contendo elementos à esquerda, à direita e contendo
/// elementos internos.
///
/// Excelente para usar com páginas de erro, e.g. 404, ou páginas de sucesso
/// de pagamento.
///
/// Suponha uma página 404 com uma imagem de fundo:
///
/// ```gleam
/// pub fn view() -> Element(Msg) {
///   let left = html.img([src("/assets/grid-01.svg"), alt("Grid1")])
///   let right = html.img([src("/assets/grid-02.svg"), alt("Grid2")])
///   let inner = [
///     html.h1([], [html.text("404: Not found")])
///   ]
///
///   ui.hero(left:, right:, inner:)
/// }
/// ```
pub fn view_hero(
  left: List(el.Element(msg)),
  right: List(el.Element(msg)),
  inner: List(el.Element(msg)),
) -> el.Element(msg) {
  h.div(
    [
      a.class(
        "bg-brand-950 relative hidden h-full w-full items-center lg:grid lg:w-1/2 dark:bg-white/5",
      ),
    ],
    [
      h.div([a.class("z-1 flex items-center justify-center")], [
        h.div(
          [
            a.class(
              "absolute right-0 top-0 -z-1 w-full max-w-[250px] xl:max-w-[450px]",
            ),
          ],
          left,
        ),
        h.div(
          [
            a.class(
              "absolute bottom-0 left-0 -z-1 w-full max-w-[250px] rotate-180 xl:max-w-[450px]",
            ),
          ],
          right,
        ),
        ..inner
      ]),
    ],
  )
}

/// TODO remover esta função p/ um arquivo próprio `admin/separator.gleam`
pub fn view_separator(label: Option(String)) -> el.Element(msg) {
  let transform = fn(label) {
    h.span(
      [a.class("bg-white p-2 text-gray-400 sm:px-5 sm:py-2 dark:bg-gray-900")],
      [h.text(label)],
    )
  }
  let label =
    label
    |> option.map(transform)
    |> option.unwrap(el.none())

  h.div([a.class("relative py-3 sm:py-5")], [
    h.div([a.class("absolute inset-0 flex items-center")], [
      h.div(
        [a.class("w-full border-t border-gray-200 dark:border-gray-800")],
        [],
      ),
    ]),
    h.div([a.class("relative flex justify-center text-sm")], [label]),
  ])
}

/// Principal do Sistema (Dashboard).
/// Controla o Header, Sidebar e a Área de Conteúdo.
pub fn view_dashboard(
  header header: el.Element(msg),
  sidebar sidebar: el.Element(msg),
  content content: el.Element(msg),
) -> el.Element(msg) {
  let container_attributes = [
    class_hscreen_overflow_hidden_flex(),
    class_background_secondary(),
  ]
  let main_attributes = [
    a.class("relative flex flex-1 flex-col overflow-x-hidden overflow-y-auto"),
  ]
  let main = h.main([], [content])

  h.div(container_attributes, [
    sidebar,
    h.div(main_attributes, [header, main]),
  ])
}

/// Container Centralizado de Tela Cheia.
/// Ideal para Telas de Login, 404, Bloqueio de Tela.
pub fn view_fullscreen_center(
  attributes: List(a.Attribute(msg)),
  with content: el.Element(msg),
) -> el.Element(msg) {
  let container_attributes = [
    a.class(
      "flex h-screen w-full items-center justify-center bg-white/90 dark:bg-gray-900",
    ),
    ..attributes
  ]

  h.div(container_attributes, [content])
}

/// Container de Página Branca (Card de Conteúdo do Dashboard)
pub fn view_content_card(
  header header: Option(el.Element(msg)),
  body body: el.Element(msg),
  footer footer: Option(el.Element(msg)),
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  // Usamos as nossas próprias primitivas limpas!
  let header = case header {
    Some(header) ->
      h.div(
        [a.class("px-5 py-4 border-b border-gray-200 dark:border-gray-800")],
        [header],
      )
    None -> el.none()
  }
  let footer = case footer {
    Some(footer) ->
      h.div(
        [a.class("px-5 py-4 border-t border-gray-200 dark:border-gray-800")],
        [footer],
      )
    None -> el.none()
  }
  let container_attributes = [
    a.class(
      "w-full rounded-2xl border border-gray-200 bg-white dark:border-gray-800 dark:bg-white/[0.03]",
    ),
    ..attributes
  ]

  h.div(container_attributes, [header, h.div([a.class("p-5")], [body]), footer])
}

// ==========================================
// 🧱 MICRO LAYOUTS (Geometria Pura e Reutilizável)
// Não possuem cor, não possuem h-screen. Apenas alinham coisas!
// ==========================================

/// Alinha elementos lado a lado (Esquerda para Direita).
/// Útil para botões, toolbars, ícones.
pub fn view_row(
  attributes: List(a.Attribute(msg)),
  with elements: List(el.Element(msg)),
) -> el.Element(msg) {
  h.div([a.class("flex flex-row items-center gap-4"), ..attributes], elements)
}

/// Empilha elementos de cima para baixo.
/// Útil para formulários, listas de cards.
pub fn view_col(
  elements: List(el.Element(msg)),
  with attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  h.div([a.class("flex flex-col gap-4"), ..attributes], elements)
}

/// Layout responsivo clássico (Split):
/// Coluna no celular (empilhado) e Linha no Desktop (lado a lado).
pub fn view_split_responsive(
  attributes: List(a.Attribute(msg)),
  inner elements: List(el.Element(msg)),
) -> el.Element(msg) {
  h.div([a.class("flex flex-col lg:flex-row w-full"), ..attributes], elements)
}

/// Layout view com z-index, podemos esconder outros elementos com este
/// layout com a habilidade de manipular o z-index do elemento.
///
/// Retorna um lustre `html.div`
pub fn view_hwscreen_center(
  attributes: List(a.Attribute(msg)),
  elements elements: List(el.Element(msg)),
) {
  view_hwscreen_center_zindex(theme.IndexBase, attributes, elements:)
}

/// Layout view com altura e largura do screen, elementos centralizados e
/// controle sobre o z-index.
///
/// Podemos esconder ou se esconder dos outros elementos com esta view, somente
/// manipulado o z-index do elemento.
///
/// Retorna um lustre `html.div`
pub fn view_hwscreen_center_zindex(
  zindex: UIStacking,
  attributes: List(a.Attribute(msg)),
  elements elements: List(el.Element(msg)),
) -> el.Element(msg) {
  let attributes = [
    class_hwscreen_center_all(),
    class_background_primary(),
    class_top_left_reset(),
    class_zindex(zindex),
    class_flex_fixed(),
    ..attributes
  ]

  h.div(attributes, elements)
}

// ==========================================
// 🛠️ HELPER LAYOUTS
// Estes são donos do trabalho sujo, conversões de tipos, etc!
// ==========================================

/// Converte o tipo de empilhamento do tema para a representação html.
///
/// - IndexBase: --z-index-1
/// - IndexXxs:  --z-index-9
/// - IndexXs:   --z-index-99
/// - IndexSm:   --z-index-999
/// - IndexLg:   --z-index-9999
/// - IndexXl:   --z-index-99999
/// - IndexXxl:  --z-index-999999
pub fn class_zindex(stacking: UIStacking) -> a.Attribute(msg) {
  case stacking {
    theme.IndexBase -> "z-1"
    theme.IndexXxs -> "z-9"
    theme.IndexXs -> "z-99"
    theme.IndexSm -> "z-999"
    theme.IndexLg -> "z-9999"
    theme.IndexXl -> "z-99999"
    theme.IndexXxl -> "z-999999"
  }
  |> a.class()
}

/// Retorna a classe de background do tema primário.
///
/// lustre `attribute.class`
pub fn class_background_primary() -> a.Attribute(msg) {
  a.class("bg-white/90 dark:bg-gray-900")
}

/// Classe de background do tema secundário.
///
/// lustre `attribute.class`
pub fn class_background_secondary() -> a.Attribute(msg) {
  a.class("bg-gray-100 dark:bg-gray-800")
}

/// Classe de background do tema fallback.
///
/// lustre `attribute.class`
pub fn class_background_tertiary() -> a.Attribute(msg) {
  a.class("bg-gray-200 dark:bg-gray-700")
}

/// Classe de altura do screen e elementos centralizados.
///
/// Centraliza os elementos horizontalmente (quando a direção é linha) ou
/// verticalmente (quando a direção é coluna). **direção do flex/grid**.
///
/// lustre `attribute.class`
pub fn class_hscreen_wfull_center_justify() {
  a.class("h-screen w-full justify-center")
}

/// Classe de alturaXlargura do screen e elementos centralizados.
///
/// Importante: utiliza "items-center justify-center"
///
/// lustre `attribute.class`,
pub fn class_hwscreen_center_all() -> a.Attribute(msg) {
  a.class("h-screen w-screen items-center justify-center")
}

//PRIVATE
//

fn class_flex_fixed() {
  a.class("flex fixed")
}

fn class_top_left_reset() {
  a.class("left-0 top-0")
}

fn class_hscreen_overflow_hidden_flex() {
  a.class("h-screen overflow-hidden flex")
}

fn class_flex_col_1() {
  a.class("flex flex-1 flex-col")
}

fn class_overflow_x_hidden_y_auto() {
  a.class("overflow-x-hidden overflow-y-auto")
}
