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

import gleam/dict
import gleam/int
import gleam/list
import gleam/option.{type Option}

import lustre/attribute

import gbr/ui/core/model

// Alias

type El =
  UIEl

type Attrs(a) =
  model.UIAttrs(a)

type Properties =
  model.UIProperties

type Switches =
  model.UISwitches

type Classes =
  UIClasses

type Style =
  UIStyles

type Att =
  UIAtt

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

/// Element super ui.
///
/// - id: Equals `lustre/attribute.classes`
/// - classes: `lustre/attribute.classes`
/// - style: `lustre/attribute.style`
/// - att: `lustre/attribute.attribute`
///
pub opaque type UIEl {
  UIEl(id: String, classes: Classes, styles: Style, att: Att)
}

/// New element type
///
/// - id: `lustre/attribute.id`
///
/// Create dictonary and insert item with id element to represent
/// default custom attributes, classes, styles of element.
///
pub fn new(id: String) {
  let att =
    dict.new()
    |> dict.insert(id, [#("id", random_str(id))])
  let classes =
    dict.new()
    |> dict.insert(id, [])
  let styles =
    dict.new()
    |> dict.insert(id, [])

  UIEl(id:, att:, classes:, styles:)
}

/// Replace id element
///
/// - el: Element info
/// - id: `lustre.attribute.id`
///
pub fn id(el: El, id: String) -> El {
  UIEl(..el, id:)
}

/// Get identification from element
///
/// - el: Element info type
///
pub fn id_get(el: El) -> String {
  el.id
}

/// Append or update custom attribute of list.
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

/// Append or update custom attrubute of list by key slot.
///
/// - el: Element info
/// - key: Key identification
/// - att: Properties to set in key
///
pub fn att_key(el: El, key, att: Properties) -> El {
  // Get element attributes
  let att_el =
    dict.get(el.att, key)
    |> option.from_result()
    |> option.unwrap([])
    |> list.fold(att, fn(acc, att) {
      let #(key, value) = att
      list.key_set(acc, key, value)
    })

  // Update attributes by dict key slot
  UIEl(..el, att: dict.insert(el.att, key, att_el))
}

/// Get attribute element by name.
///
/// - el: Element info.
/// - name: Attribute name to find.
///
pub fn att_get(el: El, name: String) -> Option(String) {
  att_get_key(el, el.id, name)
}

/// Get attribute element by key and name.
///
/// - el: Element info.
/// - key: Element slot key.
/// - name: Attribute name to find in slot.
///
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

/// Return if exists any attribute this name.
///
/// - el: Element info.
/// - name: Attribute name to find.
///
pub fn att_any(el: El, name: String) -> Bool {
  att_any_key(el, el.id, name)
}

/// Return if exists any attribute by slot key with name equals.
///
/// - el: Element info.
/// - key: Element slot key.
/// - name: Attribute name to find in slot.
///
pub fn att_any_key(el: El, key: String, name: String) -> Bool {
  dict.get(el.att, key)
  |> option.from_result()
  |> option.unwrap([])
  |> list.any(fn(att_el) {
    let #(name_el, _) = att_el
    name == name_el
  })
}

/// Append if not exists or update class attribute element
///
/// - el: Element info.
/// - class: Attribute class.
///
/// Uses id like key to set class attribute
///
/// - Equals class_key(el, el.id, value)
///
pub fn class(el: El, class: String) -> El {
  class_key(el, el.id, class)
}

/// Append if not exists or update class attribute element
///
/// - el: Element info.
/// - key: Element slot key.
/// - class: Attribute class.
///
pub fn class_key(el: El, key: String, class: String) -> El {
  att_key(el, key, [#("class", class)])
}

/// Append if not exists or update classes attribute element
///
/// - el: Element info
/// - classes: Properties `lustre.attribute.classes`
///
/// Uses id like key to set classes attribute
///
/// - Equals classes_key(el, el.id, value)
///
pub fn classes(el: El, classes: Switches) -> El {
  classes_key(el, el.id, classes)
}

/// Append if not exists or update classes attribute element
///
/// - el: Element info
/// - key: Key identification
/// - classes: Properties `lustre.attribute.classes`
///
pub fn classes_key(el: El, key: String, classes: Switches) -> El {
  let el_classes =
    dict.get(el.classes, key)
    |> option.from_result()
    |> option.unwrap([])
    |> list.fold(classes, fn(acc, classes) {
      let #(key, value) = classes
      list.key_set(acc, key, value)
    })

  let classes = dict.insert(el.classes, key, el_classes)

  UIEl(..el, classes:)
}

/// Append style attribute element
///
/// - el: Element info
/// - key: Key identification
/// - styles: Properties `lustre.attribute.style`
///
pub fn style_key(el: El, key: String, styles: Properties) -> El {
  let el_styles =
    dict.get(el.styles, key)
    |> option.from_result()
    |> option.unwrap([])
    |> list.fold(styles, fn(acc, styles) {
      let #(key, value) = styles
      list.key_set(acc, key, value)
    })

  let styles = dict.insert(el.styles, key, el_styles)

  UIEl(..el, styles:)
}

/// Append style attribute element
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
  let UIEl(classes:, styles:, att:, ..) = el
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

  att
  |> list.append(styles)
  |> list.append([classes])
}

// PRIVATE
//

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

/// Prefix element id
///
const id_prefix = "gbr-ui-"

/// Id range random avoid conflict
///
const random_range = 1_000_000
