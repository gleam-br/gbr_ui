////
//// 🔄 UI tailwindcss loader module
////
//// Olá, de volta por aqui? Vamo lá, este módulo é encarregado por construir
//// um elemento de carregamento, evitando o usuário de realizar ações enquanto
//// o sistema está ocupado.

import lustre/attribute as a
import lustre/element as el
import lustre/element/html as h

import gbr/ui/tailwindcss/engine
import gbr/ui/tailwindcss/layout
import gbr/ui/theme

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
/// import gbr/ui/tailwindcss/loader
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
///   // coloque aqui para testar um setTimeout(1000)
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
  layout.center_screen([layout.with_z_index(theme.StackXxl)], [
    h.div(paint_theme_default([]), children),
  ])
}

// PRIVATE
//

/// **PAINT THEME DEFAULT**
///
/// - attributes: Mais atributos lustre p/ este loader
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

/// **PAINT THEME**
///
/// TODO Work in progress...
///
/// - size: O tamanho do tema, e.g. SizeMd, SizeLg.
/// - shape: O formato do tema, e.g. ShapePill, ShapeSharp.
/// - state: O estado do tema, e.g. StateLoading, StateIdle.
/// - variant: A variante do tema, e.g. VariantDefault, VariantPrimary.
/// - direction: A direção do loader na tela, e.g. DirectionCentral, DirectionLeft.
/// - appearance: A aparência do tema, e.g. AppearanceFilled, AppearanceGhost.
/// - attributes: Mais atributos lustre p/ este loader
fn paint_theme(
  size _size: theme.UISize,
  state _state: theme.UIState,
  variant _variant: theme.UIVariant,
  direction _direction: theme.UIDirection,
  appearance _appearance: theme.UIAppearance,
  attributes attributes: List(a.Attribute(msg)),
) -> List(a.Attribute(msg)) {
  let classes =
    engine.new([#(const_class_spinner, True)])
    |> engine.resolve()

  [classes, ..attributes]
}

/// Classes de estilo padrão do loader spinner
const const_class_spinner = "h-16 w-16 animate-spin rounded-full border-4 "
  <> "border-solid border-primary-500 border-t-transparent"
