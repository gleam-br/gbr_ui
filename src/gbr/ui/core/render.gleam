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

type Element(a) {
  Element(attributes: Attrs(a), elements: Renders(a))
}

type Elements(a) =
  dict.Dict(String, Element(a))

/// UI render element type
///
pub opaque type UIElRender(a) {
  UIRender(el: el.UIEl, elements: Elements(a))
}

/// New ui render element type
///
pub fn new(el: el.UIEl) -> UIElRender(a) {
  let id = el.id_get(el)
  let elements =
    dict.new()
    |> dict.insert(id, Element([], []))

  UIRender(el:, elements:)
}

/// Append lustre attributes to render element mapping optional param.
///
/// - at: Render type instance.
/// - opt: Option attribute or any value, this is map to function (f).
/// - f: Function to get attributes from value inside option (opt) param.
///
pub fn attributes_opt(at, opt, f: fn(a) -> Attrs(b)) -> UIElRender(b) {
  option.map(opt, fn(evt) { attributes(at, f(evt)) })
  |> option.unwrap(at)
}

/// Append lustre attributes to render element
///
pub fn attributes(in: UIElRender(a), attributes: Attrs(a)) -> UIElRender(a) {
  let id = el.id_get(in.el)

  attributes_key(in, id, attributes)
}

/// Append lustre attributes to render element by key
///
pub fn attributes_key(
  in: UIElRender(a),
  key: String,
  att: Attrs(a),
) -> UIElRender(a) {
  let UIRender(elements:, ..) = in
  let elements =
    dict.get(elements, key)
    |> result.map(fn(el) {
      let att_el = el.attributes
      let element = Element(..el, attributes: list.append(att_el, att))
      dict.insert(elements, key, element)
    })
    |> option.from_result()
    |> option.unwrap(elements)

  UIRender(..in, elements:)
}

/// Append lustre elements to render element
///
pub fn elements(in: UIElRender(a), elements: Renders(a)) -> UIElRender(a) {
  let id = el.id_get(in.el)

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
  let elements =
    dict.get(elements, key)
    |> result.map(fn(el) {
      let att_el = el.elements
      let element = Element(..el, elements: list.append(att_el, att))
      dict.insert(elements, key, element)
    })
    |> option.from_result()
    |> option.unwrap(elements)

  UIRender(..in, elements:)
}

pub fn elements_get(render: UIElRender(a)) -> Renders(a) {
  dict.get(render.elements, el.id_get(render.el))
  |> result.map(fn(el) { el.elements })
  |> result.unwrap([])
}

/// Return lustre attributes from render element
///
pub fn attrs(render: UIElRender(a)) -> Attrs(a) {
  attrs_key(render, el.id_get(render.el))
}

/// Return lustre attributes from render element
///
pub fn attrs_key(render: UIElRender(a), key: String) -> Attrs(a) {
  let UIRender(el:, elements:) = render
  let attrs = el.attrs_key(el, key)
  let render_attrs =
    dict.get(elements, key)
    |> result.map(fn(el) { el.attributes })
    |> result.unwrap([])

  list.append(attrs, render_attrs)
}

/// Return element views is a tuple of #(attributes, elements).
///
/// This can be use to view a `div`:
///
/// ```gleam
/// let #(attributes, elements) =
///   el.new("some_id")
///     |> el.att([#("example1", "value1")])
///     |> render.new()
///     |> render.elements([html.text("Inner div content")])
///     |> render.views()
///
/// html.div(attributes, elements)
/// ```
///
/// > The `el.UIEl` or `render.UIRender` not construct lustre views, only
/// > storage metadata element to another module witch use it convert to lustre.
///
pub fn views(render: UIElRender(a)) -> #(Attrs(a), Renders(a)) {
  views_key(render, el.id_get(render.el))
}

/// Return element views is a tuple of #(attributes, elements).
///
pub fn views_key(render: UIElRender(a), key: String) -> #(Attrs(a), Renders(a)) {
  dict.get(render.elements, key)
  |> result.map(fn(el) { #(el.attributes, el.elements) })
  |> result.unwrap(#([], []))
}
