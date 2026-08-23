////
//// 🏢 UI tailwindcss layout module
////
//// Olá, como vai? Aqui temos o módulo de layouts utilizando classes do tailwindcss

import lustre/attribute as a
import lustre/element as el
import lustre/element/html as h

import gbr/ui/theme

// ==========================================
// 🏗️ MACRO LAYOUTS (Os "App Shells")
// Focados EXCLUSIVAMENTE em distribuir espaço na tela inteira.
// SEM CORES. SEM BORDAS. (A View injeta as cores via `attributes`)
// ==========================================

/// Layout fullscreen
///
pub fn application_fullscreen(
  elements: List(el.Element(msg)),
  with attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  h.div(
    [
      a.class(
        "relative sm:p-0 flex h-screen w-full flex-col lg:flex-row justify-center",
      ),
      ..attributes
    ],
    elements,
  )
}

/// Um container split screen (Tela Dividida).
/// Lado esquerdo, lado direito e atributos da idetidade visual.
pub fn container_split_screen(
  left left: el.Element(msg),
  right right: el.Element(msg),
  with attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  h.div([a.class("flex h-screen w-full flex-wrap"), ..attributes], [
    h.div([a.class("flex flex-1 flex-col w-full lg:w-1/2")], [left]),
    h.div([a.class("hidden w-full lg:flex lg:w-1/2")], [right]),
  ])
}

/// O Layout Centralizado Absoluto.
/// Útil para Loading (spinner) Screens, Modais e 404 Simples.
pub fn center_screen(
  attributes: List(a.Attribute(msg)),
  inner elements: List(el.Element(msg)),
) -> el.Element(msg) {
  h.div(
    [a.class("flex h-screen w-full items-center justify-center"), ..attributes],
    elements,
  )
}

// ==========================================
// 🧱 MICRO LAYOUTS (Contêineres de Fluxo)
// Organizam os filhos em Linha ou Coluna.
// ==========================================

/// O equivalente ao `flex-row`.
pub fn row(
  attributes: List(a.Attribute(msg)),
  inner elements: List(el.Element(msg)),
) -> el.Element(msg) {
  h.div([a.class("flex flex-row items-center gap-4"), ..attributes], elements)
}

/// O equivalente ao `flex-col`.
pub fn col(
  attributes: List(a.Attribute(msg)),
  inner elements: List(el.Element(msg)),
) -> el.Element(msg) {
  h.div([a.class("flex flex-col gap-4"), ..attributes], elements)
}

/// O Grid Layout.
pub fn grid(
  attributes: List(a.Attribute(msg)),
  inner elements: List(el.Element(msg)),
) -> el.Element(msg) {
  h.div([a.class("grid gap-4"), ..attributes], elements)
}

// ==========================================
// 📏 LAYOUTS DE CONTEÚDO (Containers limitadores)
// ==========================================

/// O Container de Página.
/// Limita a largura máxima para não esticar infinitamente em monitores UltraWide.
pub fn page_container(
  attributes: List(a.Attribute(msg)),
  inner elements: List(el.Element(msg)),
) -> el.Element(msg) {
  h.div(
    [
      a.class("mx-auto w-full max-w-screen-2xl p-4 md:p-6 2xl:p-10"),
      ..attributes
    ],
    elements,
  )
}

// ==========================================
// 🛠️ HELPER LAYOUTS (Física)
// ==========================================

/// Aplica o Z-Index da nossa ADT Algébrica.
/// Ideal para usar em modais, dropdowns e overlays.
pub fn with_z_index(stacking: theme.UIStacking) -> a.Attribute(msg) {
  case stacking {
    theme.StackBase -> "z-1"
    theme.StackXxs -> "z-10"
    theme.StackXs -> "z-20"
    theme.StackSm -> "z-30"
    theme.StackLg -> "z-40"
    theme.StackXl -> "z-50"
    theme.StackXxl -> "z-9999"
    theme.StackAncestor(_) -> "z-inherit"
  }
  |> a.class()
}
