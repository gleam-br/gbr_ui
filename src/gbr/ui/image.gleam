////
//// ️🌄 UI core image module
////

import gleam/option.{type Option, None}

import lustre/attribute as a
import lustre/element as el
import lustre/element/html as h
import lustre/event as e

/// UI img: Tipo de imagem que iremos mostrar na tela.
///
/// - src: Localização da imagem.
/// - alt: Texto alternativo da imagem p/ a11y.
pub opaque type UIImage {
  UIImage(src: String, alt: Option(String))
}

/// Cria uma nova representação de imagem
///
/// - src: Localização da imagem (url)
pub fn new(src: String) -> UIImage {
  UIImage(src:, alt: None)
}

/// Inclui o texto alternativo p/ a imagem
///
pub fn with_alt(image: UIImage, alt: Option(String)) -> UIImage {
  UIImage(..image, alt:)
}

/// UI image view: Mostra um elemento de imagem na tela.
///
/// - src: Imagem que vamos mostrar na tela.
/// - alt: Option alternativa de texto.
/// - with: Lista de atributos da imagem.
@internal
pub fn to_element(
  image: UIImage,
  on_click: Option(msg),
  with attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  let UIImage(src:, alt:) = image

  let alt =
    alt
    |> option.map(a.alt)
    |> option.unwrap(a.none())
  let on_click =
    on_click
    |> option.map(e.on_click)
    |> option.unwrap(a.none())

  h.img([a.src(src), alt, on_click, ..attributes])
}
