////
//// UI tailwindcss hero layout module
////
//// TODO...
////

import lustre/attribute as a
import lustre/element as el
import lustre/element/html as h

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
pub fn view(
  left left: List(el.Element(msg)),
  right right: List(el.Element(msg)),
  inner inner: List(el.Element(msg)),
  with attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  h.div(
    [
      a.class("relative hidden h-full w-full items-center lg:grid"),
      ..attributes
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
