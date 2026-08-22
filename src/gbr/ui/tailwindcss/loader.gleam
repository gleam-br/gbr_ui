////
//// 🔄 UI tailwindcss loader module
////
//// Olá, de volta por aqui? Vamo lá, este módulo é encarregado por construir
//// um elemento de carregamento, evitando o usuário de realizar ações enquanto
//// o sistema está ocupado.

import lustre/attribute as a
import lustre/element as el

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
pub fn view_fullscreen(
  children: List(el.Element(msg)),
  attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  let loader = view_default(children, attributes)

  layout.center_screen([layout.with_z_index(theme.StackXxl)], [
    loader,
  ])
}

pub fn view_default(
  children: List(el.Element(msg)),
  attributes: List(a.Attribute(msg)),
) {
  new_theme()
  |> theme.div(attributes, children)
}

//
// Private
//

/// **PAINT THEME DEFAULT**
///
/// - attributes: Mais atributos lustre p/ este loader
fn new_theme() {
  theme.new()
  |> theme.with_base_to_tokens(base_classes)
}

fn base_classes() {
  [#(const_class_spinner, True)]
  |> theme.Classes
  |> theme.token_to_list
}

/// Classes de estilo padrão do loader spinner
const const_class_spinner = "h-16 w-16 animate-spin rounded-full border-4 "
  <> "border-solid border-primary-500 border-t-transparent"
