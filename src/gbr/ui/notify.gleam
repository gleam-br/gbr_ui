////
//// Gleam UI notification super element
////
//// btn-icon toggle dropdown
//// dropdown -> title - btn_close
//// items -> avatar -> desc -> footer
//// footer -> btn controles

import gbr/ui/core/el
import gleam/bool
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}

import lustre/attribute as a
import lustre/element
import lustre/element/html
import lustre/event

import gbr/ui/svg
import gbr/ui/svg/icons as svg_icons
import gbr/ui/typo.{type UITypo, type UITypos}
import gbr/ui/user/avatar

import gbr/ui/notify/item.{type UINotifyItem}

import gbr/ui/core/model.{type UIRender, type UIRenders}

type Notify =
  UINotify

type Render(a) =
  UINotifyRender(a)

type Item =
  UINotifyItem

type OnToggle(a) =
  fn(Bool) -> a

pub opaque type UINotify {
  UINotify(
    el: el.UIEl,
    title: String,
    footer: UITypos,
    open: Bool,
    items: List(Item),
  )
}

// btn togglt onclick
// title -> btn close onclick
// items -> avatar -> text -> footer onclick
// footer -> btn controle -> onclick

pub opaque type UINotifyRender(a) {
  UINotifyRender(in: Notify, ontoggle: Option(OnToggle(a)))
}

pub fn new(id: String) {
  UINotify(el: el.new(id), open: True, title: "", footer: [], items: [])
}

pub fn title(in: Notify, title: String) -> Notify {
  UINotify(..in, title:)
}

pub fn footer(in: Notify, footer: UITypo) -> Notify {
  UINotify(..in, footer: [footer, ..in.footer])
}

pub fn item(in: Notify, item: Item) {
  UINotify(..in, items: [item, ..in.items])
}

pub fn class(in: Notify, class: String) -> Notify {
  let el = el.class(in.el, class)

  UINotify(..in, el:)
}

pub fn class_button(in: Notify, class: String) -> Notify {
  let el = el.class_key(in.el, "button", class)

  UINotify(..in, el:)
}

pub fn class_content(in: Notify, class: String) -> Notify {
  let el = el.class_key(in.el, "content", class)

  UINotify(..in, el:)
}

pub fn class_title(in: Notify, class: String) -> Notify {
  let el = el.class_key(in.el, "title", class)

  UINotify(..in, el:)
}

pub fn class_title_text(in: Notify, class: String) -> Notify {
  let el = el.class_key(in.el, "title-text", class)

  UINotify(..in, el:)
}

pub fn class_close(in: Notify, class: String) -> Notify {
  let el = el.class_key(in.el, "button-close", class)

  UINotify(..in, el:)
}

pub fn class_items(in: Notify, class: String) -> Notify {
  let el = el.class_key(in.el, "items", class)

  UINotify(..in, el:)
}

pub fn class_item(in: Notify, class: String) -> Notify {
  let el = el.class_key(in.el, "item", class)

  UINotify(..in, el:)
}

pub fn class_item_desc(in: Notify, class: String) -> Notify {
  let el = el.class_key(in.el, "item-desc", class)

  UINotify(..in, el:)
}

pub fn class_item_footer(in: Notify, class: String) -> Notify {
  let el = el.class_key(in.el, "item-footer", class)

  UINotify(..in, el:)
}

pub fn class_footer(in: Notify, class: String) -> Notify {
  let el = el.class_key(in.el, "footer", class)

  UINotify(..in, el:)
}

// main -> [btn,dropdown]
// - btn - class
// - dropdown - class class_title class_title_text class_button_close
// class_list class_item el_avatar class_item_desc class_item_footer

pub fn toggle(in: Notify, close_force: Bool) -> Notify {
  case close_force {
    True -> open(in, False)
    False -> open(in, !in.open)
  }
}

pub fn open(in: Notify, open: Bool) -> Notify {
  UINotify(..in, open:)
}

pub fn at(in: Notify) -> Render(a) {
  UINotifyRender(in:, ontoggle: None)
}

pub fn ontoggle(in: Render(a), ontoggle: OnToggle(a)) {
  UINotifyRender(..in, ontoggle: Some(ontoggle))
}

pub fn ontoggle_opt(in: Render(a), ontoggle: Option(fn(Bool) -> a)) -> Render(a) {
  UINotifyRender(..in, ontoggle:)
}

pub fn render(at: Render(a)) -> UIRender(a) {
  let UINotifyRender(in:, ontoggle:) = at
  let UINotify(el:, title:, footer:, items:, open:) = in

  let attrs = el.attrs(el)
  let attrs_btn = el.attrs_key(el, "button")
  let attrs_title = el.attrs_key(el, "title")
  let attrs_title_text = el.attrs_key(el, "title-text")
  let attrs_btn_close = el.attrs_key(el, "button-close")
  let attrs_content = el.attrs_key(el, "footer")
  let attrs_footer = el.attrs_key(el, "footer")
  let attrs_items = el.attrs_key(el, "items")
  let attrs_item = el.attrs_key(el, "item")
  let attrs_item_desc = el.attrs_key(el, "item-desc")
  let attrs_item_footer = el.attrs_key(el, "item-footer")

  let #(onclick_btn, onclick_out, onmouse_out) =
    map_ontoggle(ontoggle)
    |> option.unwrap(#(a.none(), a.none(), a.none()))

  let notify_btn =
    html.button(
      [
        onclick_btn,
        // ADMIN
        //a.class(notification_class),
        ..attrs_btn
      ],
      [
        mark(list.length(items)),
        svg.new(20, 20)
          |> svg_icons.bell()
          |> svg.render(),
      ],
    )
  let notify_title =
    html.div(
      //a.class(notify_dropdown_title_class)
      attrs_title,
      [
        html.h5(
          //a.class(notify_dropdown_title_h_class)
          attrs_title_text,
          [
            html.text(title),
          ],
        ),
        html.button(
          [
            onclick_out,
            //a.class(notify_dropdown_title_close_class),
            ..attrs_btn_close
          ],
          [
            svg.new(24, 24)
            |> svg_icons.cross()
            |> svg.render(),
          ],
        ),
      ],
    )
  let notify_items =
    html.ul([a.class(notify_dropdown_list_class)], map_items(items))

  let notify_footer = case footer {
    [] -> element.none()
    footer ->
      html.a(
        [
          a.class(notify_dropdown_footer_class),
        ],
        [
          footer
          |> list.reverse()
          |> typo.inline(),
        ],
      )
  }

  let notify_content =
    html.div(
      [
        a.classes([#("hidden", !open), #("block", open)]),
        onclick_out,
        onmouse_out,
        //a.class(notify_dropdown_class),
        ..attrs_content
      ],
      [
        notify_title,
        notify_items,
        notify_footer,
      ],
    )

  html.div([a.class("relative"), ..attrs], [
    notify_btn,
    notify_content,
  ])
}

// PRIVATE
//

/// Map ontoggle to lustre events
///
/// - on_click: button to open/close
/// - on_click: Out of dropdown
/// - on_mouse_leave: Mouse leave dropdown
///
fn map_ontoggle(ontoggle) {
  use ontoggle <- option.map(ontoggle)

  #(
    event.on_click(ontoggle(False)),
    event.on_click(ontoggle(True)),
    event.on_mouse_leave(ontoggle(True)),
  )
}

fn map_items(items: List(Item)) -> UIRenders(a) {
  use <- bool.guard(list.is_empty(items), [
    typo.text("Não há items")
    |> typo.class(notify_dropdown_desc_class)
    |> typo.render(),
  ])

  use id, desc, footer, avatar <- item.in_items(items)
  let avatar = case avatar {
    Some(avatar) -> avatar.render(avatar)
    None -> element.none()
  }

  html.li([a.id(id)], [
    html.a(
      [
        // onclick
        //a.href(href),
        a.class(notify_dropdown_group_class),
      ],
      [
        // todo
        avatar,
        html.span([a.class("block")], [
          typo.styled(desc, notify_dropdown_desc_class),
          // TODO admin styled
          footer
            |> typo.styled(
              "flex items-center gap-2 text-gray-500 dark:text-gray-400",
            ),
        ]),
      ],
    ),
  ])
}

fn btn_notification(counter: Int, toggle_notification) {
  todo
}

fn mark(counter: Int) {
  let mark_toggle = case counter {
    c if c > 0 -> "flex"
    _ -> "hidden"
  }
  html.span([a.class(mark_toggle), a.class(mark_class)], [
    html.span([a.class(mark_animate_class)], []),
    html.span([a.class("mt-1 text-sm")], [
      html.text(int.to_string(counter)),
    ]),
  ])
}

const notification_class = "hover:text-dark-900 relative flex h-11 w-11 items-center justify-center rounded-full border border-gray-200 bg-white text-gray-500 transition-colors hover:bg-gray-100 hover:text-gray-700 dark:border-gray-800 dark:bg-gray-900 dark:text-gray-400 dark:hover:bg-gray-800 dark:hover:text-white"

const mark_class = "absolute top-0.5 right-0 z-1 h-2 w-2 rounded-full bg-orange-400"

const mark_animate_class = "absolute -z-1 inline-flex h-full w-full animate-ping rounded-full bg-orange-400 opacity-75"

const notify_dropdown_group_class = "flex gap-3 rounded-lg border-b border-gray-100 p-3 px-4.5 py-3 hover:bg-gray-100 dark:border-gray-800 dark:hover:bg-white/5"

const notify_dropdown_desc_class = "text-theme-sm mb-1.5 block text-gray-500 dark:text-gray-400"

const notify_dropdown_list_class = "custom-scrollbar flex h-auto flex-col overflow-y-auto"

const notify_dropdown_footer_class = "text-theme-sm shadow-theme-xs mt-3 flex justify-center rounded-lg border border-gray-300 bg-white p-3 font-medium text-gray-700 hover:bg-gray-50 hover:text-gray-800 dark:border-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:hover:bg-white/[0.03] dark:hover:text-gray-200"

const notify_dropdown_title_close_class = "text-gray-500 dark:text-gray-400"

const notify_dropdown_title_h_class = "text-lg font-semibold text-gray-800 dark:text-white/90"

const notify_dropdown_title_class = "mb-3 flex items-center justify-between border-b border-gray-100 pb-3 dark:border-gray-800"

const notify_dropdown_class = "shadow-theme-lg dark:bg-gray-dark absolute -right-[240px] mt-[17px] flex h-[480px] w-[350px] flex-col rounded-2xl border border-gray-200 bg-white p-3 sm:w-[361px] lg:right-0 dark:border-gray-800"
