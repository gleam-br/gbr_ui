////
//// Gleam UI notification super element
////

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

import gbr/ui/core/model.{type UIRender, type UIRenders, to_id}

type Notify =
  UINotify

type Render(a) =
  UINotifyRender(a)

type Item =
  UINotifyItem

pub opaque type UINotify {
  UINotify(
    id: String,
    title: UITypos,
    footer: UITypos,
    visible: Bool,
    items: List(Item),
  )
}

pub opaque type UINotifyRender(a) {
  // fn(Bool) if force toggle or not
  UINotifyRender(in: Notify, on_toggle: Option(fn(Bool) -> a))
}

pub fn new(id: String, visible: Bool) {
  UINotify(id:, visible:, title: [], footer: [], items: [])
}

pub fn toggle_visible(in: Notify, force: Bool) -> Notify {
  case force {
    True -> UINotify(..in, visible: False)
    False -> UINotify(..in, visible: !in.visible)
  }
}

pub fn at(in: Notify) -> Render(a) {
  UINotifyRender(in:, on_toggle: None)
}

pub fn on_toggle_opt(
  in: Render(a),
  on_toggle: Option(fn(Bool) -> a),
) -> Render(a) {
  UINotifyRender(..in, on_toggle:)
}

pub fn title(in: Notify, title: UITypo) -> Notify {
  UINotify(..in, title: [title, ..in.title])
}

pub fn footer(in: Notify, footer: UITypo) -> Notify {
  UINotify(..in, footer: [footer, ..in.footer])
}

pub fn item(in: Notify, item: Item) {
  UINotify(..in, items: [item, ..in.items])
}

pub fn render(at: Render(a)) -> UIRender(a) {
  let UINotifyRender(in:, on_toggle:) = at
  let UINotify(id:, title:, footer:, items:, visible:) = in
  let dropdown_visible_class = case visible {
    True -> "block"
    False -> "hidden"
  }

  let #(on_notify, on_click_out, on_mouse_out) = case on_toggle {
    Some(on_toggle) -> #(
      event.on_click(on_toggle(False)),
      event.on_click(on_toggle(True)),
      event.on_mouse_leave(on_toggle(True)),
    )
    None -> #(a.none(), a.none(), a.none())
  }

  html.div([a.id(to_id(id)), a.class("relative")], [
    btn_notification(list.length(items), on_notify),
    html.div(
      [
        a.class(dropdown_visible_class),
        a.class(notify_dropdown_class),
        on_click_out,
        on_mouse_out,
      ],
      [
        html.div([a.class(notify_dropdown_title_class)], [
          // TODO: add func text.h5()
          html.h5([a.class(notify_dropdown_title_h_class)], [
            typo.inline(title),
          ]),
          html.button(
            [
              a.class(notify_dropdown_title_close_class),
              on_click_out,
            ],
            [
              svg.new("notify-icon-cross", 24, 24)
              |> svg_icons.cross()
              |> svg.render(),
            ],
          ),
        ]),
        html.ul([a.class(notify_dropdown_list_class)], items_(items)),
        footer_(id, footer),
      ],
    ),
  ])
}

// PRIVATE
//

fn footer_(id, footer) {
  use <- bool.guard(list.is_empty(footer), html.text(""))

  html.a(
    [
      a.id(id),
      a.class(notify_dropdown_footer_class),
    ],
    [
      footer
      |> list.reverse()
      |> typo.inline(),
    ],
  )
}

fn items_(items: List(Item)) -> UIRenders(a) {
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

  html.li([a.id(to_id(id))], [
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
          typo.horizontal(footer),
        ]),
      ],
    ),
  ])
}

fn btn_notification(counter: Int, toggle_notification) {
  html.button(
    [
      toggle_notification,
      a.class(notification_class),
    ],
    [
      mark(counter),
      svg.new("notify-btn-icon-bell", 20, 20)
        |> svg_icons.bell()
        |> svg.render(),
    ],
  )
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
