////
//// UI admin modal element.
////

import gbr/ui/modal
import gbr/ui/svg
import gbr/ui/svg/icons
import gbr/ui/typo

import gbr/ui/core/model.{type UIRenders}

type Modal =
  UIModal

type Render(a) =
  UIModalRender(a)

pub type UIModal =
  modal.UIModal

pub type UIModalRender(a) =
  modal.UIModalRender(a)

pub const new = modal.new

pub const open = modal.open

pub const toggle = modal.toggle

pub const class = modal.class

pub const class_slot = modal.class_slot

pub const render = modal.render

pub const render_slot = modal.render_slot

pub const view = modal.view

pub fn simple(
  modal: Modal,
  title: String,
  content: String,
  footer: UIRenders(a),
  onclose: a,
) -> Render(a) {
  let modal =
    modal
    |> modal.class(
      "fixed inset-0 flex items-center justify-center p-5 "
      <> "overflow-y-auto modal z-99999",
    )
    |> modal.class_slot(
      modal.Backdrop,
      "fixed inset-0 h-full w-full bg-gray-400/50 " <> "backdrop-blur-sm",
    )
    |> modal.class_slot(
      modal.Wrapper,
      "relative w-full max-w-[507px] rounded-3xl bg-white "
        <> "p-6 dark:bg-gray-900 lg:p-10 text-center",
    )
    |> modal.class_slot(
      modal.Content,
      "flex flex-col px-4 py-4 overflow-y-auto no-scrollbar",
    )
    |> modal.class_slot(
      modal.Footer,
      "flex items-center justify-center w-full gap-3 mt-8",
    )
    |> modal.class_slot(
      modal.Close,
      "absolute right-3 top-3 z-999 flex h-9.5 w-9.5 items-center justify-center "
        <> "rounded-full bg-gray-100 text-gray-400 transition-colors hover:bg-gray-200 "
        <> "hover:text-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:hover:bg-gray-700 "
        <> "dark:hover:text-white sm:right-6 sm:top-6 sm:h-11 sm:w-11",
    )

  let title =
    typo.h3(title)
    |> typo.class(
      "mb-2 text-2xl font-semibold text-gray-800 dark:text-white/90 sm:text-title-sm",
    )
  let content =
    typo.p(content)
    |> typo.class("text-sm leading-6 text-gray-500 dark:text-gray-400")

  modal.render(modal, onclose)
  |> modal.render_slot(modal.Content, [], [
    title |> typo.view(),
    content |> typo.view(),
  ])
  |> modal.render_slot(modal.Footer, [], footer)
  |> modal.render_slot(modal.Close, [], [
    svg.new(24, 24)
    |> icons.cross()
    |> svg.view(),
  ])
}
