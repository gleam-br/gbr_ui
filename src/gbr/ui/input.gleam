////
//// 🧑‍💻 Gleam UI input super element.
////

import gleam/dynamic/decode
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}

import lustre/attribute.{type Attribute} as a
import lustre/element.{type Element}
import lustre/element/html
import lustre/element/keyed
import lustre/event

import gbr/ui/core.{
  type UIAttrs, type UILabel, UILabel, attrs_any, attrs_remove, attrs_to_lustre,
  to_id, uilabel,
}
import gbr/ui/svg
import gbr/ui/svg/form as svg_form

type Label =
  UILabel

type Attrs =
  UIAttrs

/// Input size.
///
pub type InputSize {
  Max(Int)
  Min(Int)
  Size(Int)
}

/// Input state.
///
pub type InputState {
  Success(Label)
  Alert(Label)
  Error(Label)
}

/// Input super element.
///
pub opaque type Input {
  Input(
    id: String,
    kind: String,
    att: Attrs,
    relative: Bool,
    label: Option(Label),
    state: Option(InputState),
  )
}

/// Input super element.
///
pub opaque type InputRender(a) {
  InputRender(
    inner: List(Element(a)),
    onclick: Option(a),
    onpaste: Option(a),
    oninput: Option(fn(String) -> a),
    onkeypress: Option(fn(String) -> a),
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
}

/// New input super element.
///
pub fn new(id: String, kind: String) -> Input {
  Input(
    id: to_id(id),
    kind:,
    att: [],
    relative: False,
    label: None,
    state: None,
  )
}

/// New input state behavior.
///
pub fn new_state(state: InputState, text: String) -> InputState {
  case state {
    Success(_) ->
      Success(uilabel(text:, att: [#("class", state_success_label)]))
    Alert(_) -> Alert(uilabel(text:, att: [#("class", state_alert_label)]))
    Error(_) -> Error(uilabel(text:, att: [#("class", state_error_label)]))
  }
}

/// Set input label with text and attributes.
///
pub fn label(in: Input, text: String, att: Attrs) -> Input {
  Input(..in, label: Some(uilabel(text, att:)))
}

/// Set input attributes.
///
pub fn attrs(in: Input, att: Attrs) -> Input {
  Input(..in, att: list.append(in.att, att))
}

/// Set input relative.
///
pub fn relative(in: Input, relative: Bool) -> Input {
  Input(..in, relative:)
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

/// Set input value.
///
pub fn value(in: Input, value: String) -> Input {
  attrs(in, [#("value", value)])
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

/// Set input disabled.
///
pub fn disabled(in: Input, disabled: Bool) -> Input {
  case disabled {
    True -> attrs(in, [#("class", disabled_class), #("disabled", "true")])
    False -> Input(..in, att: attrs_remove(in.att, "disabled"))
  }
}

/// Set input length.
///
pub fn length(in: Input, length: InputSize) -> Input {
  let attr = case length {
    Min(value) -> #("minlength", int.to_string(value))
    Max(value) -> #("maxlength", int.to_string(value))
    Size(value) -> #("size", int.to_string(value))
  }

  attrs(in, [attr])
}

/// Set input state
///
pub fn state(in: Input, state: InputState) -> Input {
  let state_color_class = case state {
    Success(_) -> state_success_class
    Alert(_) -> state_alert_class
    Error(_) -> state_error_class
  }

  Input(..in, state: Some(state))
  |> attrs([#("class", state_class <> state_color_class)])
  |> relative(True)
}

/// Set primary behavior to input.
///
pub fn primary(in: Input) {
  attrs(in, [#("class", primary_class)])
}

/// Set search behavior to input.
///
pub fn search(in: Input) {
  attrs(in, [#("class", search_class)])
}

/// New input render at right inner.
///
pub fn at_right(
  attrs: List(Attribute(a)),
  inner: List(Element(a)),
) -> InputRender(a) {
  [a.class(class_right), ..attrs]
  |> at(inner)
}

/// New input render at left inner.
///
pub fn at_left(
  attrs: List(Attribute(a)),
  inner: List(Element(a)),
) -> InputRender(a) {
  [a.class(class_left), ..attrs]
  |> at(inner)
}

/// New input render at inner.
///
pub fn at(attrs: List(Attribute(a)), inner: List(Element(a))) -> InputRender(a) {
  let inner = [html.span(attrs, inner)]

  InputRender(
    inner:,
    onpaste: None,
    onkeypress: None,
    oninput: None,
    onclick: None,
  )
}

/// New input render at default behavior.
///
pub fn at_none() -> InputRender(a) {
  InputRender(
    inner: [],
    onpaste: None,
    onkeypress: None,
    oninput: None,
    onclick: None,
  )
}

/// Set input render event onclick.
///
pub fn onclick(in: InputRender(a), onclick: a) -> InputRender(a) {
  InputRender(..in, onclick: Some(onclick))
}

/// Render input super element to `lustre/element.{type Element}`.
///
pub fn render(in: Input, render: InputRender(a)) -> Element(a) {
  let Input(id, label:, att:, ..) = in
  let required = attrs_any(att, "required")
  let disabled = attrs_any(att, "disabled")
  let input = input_state(id, in, render)

  case label {
    None -> keyed.fragment(input)
    Some(label) ->
      keyed.fragment([label_render(id, label, required, disabled), ..input])
  }
}

// PRIVATE
//

const state_label_class = "text-theme-xs text-error-500 mt-1.5"

const state_icon_class = "absolute top-1/2 right-3.5:-translate-y-1/2"

const state_class = "dark:bg-dark-900 shadow-theme-xs w-full rounded-lg border bg-transparent px-4 py-2.5 pr-10 text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30"

const state_success_class = " border-green-300 focus:border-green-300 focus:ring-green-500/10 dark:border-green-700 dark:focus:border-green-800"

const state_alert_class = " border-yellow-300 focus:border-yellow-300 focus:ring-yellow-500/10 dark:border-yellow-700 dark:focus:border-yellow-800"

const state_error_class = " border-red-300 focus:border-red-300 focus:ring-red-500/10 dark:border-red-700 dark:focus:border-red-800"

const state_success_label = "text-xs text-green-600 mt-1.5"

const state_alert_label = "text-xs text-yellow-600 mt-1.5"

const state_error_label = "text-xs text-red-700 mt-1.5"

const disabled_class = "shadow-theme-xs focus:border-brand-300 focus:shadow-focus-ring dark:focus:border-brand-300 h-11 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 placeholder:text-gray-400 focus:outline-hidden disabled:border-gray-100 disabled:placeholder:text-gray-300 dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-gray-400 dark:disabled:border-gray-800 dark:disabled:placeholder:text-white/15"

const primary_class = "dark:bg-dark-900 h-11 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 shadow-theme-xs placeholder:text-gray-400 focus:border-brand-300 focus:outline-hidden focus:ring-3 focus:ring-brand-500/10 dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30 dark:focus:border-brand-800"

const search_class = "dark:bg-dark-900 shadow-theme-xs focus:border-brand-300 focus:ring-brand-500/10 dark:focus:border-brand-800 h-11 w-full rounded-lg border border-gray-200 bg-transparent py-2.5 pr-14 pl-12 text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden xl:w-[430px] dark:border-gray-800 dark:bg-gray-900 dark:bg-white/[0.03] dark:text-white/90 dark:placeholder:text-white/30"

const label_disabled_class = "mb-1.5 block text-sm font-medium text-gray-300 dark:text-white/15"

const label_class = "mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-400"

const class_right = "absolute z-30 text-gray-500 -translate-y-1/2 cursor-pointer right-4 top-1/2 dark:text-gray-400 inline-flex gap-1"

const class_left = "absolute top-1/2 left-0 flex h-11 -translate-y-1/2 items-center justify-center border-r border-gray-200 dark:border-gray-800 inline-flex gap-1 px-3"

fn input_state(id, in, render) {
  let Input(kind:, relative:, state:, att:, ..) = in
  let InputRender(inner:, ..) = render

  case state {
    Some(state) -> [
      input_render(id, kind, relative, att, state_svg(state), render),
      state_render(id, state),
    ]
    None -> [
      input_render(id, kind, relative, att, inner, render),
    ]
  }
}

fn input_render(id, kind, relative, att, inner, render) {
  let InputRender(onpaste:, onkeypress:, oninput:, onclick:, ..) = render
  let relative_class = case relative {
    True -> "relative"
    False -> ""
  }
  let attrs = [
    a.type_(kind),
    a.id(id),
    event_unwrap(onclick, event.on_click),
    event_unwrap_(onkeypress, event.on_keypress),
    event_unwrap_(oninput, event.on_input),
    event_unwrap(onpaste, fn(evt) { event.on("onpaste", decode.success(evt)) }),
    ..attrs_to_lustre(att)
  ]

  #(id, html.div([a.class(relative_class)], [html.input(attrs), ..inner]))
}

fn label_render(id, label, required, disabled) {
  let UILabel(text:, att:) = label
  let id_label = id <> "-label"
  let text = case required {
    True -> text <> " *"
    False -> text
  }
  let disabled = case disabled {
    False -> label_class
    True -> label_disabled_class
  }
  let attrs = [a.for(id), a.class(disabled), ..attrs_to_lustre(att)]

  #(id_label, html.label(attrs, [html.text(text)]))
}

fn state_render(id, state) {
  let #(text, att) = case state {
    Success(UILabel(text, att)) -> #(text, att)
    Alert(UILabel(text, att)) -> #(text, att)
    Error(UILabel(text, att)) -> #(text, att)
  }
  let attrs = [a.class(state_label_class), ..attrs_to_lustre(att)]
  let id_state = id <> "-state"

  #(id_state, html.p(attrs, [html.text(text)]))
}

fn state_svg(state) {
  let #(id, transform) = case state {
    Success(_) -> #("success", svg_form.success)
    Alert(_) -> #("alert", svg_form.alert)
    Error(_) -> #("error", svg_form.error)
  }

  [
    html.span([a.class(state_icon_class)], [
      svg.new("input-icon-state-" <> id, 16, 16)
      |> transform()
      |> svg.render(),
    ]),
  ]
}

fn event_unwrap_(
  evt: Option(fn(String) -> a),
  apply: fn(fn(String) -> a) -> a.Attribute(a),
) -> a.Attribute(a) {
  case evt {
    Some(evt) -> apply(evt)
    None -> a.none()
  }
}

fn event_unwrap(
  evt: Option(a),
  apply: fn(a) -> a.Attribute(a),
) -> a.Attribute(a) {
  case evt {
    Some(evt) -> apply(evt)
    None -> a.none()
  }
}
