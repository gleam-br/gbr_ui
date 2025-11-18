////
//// Gleam UI notify item super element
////

import gleam/list
import gleam/option.{type Option, None}

import gbr/ui/typo.{type UITypos}
import gbr/ui/user/avatar.{type UIAvatar}

type Callback(a) =
  fn(String, UITypos, UITypos, Option(UIAvatar)) -> a

pub opaque type UINotifyItem {
  UINotifyItem(
    id: String,
    desc: UITypos,
    footer: UITypos,
    avatar: Option(UIAvatar),
  )
}

pub fn new(id: String) {
  UINotifyItem(id:, avatar: None, desc: [], footer: [])
}

pub fn in_items(in: List(UINotifyItem), callback: Callback(a)) -> List(a) {
  use item <- list.map(list.reverse(in))
  let UINotifyItem(id:, desc:, footer:, avatar:) = item

  callback(id, desc, footer, avatar)
}
