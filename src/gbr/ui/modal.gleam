////
//// UI Modal element.
////

import lustre/attribute as a
import lustre/element as e
import lustre/element/html as h
import lustre/event

import gbr/ui/core/el
import gbr/ui/core/render

import gbr/ui/core/model.{type UIRender}

// Alias
//

type Modal =
  UIModal

type Render(a) =
  UIModalRender(a)

pub type UIModal {
  UIModal(el: el.UIEl, open: Bool)
}

pub type UIModalRender(a) {
  UIModalRender(in: Modal, render: render.UIElRender(a))
}

pub type UIModalSlot {
  Backdrop
  Wrapper
  Content
  Close
  Footer
}

const const_modal_backdrop_id = "modal-backdrop"

const const_modal_wrapper_id = "modal-wrapper"

const const_modal_content_id = "modal-content"

const const_modal_close_id = "modal-close"

const const_modal_footer_id = "modal-footer"

fn slot_to_string(slot) {
  case slot {
    Backdrop -> const_modal_backdrop_id
    Wrapper -> const_modal_wrapper_id
    Content -> const_modal_content_id
    Close -> const_modal_close_id
    Footer -> const_modal_footer_id
  }
}

///
///
pub fn new(id: String) -> Modal {
  let el = el.new(id)

  UIModal(el:, open: False)
}

/// Set modal class attribute.
///
pub fn class(in: Modal, class: String) -> Modal {
  UIModal(..in, el: el.class(in.el, class))
}

/// Set modal slot class attribute.
///
pub fn class_slot(in: Modal, slot: UIModalSlot, class: String) -> Modal {
  let el =
    slot_to_string(slot)
    |> el.class_key(in.el, _, class)

  UIModal(..in, el:)
}

/// Toggle modal open/close.
///
pub fn toggle(in: Modal) -> Modal {
  UIModal(..in, open: !in.open)
}

pub fn open(in: Modal, open: Bool) -> Modal {
  UIModal(..in, open:)
}

pub fn render(in: Modal, onclose: a) -> Render(a) {
  let render =
    render.new(in.el)
    |> render.attributes_key(const_modal_close_id, [
      event.on_click(onclose),
    ])

  UIModalRender(in:, render:)
}

pub fn render_slot(
  at: Render(a),
  slot: UIModalSlot,
  attributes,
  elements,
) -> Render(a) {
  let slot = slot_to_string(slot)
  let render =
    at.render
    |> render.attributes_key(slot, attributes)
    |> render.elements_key(slot, elements)

  UIModalRender(..at, render:)
}

///
///
pub fn view(at: Render(a)) -> UIRender(a) {
  let UIModalRender(in:, render:) = at
  let UIModal(open:, ..) = in

  let #(attrs, _) = render.views(render)
  let #(attrs_backdrop, inner_backdrop) =
    render.views_key(render, const_modal_backdrop_id)
  let #(attrs_wrapper, _) = render.views_key(render, const_modal_wrapper_id)
  let #(attrs_content, inner_content) =
    render.views_key(render, const_modal_content_id)

  let #(attrs_close, inner_close) =
    render
    |> render.views_key(const_modal_close_id)

  let #(attrs_footer, inner_footer) =
    render.views_key(render, const_modal_footer_id)

  // modal-el
  h.div([a.classes([#("hidden", !open)]), ..attrs], [
    h.div(attrs_backdrop, inner_backdrop),
    h.div(attrs_wrapper, [
      // close
      case inner_close {
        [] -> e.none()
        inner_close -> h.button(attrs_close, inner_close)
      },
      // modal-content
      h.div(attrs_content, [
        h.div([], inner_content),
        case inner_footer {
          [] -> e.none()
          inner_footer -> h.div(attrs_footer, inner_footer)
        },
      ]),
    ]),
  ])
}
