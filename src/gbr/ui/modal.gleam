////
//// UI Modal element.
////

import gbr/ui/core/el
import gbr/ui/core/render
import lustre/attribute as a
import lustre/element/html as h
import lustre/event

import gbr/ui/svg
import gbr/ui/svg/icons
import gbr/ui/typo

import gbr/ui/admin/button
import gbr/ui/admin/separator

import gbr/ui/core/model.{type UIRender}

// Alias
//

type Modal =
  UIModal

type Render(a) =
  UIModalRender(a)

type Typo =
  typo.UITypo

pub type UIModal {
  UIModal(el: el.UIEl, title: Typo, content: Typo, open: Bool)
}

pub type UIModalRender(a) {
  UIModalRender(in: Modal, render: render.UIElRender(a))
}

const const_modal_backdrop_id = "modal-backdrop"

const const_modal_wrapper_id = "modal-wrapper"

const const_modal_content_id = "modal-content"

const const_modal_close_id = "modal-close"

const const_modal_footer_id = "modal-footer"

///
///
pub fn new(id: String) -> Modal {
  let el =
    el.new(id)
    |> el.class(
      "fixed inset-0 flex items-center justify-center p-5 overflow-y-auto modal z-99999",
    )
    |> el.class_key(
      const_modal_backdrop_id,
      "fixed inset-0 h-full w-full bg-gray-400/50 backdrop-blur-sm",
    )
    |> el.class_key(
      const_modal_content_id,
      "flex flex-col px-4 py-4 overflow-y-auto no-scrollbar",
    )
    |> el.class_key(
      const_modal_wrapper_id,
      "relative w-full max-w-[507px] rounded-3xl bg-white p-6 dark:bg-gray-900 lg:p-10 text-center",
    )
    |> el.class_key(
      const_modal_close_id,
      "absolute right-3 top-3 z-999 flex h-9.5 w-9.5 items-center justify-center "
        <> "rounded-full bg-gray-100 text-gray-400 transition-colors hover:bg-gray-200 "
        <> "hover:text-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:hover:bg-gray-700 "
        <> "dark:hover:text-white sm:right-6 sm:top-6 sm:h-11 sm:w-11",
    )
    |> el.class_key(
      const_modal_footer_id,
      "flex items-center justify-center w-full gap-3 mt-8",
    )

  let title =
    typo.h3("")
    |> typo.class(
      "mb-2 text-2xl font-semibold text-gray-800 dark:text-white/90 sm:text-title-sm",
    )
  let content =
    typo.p("")
    |> typo.class("text-sm leading-6 text-gray-500 dark:text-gray-400")

  UIModal(el:, title:, content:, open: False)
}

pub fn title(in: Modal, title: String) {
  UIModal(..in, title: typo.text(in.title, title))
}

pub fn content(in: Modal, content: String) {
  UIModal(..in, content: typo.text(in.content, content))
}

pub fn open(in: Modal, open: Bool) -> Modal {
  UIModal(..in, open:)
}

pub fn render(in: Modal) -> Render(a) {
  let render = render.new(in.el)
  UIModalRender(in:, render:)
}

pub fn onclose(at: Render(a), onclose: a) -> Render(a) {
  let render =
    at.render
    |> render.attributes_key(const_modal_close_id, [
      event.on_click(onclose),
    ])

  UIModalRender(..at, render:)
}

///
///
pub fn view(at: Render(a)) -> UIRender(a) {
  let UIModalRender(in:, render:) = at
  let UIModal(title:, content:, open:, ..) = in

  let #(attrs, _) = render.views(render)
  let #(attrs_backdrop, inner_backdrop) =
    render.views_key(render, const_modal_backdrop_id)
  let #(attrs_wrapper, _) = render.views_key(render, const_modal_wrapper_id)
  let #(attrs_content, _) = render.views_key(render, const_modal_content_id)

  let #(attrs_close, _) =
    render
    |> render.views_key(const_modal_close_id)

  let #(attrs_footer, _) = render.views_key(render, const_modal_footer_id)

  // modal-el
  h.div([a.classes([#("hidden", !open)]), ..attrs], [
    h.div(attrs_backdrop, inner_backdrop),
    h.div(attrs_wrapper, [
      // close
      h.button(attrs_close, [
        svg.new(24, 24)
        |> icons.cross()
        |> svg.view(),
      ]),
      // modal-content
      h.div(attrs_content, [
        title
          |> typo.view(),
        content
          |> typo.view(),
        // footer controls
        h.div(attrs_footer, [
          button.new("del-cancelar")
            |> button.label("Cancelar")
            |> button.tertiary()
            |> button.render([])
            |> button.view(),
          button.new("del-confirmar")
            |> button.label("Confirmar")
            |> button.primary()
            |> button.class_append("text-red-800 dark:text-red-300")
            |> button.render([])
            |> button.view(),
        ]),
      ]),
    ]),
  ])
  // <button onclick="openModal('modal-delete')" class="px-4 py-2 bg-red-500 hover:bg-red-600 text-white rounded-lg transition-colors">
  //   Remover Item
  // </button>

  // <div id="modal-delete" class="fixed inset-0 z-[9999] hidden items-center justify-center overflow-y-auto bg-black/50 backdrop-blur-sm px-4 py-5">
  //   <div class="w-full max-w-[520px] rounded-2xl bg-white py-12 px-8 text-center shadow-2xl dark:bg-gray-800 md:py-15 md:px-17.5">

  //     <div class="mx-auto mb-6 flex h-20 w-20 items-center justify-center rounded-full bg-red-100 text-red-500 dark:bg-red-500/10">
  //       <svg class="fill-current" width="40" height="40" viewBox="0 0 20 20">
  //         <path d="M10 0C4.477 0 0 4.477 0 10s4.477 10 10 10 10-4.477 10-10S15.523 0 10 0zM11 15H9v-2h2v2zm0-4H9V5h2v6z"/>
  //       </svg>
  //     </div>

  //     <h3 class="pb-2 text-xl font-bold text-black dark:text-white sm:text-2xl">
  //       Confirmar Remoção
  //     </h3>
  //     <span class="mx-auto mb-6 inline-block h-1 w-22.5 rounded bg-red-500"></span>
  //     <p class="mb-10 font-medium text-gray-500 dark:text-gray-400">
  //       Tem certeza que deseja remover este item? Esta ação não pode ser desfeita e os dados serão perdidos permanentemente.
  //     </p>

  //     <div class="flex flex-wrap gap-4 justify-center">
  //       <button onclick="closeModal('modal-delete')" class="block w-full rounded-lg border border-gray-300 bg-white p-3 font-medium text-black transition hover:border-red-500 hover:bg-red-500 hover:text-white dark:border-gray-600 dark:bg-transparent dark:text-white sm:w-auto sm:px-10">
  //         Cancelar
  //       </button>
  //       <button id="confirm-delete" class="block w-full rounded-lg border border-red-500 bg-red-500 p-3 font-medium text-white transition hover:bg-opacity-90 sm:w-auto sm:px-10">
  //         Confirmar e Remover
  //       </button>
  //     </div>
  //   </div>
  // </div>
}
