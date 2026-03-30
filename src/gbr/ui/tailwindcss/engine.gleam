////
//// 🔩 ✨ UI lustre+tailwindcss theme module
////
//// Olá, aqui temos o módulo para trabalharmos com o nosso vocabulário de
//// componentes visuais.
////
//// Asseguramos matematicamente que nosso vocabulário seja traduzido adequadamente
//// para um [attributo Lustre](https://hexdocs.pm/lustre/lustre/attribute.html#classes) linguagem, sem termos efeitos colaterais
//// indesejados.

import lustre/attribute as a

import gbr/ui/theme/engine.{type UITheme}

// Alias
//

pub const new = engine.new

pub const with_size = engine.with_size

pub const with_shape = engine.with_shape

pub const with_elevation = engine.with_elevation

pub const with_stacking = engine.with_stacking

pub const with_cosmetics = engine.with_cosmetics

/// Converte o vocabulário em estilos visuais padronizados p/ um atributo
/// da biblioteca `lustre`, `attribute.classes(*)`.
pub fn resolve(theme: UITheme) -> a.Attribute(msg) {
  engine.resolve(theme)
  |> a.classes()
}
