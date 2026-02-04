////
//// 🧑‍💻 UI input element.
////
//// Element to controle user input types, like <input type="password" />, etc.
////
//// > 🕹️ Controled vs 🌪️ Uncontroled inputs
//// > https://github.com/lustre-labs/lustre/blob/main/pages/hints/controlled-vs-uncontrolled-inputs.md
////

import gleam/bool
import gleam/dynamic/decode
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}

import lustre/attribute as a
import lustre/element
import lustre/element/html
import lustre/event

import gbr/ui/core/el
import gbr/ui/core/render
import gbr/ui/svg
import gbr/ui/typo

import gbr/ui/core/model.{
  type UIAttrs, type UIProperties, type UIRender, type UIRenders,
}

// Alias
//

type Input =
  UIInput

type Render(a) =
  UIInputRender(a)

type Text =
  typo.UITypo

type Attrs =
  UIProperties

type OnChange(a) =
  fn(String) -> a

/// Input super element.
///
pub opaque type UIInput {
  UIInput(
    el: el.UIEl,
    label: Option(Text),
    note: Option(Text),
    svg: Option(svg.Svg),
  )
}

/// Input super element.
///
pub opaque type UIInputRender(a) {
  UIInputRender(in: Input, render: render.UIElRender(a))
}

// Constructors
//

/// New input type text super element.
///
pub fn text(id: String) -> Input {
  new(id, "text")
}

/// New input type email super element.
///
pub fn email(id: String) -> Input {
  new(id, "email")
}

/// New input type password super element.
///
pub fn password(id: String) -> Input {
  new(id, "password")
}

/// New input type checkbox super element.
///
pub fn checkbox(id: String) -> Input {
  new(id, "checkbox")
  |> sr_only()
}

/// New input super element.
///
pub fn new(id: String, kind: String) -> Input {
  let el =
    el.new(id)
    |> el.att([#("type", kind)])
    |> el.att([#("name", id)])

  UIInput(el:, label: None, note: None, svg: None)
}

// Accessors
//

/// Set element class
///
pub fn class(in: Input, class: String) -> Input {
  let el = el.class(in.el, class)

  UIInput(..in, el:)
}

/// Set element class
///
pub fn classes(in: Input, classes: model.UISwitches) -> Input {
  let el = el.classes(in.el, classes)

  UIInput(..in, el:)
}

/// Set input value
///
/// > 🕹️ Controled vs 🌪️ Uncontroled inputs
/// > https://github.com/lustre-labs/lustre/blob/main/pages/hints/controlled-vs-uncontrolled-inputs.md
///
pub fn value(in: Input, value: String) -> Input {
  att_set(in, [#("value", value)])
}

/// Set label to input control, <label for="{id}"/>.
///
pub fn label(in: Input, label: String) -> Input {
  let id = el.id_get(in.el)
  let label = typo.label(id, label)

  UIInput(..in, label: Some(label))
}

/// Set label class attribute.
///
/// - in: Input type instance.
/// - class: Class value attribute to label.
///
pub fn label_class(in: Input, class: String) -> Input {
  let label =
    in.label
    |> option.map(typo.class(_, class))

  UIInput(..in, label:)
}

/// Set footer note to input control, uses with input states.
///
/// - in: Input type instance.
/// - note: Input footer note, uses to info user about validations, etc.
///
pub fn note(in: Input, note: Text) -> Input {
  UIInput(..in, note: Some(note))
}

/// Append input class sr-only .
///
pub fn sr_only(in: Input) -> Input {
  att_set(in, [#("class", "sr-only")])
}

/// Set input name.
///
pub fn name(in: Input, name: String) -> Input {
  att_set(in, [#("name", name)])
}

/// Set input autocomplete.
///
pub fn autocomplete(in: Input, value: Bool) -> Input {
  att_set(in, [#("autocomplete", bool.to_string(value))])
}

/// Set input placeholder.
///
pub fn placeholder(in: Input, value: String) -> Input {
  att_set(in, [#("placeholder", value)])
}

/// Set input required.
///
pub fn required(in: Input, value: String) -> Input {
  att_set(in, [#("required", value)])
}

/// Set input type attribute.
///
pub fn kind(in: Input, kind: String) -> Input {
  att_set(in, [#("type", kind)])
}

/// Set input max length.
///
pub fn max(in: Input, value: Int) -> Input {
  length(in, "maxlength", value)
}

/// Set input min length.
///
pub fn min(in: Input, value: Int) -> Input {
  length(in, "minlength", value)
}

/// Set input length.
///
pub fn size(in: Input, value: Int) -> Input {
  length(in, "size", value)
}

const const_input_inner = "input-inner"

/// Set icon svg
///
pub fn inner_svg(in: Input, svg: svg.Svg) -> Input {
  UIInput(..in, svg: Some(svg))
}

/// Set icon svg class attribute.
///
pub fn inner_class(in: Input, class: String) -> Input {
  let el = el.class_key(in.el, const_input_inner, class)

  UIInput(..in, el:)
}

/// New input render at inner.
///
pub fn render(in: Input, attrs: UIAttrs(a), inner: UIRenders(a)) -> Render(a) {
  let inner =
    in.svg
    |> option.map(fn(svg) { [svg.view(svg), ..inner] })
    |> option.unwrap(inner)
  let attrs =
    el.attrs_key(in.el, const_input_inner)
    |> list.append(attrs)
  let render =
    render.new(in.el)
    |> render.elements(inner)
    |> render.elements_key(const_input_inner, inner)
    |> render.attributes_key(const_input_inner, attrs)

  UIInputRender(in:, render:)
}

/// Set input render event oninput via option.
///
/// > 🕹️ Controled vs 🌪️ Uncontroled inputs
/// > https://github.com/lustre-labs/lustre/blob/main/pages/hints/controlled-vs-uncontrolled-inputs.md
///
///
pub fn oninput(in: Render(a), oninput: Option(OnChange(a))) -> Render(a) {
  let render =
    in.render
    |> render.attributes_opt(oninput, fn(evt) { [event.on_input(evt)] })

  UIInputRender(..in, render:)
}

/// Set input render event onchange via option.
///
/// > 🕹️ Controled vs 🌪️ Uncontroled inputs
/// > https://github.com/lustre-labs/lustre/blob/main/pages/hints/controlled-vs-uncontrolled-inputs.md
///
pub fn onchange(in: Render(a), onchange: Option(OnChange(a))) -> Render(a) {
  let render =
    in.render
    |> render.attributes_opt(onchange, fn(evt) { [event.on_change(evt)] })

  UIInputRender(..in, render:)
}

/// Set input render event onpaste via option.
///
pub fn onpaste(in: Render(a), onpaste: Option(a)) -> Render(a) {
  let render =
    in.render
    |> render.attributes_opt(onpaste, fn(evt) {
      [event.on("onpaste", decode.success(evt))]
    })

  UIInputRender(..in, render:)
}

/// Set input render event onclick via option.
///
pub fn onclick(in: Render(a), onclick: Option(a)) -> Render(a) {
  let render =
    in.render
    |> render.attributes_opt(onclick, fn(evt) { [event.on_click(evt)] })

  UIInputRender(..in, render:)
}

/// Set input render event onkeypress via option.
///
pub fn onkeypress(in: Render(a), onkeypress: Option(OnChange(a))) -> Render(a) {
  let render =
    in.render
    |> render.attributes_opt(onkeypress, fn(evt) { [event.on_keypress(evt)] })

  UIInputRender(..in, render:)
}

/// Set event ontoggle on click into icon svg.
///
pub fn inner_onclick(at: Render(a), onclick) -> Render(a) {
  let render =
    at.render
    |> render.attributes_key_opt(const_input_inner, onclick, fn(evt) {
      [event.on_click(evt)]
    })

  UIInputRender(..at, render:)
}

/// Render input super element to `lustre/element.{type Element}`.
///
pub fn view(at: Render(a)) -> UIRender(a) {
  let UIInputRender(in:, ..) = at
  let UIInput(label:, note:, ..) = in

  let label = case label {
    Some(label) -> typo.view(label)
    None -> element.none()
  }
  // ignore inner elements by id, controlled by `const_input_inner`.
  let #(attrs, inner_) = render.views(at.render)
  let #(inner_attrs, inner) =
    at.render
    |> render.views_key(const_input_inner)
  let inner = case inner {
    [] -> []
    inner -> [html.span(inner_attrs, inner), ..inner_]
  }

  let input = html.input(attrs)
  // if has note or inner elements
  let input = case note, inner {
    None, [] -> html.div([], [input])
    None, inner -> html.div([a.class("relative")], [input, ..inner])
    Some(note), inner ->
      html.div([a.class("relative")], [input, typo.view(note), ..inner])
  }

  // label and input
  html.div([], [label, input])
}

// PRIVATE
//

fn att_set(in: Input, att: Attrs) -> Input {
  let el = el.att(in.el, att)

  UIInput(..in, el:)
}

fn length(in: Input, name: String, value: Int) -> Input {
  let el = el.att(in.el, [#(name, int.to_string(value))])

  UIInput(..in, el:)
}
