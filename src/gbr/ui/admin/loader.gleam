////
//// 🔄 UI admin loader module
////
//// Olá, de volta por aqui? Vamo lá, este módulo é encarregado por construir
//// um elemento de carregamento, evitando o usuário de realizar ações enquanto
//// o sistema está ocupado.

import lustre/attribute as a
import lustre/element as el
import lustre/element/html as h

import gbr/ui/core/theme

import gbr/ui/admin/layout

/// UI admin loader elemento mostra um spinner animado centralizado indicando,
/// que a aplicação está carregando/em processamento. Esta funcionalidade não permite
/// que o usuário consiga realizar alguma alteração enquanto a aplicação estiver
/// realizando uma operação demorada.
///
/// To work with [gbr_js](https://github.com/gleam-br/gbr_js) and `gbr/js/global.{dom_content_loaded}`.
///
/// Suponha quando temos que esperar o DOM carregar ou as chamadas às apis iniciais:
/// - init: Model(loading: True)
/// - update: Model(loading: False):
///
/// ```gleam
/// import lustre/element.{type Element}
///
/// import gbr/ui/admin/loader
///
/// pub fn main() {
///   let runtime =
///     lustre.application(...
///       |> lustre.start("body", Nil)
///
///   on_dom_loaded(runtime)
/// }
///
/// fn on_dom_loaded(runtime) {
///   use _ <- global.dom_content_loaded()
///
///   //  setTimeout(1000) coloque aqui para testar
///
///   OnLoading(False)
///   |> lustre.dispatch()
///   |> lustre.send(runtime, _)
/// }
///
/// fn view(model: Model) -> Element(ModelEvent) {
///    let Model(loading:) = model
///
///   case loading {
///     True -> ui.loader([])
///     False -> element.none()
///   }
/// }
/// ```
pub fn view(children: List(el.Element(msg))) -> el.Element(msg) {
  let elements = [h.div(paint_theme_default([]), children)]
  layout.view_hwscreen_center_zindex(theme.IndexXxl, [], elements:)
}

// PRIVATE
//

/// Pinta o elemento loader de acordo com o tema padrão.
fn paint_theme_default(attributes attributes: List(a.Attribute(msg))) {
  paint_theme(
    size: theme.SizeAncestor,
    state: theme.StateAncestor,
    variant: theme.VariantAncestor,
    direction: theme.DirectionAncestor,
    appearance: theme.AppearanceAncestor,
    attributes:,
  )
}

/// Pinta o elemento loader de acordo com o tema.
fn paint_theme(
  size _size: theme.UISize,
  state _state: theme.UIState,
  variant _variant: theme.UIVariant,
  direction _direction: theme.UIDirection,
  appearance _appearance: theme.UIAppearance,
  attributes attributes: List(a.Attribute(msg)),
) -> List(a.Attribute(msg)) {
  [a.class(const_class_spinner), ..attributes]
}

/// Classes de estilo padrão do loader spinner
const const_class_spinner = "h-16 w-16 animate-spin rounded-full border-4 "
  <> "border-solid border-brand-500 border-t-transparent"
