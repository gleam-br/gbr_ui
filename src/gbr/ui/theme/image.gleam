////
//// GBR: UI Theme Image Module
////
//// Formatos como WebP e AVIF são recomendados, pois apresentam um desempenho
//// muito superior ao de PNG, JPEG e GIF, tanto para imagens estáticas quanto
//// imagens animadas.
////

import gleam/option.{type Option, None, Some}
import lustre/attribute as a

import gbr/ui/theme

/// Dados de controle da imagem
///
pub type UIImage {
  UIImage(src: String, alt: String, height: Option(Int), width: Option(Int))
}

/// Cria nova imagem contendo os atributos obrigatórios.
///
pub fn new(src, alt) {
  UIImage(src:, alt:, height: None, width: None)
}

/// Altera o caminho do path da imagem.
///
pub fn with_src(image, src) {
  UIImage(..image, src:)
}

/// Altera o texto alternativo da imagem, para a11y.
///
pub fn with_alt(image, alt) {
  UIImage(..image, alt:)
}

/// Altera o tamanho original da altura da imagem.
///
pub fn with_height(image, height) {
  UIImage(..image, height: Some(height))
}

/// Altera o tamanho original da largura da imagem.
///
pub fn with_width(image, width) {
  UIImage(..image, width: Some(width))
}

/// Visualiza a imagem com o tema passado.
///
pub fn view(image, theme, a) {
  let UIImage(src:, alt:, height:, width:) = image

  let height =
    height
    |> option.map(a.height)
    |> option.unwrap(a.none())
  let width =
    width
    |> option.map(a.width)
    |> option.unwrap(a.none())

  let attributes = [a.src(src), a.alt(alt), height, width, ..a]

  theme.img(theme, attributes)
}
