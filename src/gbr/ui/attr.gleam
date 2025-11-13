////
//// Gleam UI attributes type and functinos.
////

import gleam/list

import lustre/attribute as a

pub const id_prefix = "gbr-ui-"

/// Label is form by text and attributes.
///
pub type Label {
  Label(text: String, att: Attrs)
}

/// Attributes is list of two string tuple.
///
pub type Attrs =
  List(#(String, String))

/// Attributes exists any name.
///
pub fn attrs_any(att: Attrs, any_name: String) -> Bool {
  use #(name, _) <- list.any(att)

  name == any_name
}

/// Attributes remove name, please.
///
pub fn attrs_remove(att: Attrs, to_remove: String) -> Attrs {
  use #(name, _) <- list.filter(att)

  name == to_remove
}

/// Attributes map to list of `lustre/attribute.{type Attribute}`, please.
///
pub fn attrs_to_lustre(att: Attrs) -> List(a.Attribute(a)) {
  use #(name, value) <- list.map(att)

  a.attribute(name, value)
}
