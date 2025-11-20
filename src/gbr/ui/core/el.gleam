////
//// Gleam UI super element
////
//// ## Motivation
////
//// The lustre elements contains the generic event type that difficult to work
//// with element in stateless mode.
////
//// So, the `gbr/ui/core/el` module has types and functions to work with
//// attributes and properties without needs to trait genenric event type.
////

import gleam/bool
import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import lustre/attribute

import gbr/ui/core/model.{type UIAttrs, type UIProperties, type UISwitchs}

// Alias

type El =
  UIEl

type Attrs(a) =
  UIAttrs(a)

type Properties =
  UIProperties

type Switchs =
  UISwitchs

type Classes =
  UIClasses

type Style =
  UIStyles

type Att =
  UIAtt

/// Element super ui.
///
/// - id: Equals `lustre/attribute.classes`
/// - class: Equals `lustre/attribute.class`
/// - classes: `lustre/attribute.classes`
///
pub opaque type UIEl {
  UIEl(id: String, class: UIClass, classes: Classes, styles: Style, att: Att)
}

/// Attributes of element with key
///
/// Attributes to avoid generic event type with tuple of two strings
///
/// - part.1: Attribute name
/// - part.2: Attribute value
///
/// > Will be convert to `lustre/attribute.attribute(name,value)`
///
pub type UIAtt =
  dict.Dict(String, Properties)

/// Attribute `lustre/attribute.class` with key
///
pub type UIClass =
  dict.Dict(String, String)

/// Attribute `lustre/attribute.classes` with key
///
/// Perfect to toggle (on, off) one or more class into element.
///
pub type UIClasses =
  dict.Dict(String, Switchs)

/// Attribute `lustre/attribute.style` with key
///
/// Perfect to toggle (on, off) one or more class into element.
///
pub type UIStyles =
  dict.Dict(String, Properties)

/// New super element with initial class styled
///
/// - id: `lustre/attribute.id`
///
/// Create dictonary and insert item with id element to represent
/// default custom attributes, classes, styles, etc of element.
///
pub fn new(id: String) {
  let att =
    dict.new()
    |> dict.insert(id, [])
  let class =
    dict.new()
    |> dict.insert(id, "")
  let classes =
    dict.new()
    |> dict.insert(id, [])
  let styles =
    dict.new()
    |> dict.insert(id, [])

  UIEl(id: random_str(id), att:, class:, classes:, styles:)
}

/// Replace id element
///
/// - el: Element info
/// - id: `lustre.attribute.id`
///
pub fn id(el: El, id: String) -> El {
  UIEl(..el, id:)
}

/// Replace custom attributes
///
/// - el: Element info
/// - key: Key identification
/// - att: Properties to set in key
///
pub fn att_key(el: El, key, att: Properties) -> El {
  let att = dict.insert(el.att, key, att)

  UIEl(..el, att:)
}

/// Replace custom attributes by id equals key
///
/// - el: Element info
/// - att: Properties to set in key
///
/// Uses id like key to set custom attributes to element.
///
/// - Equals att_key(el, el.id, value)
///
pub fn att(el: El, att: Properties) -> El {
  att_key(el, el.id, att)
}

/// Replace class attribute element
///
/// - el: Element info
/// - key: Key identification
///
pub fn class_key(el: El, key: String, class: String) -> El {
  let class = dict.insert(el.class, key, class)

  UIEl(..el, class:)
}

/// Replace class attribute element
///
/// Uses id like key to set class attribute
///
/// - Equals class_key(el, el.id, value)
///
pub fn class(el: El, class: String) -> El {
  class_key(el, el.id, class)
}

/// Replace classes attribute element
///
/// - el: Element info
/// - key: Key identification
/// - classes: Properties `lustre.attribute.classes`
///
pub fn classes_key(el: El, key: String, classes: Switchs) -> El {
  let classes = dict.insert(el.classes, key, classes)

  UIEl(..el, classes:)
}

/// Replace classes attribute element
///
/// Uses id like key to set classes attribute
///
/// - Equals classes_key(el, el.id, value)
///
pub fn classes(el: El, classes: Switchs) -> El {
  classes_key(el, el.id, classes)
}

/// Replace style attribute element
///
/// - el: Element info
/// - key: Key identification
/// - styles: Properties `lustre.attribute.style`
///
pub fn style_key(el: El, key: String, styles: Properties) -> El {
  let styles = dict.insert(el.styles, key, styles)

  UIEl(..el, styles:)
}

/// Replace style attribute element
///
/// Uses id like key to set style attribute
///
/// - Equals style_key(el, el.id, value)
///
pub fn style(el: El, styles: Properties) -> El {
  style_key(el, el.id, styles)
}

/// Switch class (on,off) attribute element
///
/// If class exists, remove it, else add it.
///
/// - el: Element info
/// - key: Key identification
/// - class: To switch ON or OFF
/// - on: Is class ON, add it into element, or not, remove it.
///
/// Result:
/// - Element with class switched, if exists, else return same el.
///
pub fn switch_key(el: El, key: String, class: String, on: Bool) -> El {
  // has key?
  let has_key = dict.has_key(el.classes, key)

  use <- bool.guard(!has_key, el)

  // ok has key
  let assert Ok(classes) = dict.get(el.classes, key)

  let classes =
    map_classes(classes, class, on)
    |> dict.insert(el.classes, key, _)

  UIEl(..el, classes:)
}

/// Switch class (on,off) attribute element
///
/// Uses id like key to set switch attribute
///
/// - Equals switch_key(el, el.id, value)
///
pub fn switch(el: El, class: String, on: Bool) -> El {
  switch_key(el, el.id, class, on)
}

/// Convert to `lustre/attribute`s attributes by identification.
///
/// - in: Element info to convert
///
/// Precedence order attributes:
/// - id
/// - class
/// - classes
/// - style
/// - others in `att`
///
pub fn attrs(el: El) -> Attrs(a) {
  attrs_key(el, el.id)
}

pub fn attrs_key(el: El, key: String) -> Attrs(a) {
  let UIEl(id:, class:, classes:, styles:, att:) = el

  let id = attribute.id(id)
  let class =
    dict.get(class, key)
    |> option.from_result()
    |> option.map(attribute.class)
    |> option.unwrap(attribute.none())
  let classes =
    dict.get(classes, key)
    |> option.from_result()
    |> option.map(attribute.classes)
    |> option.unwrap(attribute.none())
  let styles =
    dict.get(styles, key)
    |> option.from_result()
    |> option.map(map_styles)
    |> option.unwrap([])
  let att =
    dict.get(att, key)
    |> option.from_result()
    |> option.map(map_atts)
    |> option.unwrap([])

  let attrs = list.append(styles, att)

  [id, class, classes, ..attrs]
}

// PRIVATE
//

fn map_styles(styles) {
  use #(name, value) <- list.map(styles)

  attribute.style(name, value)
}

/// Map list of classes switch class to state, if exists, else return classes
///
fn map_classes(classes, class, state) {
  // classes map only class to on
  use #(name, value) <- list.map(classes)
  // guard to switch class == name
  use <- bool.guard(class != name, #(name, value))

  #(name, state)
}

fn map_atts(att) {
  use #(name, value) <- list.map(att)

  attribute.attribute(name, value)
}

/// Random identification, avoid conflict.
///
fn random_str(id: String) -> String {
  let random =
    int.random(random_range)
    |> int.to_string()

  id_prefix <> random <> "-" <> id
}

const id_prefix = "gbr-ui-"

const random_range = 1_000_000
