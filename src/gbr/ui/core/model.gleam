////
//// Gleam UI core type and functinos.
////

import gleam/option.{type Option}

import lustre/attribute
import lustre/element

/// Render element of generic event `a`.
///
/// Wrapper to `lustre/element.Elment`
///
pub type UIRender(a) =
  element.Element(a)

/// List of attribute to render an element
///
/// Wrapper to `lustre/element.Element`
///
pub type UIAttrs(a) =
  List(attribute.Attribute(a))

/// List of `gbr/ui.{type UIRender}`.
///
pub type UIRenders(a) =
  List(UIRender(a))

/// Option `gbr/ui/core/model.UIRender`
///
pub type UIOptRender(a) =
  Option(UIRender(a))

/// List of option `gbr/ui/core/model.UIOptRender`.
///
pub type UIOptRenders(a) =
  List(UIOptRender(a))

/// Id keyed elements
///
/// To avoid conflict of element id into html.
///
/// Helper to `lustre/element/keyed`
///
pub type UIKeyed(a) =
  #(String, UIRender(a))

/// Alias html property `<tag name="value"`
///
pub type UIProperty =
  #(String, String)

/// Alias to list of property
///
pub type UIProperties =
  List(UIProperty)

/// Alias to switch by identification
///
/// This type is a helper to `lustre.attribute.classes`
///
pub type UISwitch =
  #(String, Bool)

///
///
pub type UISwitches =
  List(UISwitch)

// TODO:

/// Box layout of generic event `a`
///
pub type UIBox(a) {
  UIBox(
    title: UIRender(a),
    content: UIRender(a),
    footer: UIRender(a),
    attrs: UIAttrs(a),
  )
}

/// List of `gbr/ui/core/model.UIBox`
///
pub type UIBoxes(a) =
  List(UIBox(a))
