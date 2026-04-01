////
//// UI tailwindcss button group module
////

import lustre/attribute as a
import lustre/element as el
import lustre/element/html as h

/// Cria um grupo de botões alinhados horizontalmente
pub fn horizontal(
  attributes: List(a.Attribute(msg)),
  buttons: List(el.Element(msg)),
) -> el.Element(msg) {
  // O segredo do Tailwind para grupos:
  // Usa flex e resolve as bordas e as sombras colidindo
  let base_classes = a.class("inline-flex rounded-md shadow-sm")

  h.div([base_classes, ..attributes], buttons)
}
