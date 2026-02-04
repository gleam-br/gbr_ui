////
////
////

import gleam/dict
import gleam/list
import gleam/option
import gleam/result

import gbr/ui/core/el
import gbr/ui/core/model

// Alias
//

type Attrs(a) =
  model.UIAttrs(a)

type Renders(a) =
  model.UIRenders(a)

type Attributes(a) =
  dict.Dict(String, Attrs(a))

type Elements(a) =
  dict.Dict(String, Renders(a))

/// UI render element type
///
pub opaque type UIElRender(a) {
  UIRender(el: el.UIEl, attributes: Attributes(a), elements: Elements(a))
}

/// New ui render element type
///
pub fn new(el: el.UIEl) -> UIElRender(a) {
  let id = el.get_id(el)
  let attributes =
    dict.new()
    |> dict.insert(id, [])
  let elements =
    dict.new()
    |> dict.insert(id, [])

  UIRender(el:, attributes:, elements:)
}

/// Append lustre attributes to render element
///
pub fn attributes(in: UIElRender(a), attributes: Attrs(a)) -> UIElRender(a) {
  let id = el.get_id(in.el)

  attributes_key(in, id, attributes)
}

/// Append lustre attributes to render element by key
///
pub fn attributes_key(
  in: UIElRender(a),
  key: String,
  att: Attrs(a),
) -> UIElRender(a) {
  let UIRender(attributes:, ..) = in
  let att_el =
    dict.get(attributes, key)
    |> option.from_result()
    |> option.unwrap([])
  let attributes = dict.insert(attributes, key, list.append(att_el, att))

  UIRender(..in, attributes:)
}

/// Append lustre elements to render element
///
pub fn elements(in: UIElRender(a), elements: Renders(a)) -> UIElRender(a) {
  let id = el.get_id(in.el)

  elements_key(in, id, elements)
}

/// Append lustre elements to render element by key
///
pub fn elements_key(
  in: UIElRender(a),
  key: String,
  att: Renders(a),
) -> UIElRender(a) {
  let UIRender(elements:, ..) = in
  let att_el =
    dict.get(elements, key)
    |> option.from_result()
    |> option.unwrap([])
  let elements = dict.insert(elements, key, list.append(att_el, att))

  UIRender(..in, elements:)
}

///
///
pub fn attrs(render: UIElRender(a)) -> Attrs(a) {
  attrs_key(render, el.get_id(render.el))
}

///
///
pub fn attrs_key(render: UIElRender(a), key: String) -> Attrs(a) {
  let UIRender(el:, attributes:, ..) = render
  let attrs = el.attrs_key(el, key)
  let render_attrs =
    dict.get(attributes, key)
    |> result.unwrap([])

  list.append(attrs, render_attrs)
}

///
///
pub fn views(render: UIElRender(a)) {
  views_key(render, el.get_id(render.el))
}

///
///
pub fn views_key(render: UIElRender(a), key: String) {
  dict.get(render.elements, key)
  |> result.unwrap([])
}
