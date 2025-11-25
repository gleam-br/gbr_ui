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
import gleam/option.{type Option}

import lustre/attribute

import gbr/ui/core/model.{
  type UIAttrs, type UIProperties, type UIProperty, type UISwitches,
}

// Alias

type El =
  UIEl

type Attrs(a) =
  UIAttrs(a)

type Properties =
  UIProperties

type Switches =
  UISwitches

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
  dict.Dict(String, Switches)

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

pub fn id_get(el: El) -> String {
  el.id
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

/// Append list of attributes into already exists list of attributes
///
/// - el: Element info
/// - att: Properties to set in key
///
/// Uses id like key to set custom attributes to element.
///
/// - Equals att_key(el, el.id, value)
///
pub fn att_append(el: El, att: Properties) -> El {
  let att_el =
    dict.get(el.att, el.id)
    |> option.from_result()
    |> option.unwrap([])

  att_key(el, el.id, list.append(att_el, att))
}

/// Replace value in one attribute by name in list of attributes.
///
/// - el: Element info
/// - att: Property to set in attribute name
///
/// Uses id like key to set custom attributes to element.
///
/// - Equals att_key(el, el.id, value)
///
pub fn att_replace(el: El, att: UIProperty) -> El {
  let #(name, _) = att
  let att =
    dict.get(el.att, el.id)
    |> option.from_result()
    |> option.unwrap([])
    |> list.map(fn(att_el) {
      let #(name_el, _) = att_el
      // replace
      use <- bool.guard(name == name_el, att)
      // mantain
      att_el
    })

  att_key(el, el.id, att)
}

pub fn att_get_key(el: El, key: String, name: String) -> Option(String) {
  dict.get(el.att, key)
  |> option.from_result()
  |> option.unwrap([])
  |> list.find(fn(att_el) {
    let #(name_el, _) = att_el

    name == name_el
  })
  |> option.from_result()
  |> option.map(fn(found) { found.1 })
}

pub fn att_any(el: El, name: String) -> Bool {
  att_any_key(el, el.id, name)
}

pub fn att_any_key(el: El, key: String, name: String) -> Bool {
  dict.get(el.att, key)
  |> option.from_result()
  |> option.unwrap([])
  |> list.any(fn(att_el) {
    let #(name_el, _) = att_el

    name == name_el
  })
}

/// Replace class attribute element
///
/// - el: Element info
/// - key: Key identification
///
/// If needs toggle only one style class uses fn `gbr/core/el.classes_key`
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
pub fn classes_key(el: El, key: String, classes: Switches) -> El {
  let classes = dict.insert(el.classes, key, classes)

  UIEl(..el, classes:)
}

pub fn get_classes(el: El, name: String) -> Option(Bool) {
  get_classes_key(el, el.id, name)
}

pub fn get_classes_key(el: El, key: String, name: String) -> Option(Bool) {
  dict.get(el.classes, key)
  |> option.from_result()
  |> option.unwrap([])
  |> list.find(fn(classes_el) {
    let #(name_el, _) = classes_el

    name == name_el
  })
  |> option.from_result()
  |> option.map(fn(found) { found.1 })
}

/// Replace classes attribute element
///
/// Uses id like key to set classes attribute
///
/// - Equals classes_key(el, el.id, value)
///
pub fn classes(el: El, classes: Switches) -> El {
  classes_key(el, el.id, classes)
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
pub fn classes_replace_key(el: El, key: String, class: String, on: Bool) -> El {
  let classes =
    dict.get(el.classes, key)
    |> option.from_result()
    |> option.unwrap([])
    |> set_classes(class, on)

  classes_key(el, key, classes)
}

/// Switch class (on,off) attribute element
///
/// Uses id like key to set switch attribute
///
/// - Equals switch_key(el, el.id, value)
///
pub fn classes_replace(el: El, class: String, on: Bool) -> El {
  classes_replace_key(el, el.id, class, on)
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

/// Map list of classes switch class to state, if exists, else return classes
///
fn set_classes(classes, class, state) {
  // classes map only class to on
  use #(name, value) <- list.map(classes)
  // guard to switch class == name
  use <- bool.guard(class == name, #(name, state))
  // mantain
  #(name, value)
}

fn map_atts(att) {
  use #(name, value) <- list.map(att)

  attribute.attribute(name, value)
}

fn map_styles(styles) {
  use #(name, value) <- list.map(styles)

  attribute.style(name, value)
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
