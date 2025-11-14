////
//// Gleam UI core type and functinos.
////

import gleam/int
import gleam/list
import gleam/option.{type Option}

import lustre/attribute as a
import lustre/element

/// UI render required element of generic event `a`.
///
/// Wrapper to `lustre/element.{type Elment}`
///
pub type UIRender(a) =
  element.Element(a)

/// List of `gbr/ui.{type UIRender}`.
///
pub type UIRenders(a) =
  List(UIRender(a))

/// List of `gbr/ui.{type UIRenderOpt}`.
///
pub type UIRenderOpts(a) =
  List(UIRenderOpt(a))

/// UI render option element of generic event `a`.
///
/// Option to `gbr/ui.{type UIRender}`
///
pub type UIRenderOpt(a) =
  Option(UIRender(a))

/// Attributes is list of two string tuple.
///
pub type UIAttrs =
  List(#(String, String))

/// Label is text and attributes.
///
pub type UILabel {
  UILabel(text: String, att: UIAttrs)
}

/// Desc is title and description.
///
pub type UIDesc {
  UIDesc(title: String, desc: String)
}

/// Link is href and title.
///
pub type UILink {
  UILink(href: String, title: String)
}

/// New super label element
///
pub fn uilabel(text text, att att) {
  UILabel(text:, att:)
}

/// New super label element
///
pub fn uidesc(title title, desc desc) {
  UIDesc(title:, desc:)
}

/// New super label element
///
pub fn uilink(href href, title title) {
  UILink(href:, title:)
}

/// To id random identification, avoid id conflicts.
///
pub fn to_id(id: String) -> String {
  let random =
    int.random(1_000_000_000)
    |> int.to_string()

  id_prefix <> random <> "-" <> id
}

/// Attributes exists any name.
///
pub fn attrs_any(att: UIAttrs, any_name: String) -> Bool {
  use #(name, _) <- list.any(att)

  name == any_name
}

/// Attributes remove name, please.
///
pub fn attrs_remove(att: UIAttrs, to_remove: String) -> UIAttrs {
  use #(name, _) <- list.filter(att)

  name == to_remove
}

/// Attributes map to list of `lustre/attribute.{type Attribute}`, please.
///
pub fn attrs_to_lustre(att: UIAttrs) -> List(a.Attribute(a)) {
  use #(name, value) <- list.map(att)

  a.attribute(name, value)
}

// PRIVATE
//

const id_prefix = "gbr-ui-"
