////
//// 🧑‍💻 Gleam UI input super element.
////

import gleam/dynamic/decode
import gleam/int
import gleam/option.{type Option, None, Some}

import lustre/attribute as a
import lustre/element
import lustre/element/html
import lustre/event

import gbr/ui/core/el
import gbr/ui/typo

import gbr/ui/core/model.{
  type UIAttrs, type UIProperties, type UIRender, type UIRenders,
}

type Input =
  UIInput

type Render(a) =
  UIInputRender(a)

type OnChange(a) =
  fn(String) -> a

type Text =
  typo.UITypo

type Attrs =
  UIProperties

/// Input super element.
///
pub opaque type UIInput {
  UIInput(el: el.UIEl, value: String, label: Option(Text), note: Option(Text))
}

/// Input super element.
///
pub opaque type UIInputRender(a) {
  UIInputRender(
    in: Input,
    inner: UIRenders(a),
    onclick: Option(a),
    onpaste: Option(a),
    oninput: Option(OnChange(a)),
    onchange: Option(OnChange(a)),
    onkeypress: Option(OnChange(a)),
  )
}

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

  UIInput(el:, value: "", label: None, note: None)
}

/// Set element class
///
pub fn class(in: Input, class: String) -> Input {
  let el = el.class(in.el, class)

  UIInput(..in, el:)
}

/// Set input value
///
pub fn value(in: Input, value: String) -> Input {
  UIInput(..in, value:)
}

pub fn label(in: Input, label: String) -> Input {
  let id = el.get_id(in.el)
  let label = typo.label(id, label)

  UIInput(..in, label: Some(label))
}

pub fn label_class(in: Input, class: String) -> Input {
  let label =
    in.label
    |> option.map(typo.class(_, class))

  UIInput(..in, label:)
}

pub fn note(in: Input, note: Text) -> Input {
  UIInput(..in, note: Some(note))
}

/// Append input class sr-only .
///
pub fn sr_only(in: Input) -> Input {
  attrs(in, [#("class", "sr-only")])
}

/// Set input name.
///
pub fn name(in: Input, name: String) -> Input {
  attrs(in, [#("name", name)])
}

/// Set input placeholder.
///
pub fn placeholder(in: Input, value: String) -> Input {
  attrs(in, [#("placeholder", value)])
}

/// Set input required.
///
pub fn required(in: Input, value: String) -> Input {
  attrs(in, [#("required", value)])
}

pub fn kind(in: Input, kind: String) -> Input {
  let el = el.att(in.el, [#("type", kind)])

  UIInput(..in, el:)
}

/// Set input length.
///
pub fn max(in: Input, value: Int) -> Input {
  length(in, "maxlength", value)
}

pub fn min(in: Input, value: Int) -> Input {
  length(in, "minlength", value)
}

pub fn size(in: Input, value: Int) -> Input {
  length(in, "size", value)
}

/// New input render at inner.
///
pub fn at(in: Input, attrs: UIAttrs(a), inner: UIRenders(a)) -> Render(a) {
  let inner = [html.span(attrs, inner)]

  UIInputRender(
    in:,
    inner:,
    onpaste: None,
    onkeypress: None,
    oninput: None,
    onclick: None,
    onchange: None,
  )
}

/// Set input render event onclick.
///
pub fn on_click(in: Render(a), onclick: a) -> Render(a) {
  on_click_opt(in, Some(onclick))
}

/// Set input render event onchange.
///
pub fn on_change(in: Render(a), onchange: fn(String) -> a) -> Render(a) {
  on_change_opt(in, Some(onchange))
}

/// Set input render event onclick.
///
pub fn on_paste(in: Render(a), onpaste: a) -> Render(a) {
  on_paste_opt(in, Some(onpaste))
}

/// Set input render event onclick.
///
pub fn on_input(in: Render(a), oninput: fn(String) -> a) -> Render(a) {
  on_input_opt(in, Some(oninput))
}

/// Set input render event onclick.
///
pub fn on_keypress(in: Render(a), onkeypress: fn(String) -> a) -> Render(a) {
  on_keypress_opt(in, Some(onkeypress))
}

pub fn on_click_opt(in: Render(a), onclick: Option(a)) -> Render(a) {
  UIInputRender(..in, onclick:)
}

pub fn on_change_opt(
  in: Render(a),
  onchange: Option(fn(String) -> a),
) -> Render(a) {
  UIInputRender(..in, onchange:)
}

pub fn on_paste_opt(in: Render(a), onpaste: Option(a)) -> Render(a) {
  UIInputRender(..in, onpaste:)
}

pub fn on_input_opt(
  in: Render(a),
  oninput: Option(fn(String) -> a),
) -> Render(a) {
  UIInputRender(..in, oninput:)
}

pub fn on_keypress_opt(
  in: Render(a),
  onkeypress: Option(fn(String) -> a),
) -> Render(a) {
  UIInputRender(..in, onkeypress:)
}

/// Render input super element to `lustre/element.{type Element}`.
///
pub fn render(at: Render(a)) -> UIRender(a) {
  let UIInputRender(
    in:,
    inner:,
    onclick:,
    oninput:,
    onchange:,
    onpaste:,
    onkeypress:,
  ) = at
  let UIInput(el:, label:, note:, ..) = in
  // events
  let onclick =
    option.map(onclick, event.on_click)
    |> option.unwrap(a.none())
  let oninput =
    option.map(oninput, event.on_input)
    |> option.unwrap(a.none())
  let onchange =
    option.map(onchange, event.on_change)
    |> option.unwrap(a.none())
  let onkeypress =
    option.map(onkeypress, event.on_keypress)
    |> option.unwrap(a.none())
  let onpaste =
    option.map(onpaste, fn(onpaste) {
      event.on("onpaste", decode.success(onpaste))
    })
    |> option.unwrap(a.none())
  // attrs
  let label = case label {
    Some(label) -> typo.render(label)
    None -> element.none()
  }
  let attrs = el.attrs(el)
  // input
  let input =
    html.input([onclick, oninput, onchange, onpaste, onkeypress, ..attrs])
  let input = case note, inner {
    None, [] -> html.div([], [input])
    None, inner -> html.div([a.class("relative")], [input, ..inner])
    Some(note), inner ->
      html.div([a.class("relative")], [input, typo.render(note), ..inner])
  }

  // label and input
  html.div([], [label, input])
}

// PRIVATE
//

fn attrs(in: Input, att: Attrs) -> Input {
  let el = el.att(in.el, att)

  UIInput(..in, el:)
}

fn length(in: Input, name: String, value: Int) -> Input {
  let el = el.att(in.el, [#(name, int.to_string(value))])

  UIInput(..in, el:)
}
