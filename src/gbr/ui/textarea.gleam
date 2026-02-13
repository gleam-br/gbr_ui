////
//// UI supre textarea element
////

import gleam/bool
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/event

import lustre/element
import lustre/element/html

import gbr/ui/core/el
import gbr/ui/core/model
import gbr/ui/core/render
import gbr/ui/typo

// Alias
//

type Textarea =
  UITextarea

type Render(a) =
  UITextareaRender(a)

type Typo =
  typo.UITypo

/// The <textarea> HTML element represents a multi-line plain-text
/// editing control, useful when you want to allow users to enter a
/// sizeable amount of free-form.
///
pub opaque type UITextarea {
  UITextarea(el: el.UIEl, text: String, label: Option(Typo), msg: Option(Typo))
}

/// Render element type to textarea
///
pub opaque type UITextareaRender(a) {
  UITextareaRender(in: Textarea, render: render.UIElRender(a))
}

/// Create a new textarea element
///
/// - text: Content of textarea
///
pub fn new(id: String) {
  let el =
    el.new(id)
    |> el.att([#("type", "text"), #("name", id)])

  UITextarea(el:, text: "", label: None, msg: None)
}

/// Label for textarea is optional
///
/// - in: Textarea type element
/// - label: Text of label
///
pub fn label(in: Textarea, label: String) -> Textarea {
  let assert Some(id) = el.att_get(in.el, "id")
  let label =
    in.label
    |> option.map(typo.text(_, label))
    |> option.unwrap(typo.label(id, label))

  UITextarea(..in, label: Some(label))
}

/// Set value to textarea
///
/// - in: Textarea type instance.
/// - text: Text value to textarea.
///
pub fn value(in: Textarea, text: String) -> Textarea {
  let el = el.att(in.el, [#("value", text)])

  UITextarea(..in, el:, text:)
}

pub fn is_empty(in: Textarea) {
  el.att_get(in.el, "value")
  |> option.map(string.to_option)
  |> option.flatten()
  |> option.is_none()
}

/// Set message info to user.
///
/// - in: Textarea
/// - message: Text info user.
///
pub fn message(in: Textarea, message: String) -> Textarea {
  let msg =
    in.msg
    |> option.map(typo.text(_, message))
    |> option.unwrap(typo.p(message))

  UITextarea(..in, msg: Some(msg))
}

/// Specifies the visible height (number of lines)
/// of the text area.
///
pub fn rows(in: Textarea, rows: Int) -> Textarea {
  let el = el.att(in.el, [#("rows", int.to_string(rows))])

  UITextarea(..in, el:)
}

/// Specifies the visible width (number of characters per line)
/// of the text area.
///
pub fn cols(in: Textarea, cols: Int) -> Textarea {
  let el = el.att(in.el, [#("cols", int.to_string(cols))])

  UITextarea(..in, el:)
}

/// Specifies the name for the form data when submitted.
///
pub fn name(in: Textarea, name: String) -> Textarea {
  UITextarea(..in, el: el.att(in.el, [#("name", name)]))
}

/// Provides a short hint that describes the expected value of the text area.
///
pub fn placeholder(in: Textarea, placeholder: String) -> Textarea {
  UITextarea(..in, el: el.att(in.el, [#("placeholder", placeholder)]))
}

/// Specifies how the text is to be wrapped when submitted (soft or hard).
///
pub fn wrap(in: Textarea, wrap: String) -> Textarea {
  UITextarea(..in, el: el.att(in.el, [#("wrap", wrap)]))
}

/// Specifies the maximum number of characters allowed in the text area.
///
pub fn max_length(in: Textarea, max_length: Int) -> Textarea {
  UITextarea(
    ..in,
    el: el.att(in.el, [#("maxLength", int.to_string(max_length))]),
  )
}

/// A boolean attribute indicating that the user must fill out the text area
/// before the form can be submitted.
///
pub fn required(in: Textarea, required: Bool) -> Textarea {
  UITextarea(
    ..in,
    el: el.att(in.el, [
      #(
        "required",
        bool.to_string(required)
          |> string.lowercase(),
      ),
    ]),
  )
}

/// A boolean attribute indicating that the user cannot modify the value,
/// but can still focus on and select the text.
///
pub fn readonly(in: Textarea, readonly: Bool) -> Textarea {
  UITextarea(
    ..in,
    el: el.att(in.el, [
      #(
        "readonly",
        bool.to_string(readonly)
          |> string.lowercase(),
      ),
    ]),
  )
}

/// A boolean attribute indicating that the user cannot modify the value,
/// but can still focus on and select the text.
///
pub fn autofocus(in: Textarea, autofocus: Bool) -> Textarea {
  UITextarea(
    ..in,
    el: el.att(in.el, [
      #(
        "autofocus",
        bool.to_string(autofocus)
          |> string.lowercase(),
      ),
    ]),
  )
}

/// A boolean attribute indicating that the text area is completely
/// unusable and its value is not submitted with the form.
///
pub fn disabled(in: Textarea, disabled: Bool) -> Textarea {
  UITextarea(
    ..in,
    el: el.att(in.el, [
      #(
        "disabled",
        bool.to_string(disabled)
          |> string.lowercase(),
      ),
    ]),
  )
}

/// Apply class to container, div around label and textarea
///
pub fn class_container(in: Textarea, class: String) -> Textarea {
  let el = el.class_key(in.el, const_el_container, class)

  UITextarea(..in, el:)
}

/// Apply class to label if exists
///
pub fn class_label(in: Textarea, class: String) -> Textarea {
  let label =
    in.label
    |> option.map(typo.class(_, class))

  UITextarea(..in, label:)
}

/// Apply class to message if exists
///
pub fn class_message(in: Textarea, class: String) -> Textarea {
  let msg =
    in.msg
    |> option.map(typo.class(_, class))

  UITextarea(..in, msg:)
}

/// Apply class to message if exists
///
pub fn classes_message(in: Textarea, classes: model.UISwitches) -> Textarea {
  let msg =
    in.msg
    |> option.map(typo.classes(_, classes))

  UITextarea(..in, msg:)
}

/// Class to textarea
///
pub fn class(in: Textarea, class: String) {
  UITextarea(..in, el: el.class(in.el, class))
}

/// Classes to textarea
///
pub fn classes(in: Textarea, classes: model.UISwitches) {
  UITextarea(..in, el: el.classes(in.el, classes))
}

/// Styles to textarea
///
pub fn style(in: Textarea, style: model.UIProperties) {
  UITextarea(..in, el: el.style(in.el, style))
}

/// New textarea render element type
///
pub fn render(in: Textarea) -> Render(a) {
  UITextareaRender(in:, render: render.new(in.el))
}

/// Set on input event to textarea
///
pub fn oninput(at: Render(a), oninput: fn(String) -> a) -> Render(a) {
  let render =
    at.render
    |> render.attributes([event.on_input(oninput)])

  UITextareaRender(..at, render:)
}

/// Set on change event to textarea
///
pub fn onchange(at: Render(a), onchange: fn(String) -> a) -> Render(a) {
  let render =
    at.render
    |> render.attributes([event.on_change(onchange)])

  UITextareaRender(..at, render:)
}

/// Render textarea
///
pub fn view(at: Render(a)) -> model.UIRender(a) {
  let UITextareaRender(in:, render:) = at
  let UITextarea(text:, label:, msg:, ..) = in

  let label =
    label
    |> option.map(typo.view)
    |> option.unwrap(element.none())
  let msg =
    msg
    |> option.map(typo.view)
    |> option.unwrap(element.none())
  let #(attrs_container, _) = render.views_key(render, const_el_container)
  let #(attrs, _) = render.views(render)
  let views = render.elements_get(render)

  let views =
    [label, html.textarea(attrs, text), msg]
    |> list.append(views)

  html.div(attrs_container, views)
}

const const_el_container = "textarea-container"
