////
//// Gleam UI admin user super element.
////

import gleam/list
import gleam/option.{type Option, None, Some}

import lustre/attribute as a
import lustre/element
import lustre/element/html
import lustre/event

import gbr/ui/core/el
import gbr/ui/core/model.{type UIRender, type UIRenders}

import gbr/ui/svg
import gbr/ui/svg/icons as svg_icons

import gbr/ui/admin/user/dropdown.{type UIDropdown}

type User =
  UIUser

type Render(a) =
  UIUserRender(a)

type Profile =
  UIProfile

type Dropdown =
  UIDropdown

pub opaque type UIProfile {
  UIProfile(
    username: String,
    email: String,
    department: String,
    full_name: String,
    picture: String,
  )
}

pub opaque type UIUser {
  UIUser(el: el.UIEl, profile: Profile, dropdown: Option(Dropdown))
}

pub opaque type UIUserRender(a) {
  UIUserRender(
    in: User,
    on_dropdown: Option(a),
    on_submit: Option(fn(String) -> a),
  )
}

/// New user element
///
/// - id: html id
/// - username: Username
///
pub fn new(id: String, username: String) -> User {
  let el =
    el.new(id)
    |> el.class("relative")

  let profile =
    UIProfile(username:, email: "", department: "", full_name: "", picture: "")

  UIUser(el:, profile:, dropdown: None)
}

pub fn username(in: User, username: String) -> User {
  UIUser(..in, profile: UIProfile(..in.profile, username:))
}

pub fn email(in: User, email: String) -> User {
  UIUser(..in, profile: UIProfile(..in.profile, email:))
}

pub fn department(in: User, department: String) -> User {
  UIUser(..in, profile: UIProfile(..in.profile, department:))
}

pub fn name_full(in: User, full_name: String) -> User {
  UIUser(..in, profile: UIProfile(..in.profile, full_name:))
}

pub fn picture(in: User, picture: String) -> User {
  UIUser(..in, profile: UIProfile(..in.profile, picture:))
}

pub fn dropdown(in: User, dropdown: Dropdown) -> User {
  dropdown_opt(in, Some(dropdown))
}

pub fn dropdown_opt(in: User, dropdown: Option(Dropdown)) -> User {
  UIUser(..in, dropdown:)
}

pub fn toggle(in: User) -> User {
  let dropdown =
    in.dropdown
    |> option.map(dropdown.toggle)

  UIUser(..in, dropdown:)
}

pub fn render(in: User) -> Render(a) {
  UIUserRender(in:, on_dropdown: None, on_submit: None)
}

pub fn on_submit_opt(
  at: Render(a),
  on_submit: Option(fn(String) -> a),
) -> Render(a) {
  UIUserRender(..at, on_submit:)
}

pub fn on_submit(at: Render(a), onsubmit: fn(String) -> a) -> Render(a) {
  on_submit_opt(at, Some(onsubmit))
}

pub fn on_dropdown(at: Render(a), ondropdown: a) -> Render(a) {
  on_dropdown_opt(at, Some(ondropdown))
}

pub fn on_dropdown_opt(at: Render(a), on_dropdown: Option(a)) -> Render(a) {
  UIUserRender(..at, on_dropdown:)
}

pub fn view(at: Render(a)) -> UIRender(a) {
  let UIUserRender(in:, on_submit:, on_dropdown:) = at
  let UIUser(el:, profile:, dropdown:) = in
  let UIProfile(username:, email:, department:, full_name:, picture:) = profile
  let is_visible =
    option.map(dropdown, dropdown.is_visible)
    |> option.unwrap(False)

  let evt_dropdown = get_on_dropdown(on_dropdown)
  let evt_dropdown_click_out = get_on_dropdown(on_dropdown)
  let evt_dropdown_mouse_out = get_on_dropdown_mouse(on_dropdown)
  let attrs = el.attrs(el)

  html.div(attrs, [
    html.a(
      [
        a.class(user_profile_class),
        evt_dropdown,
      ],
      [
        html.span([], [
          html.img([a.src(picture), a.class(user_profile_picture_class)]),
        ]),
        html.span([a.class(user_profile_username_class)], [
          html.text(username),
        ]),
        svg.new(20, 20)
          |> svg.class(user_arrow_class)
          |> svg.classes([#("rotate-180", is_visible)])
          |> svg_icons.arrow_small()
          |> svg.view(),
      ],
    ),
    case dropdown, is_visible {
      Some(dropdown), True ->
        html.div(
          [
            a.class(user_dropdown_class),
            a.classes([#("block", is_visible), #("hidden", !is_visible)]),
            evt_dropdown_click_out,
            evt_dropdown_mouse_out,
          ],
          [
            html.div([a.class(user_dropdown_profile_class)], [
              html.div([a.class("inline-flex justify-between w-full")], [
                html.span([a.class(user_dropdown_username_class)], [
                  html.text(full_name),
                ]),
                html.span(
                  [
                    a.class(user_dropdown_username_class),
                    a.class("text-orange-400 dark:text-orange-700"),
                  ],
                  [
                    html.text(department),
                  ],
                ),
              ]),
              html.span([a.class(user_dropdown_email_class)], [
                html.text(email),
              ]),
            ]),
            html.ul(
              [a.class(user_dropdown_menugrp_class)],
              menu_list_(dropdown, on_submit)
                |> list.reverse(),
            ),
            ..button_list_(dropdown, on_submit)
            |> list.reverse()
          ],
        )
      _, _ -> element.none()
    },
  ])
}

// PRIVATE
//

fn menu_list_(dropdown: Dropdown, onsubmit) -> UIRenders(a) {
  use id, text, icon <- dropdown.in_menus(dropdown)

  let item = case icon {
    Some(identity) -> [
      svg.new(24, 24)
        |> identity()
        |> svg.class(user_menu_icon_class)
        |> svg.view(),
      html.text(text),
    ]
    None -> [html.text(text)]
  }

  html.li([a.id(id)], [
    html.a(
      [
        a.class(user_dropdown_menu_class),
        get_on_submit(id, onsubmit),
      ],
      item,
    ),
  ])
}

fn button_list_(dropdown: Dropdown, onsubmit) -> UIRenders(a) {
  use id, label, icon <- dropdown.in_buttons(dropdown)

  let item = case icon {
    Some(icon) -> [
      svg.new(24, 24)
        |> icon()
        |> svg.class(user_btn_icon_class)
        |> svg.view(),
      html.text(label),
    ]
    None -> [html.text(label)]
  }

  html.button(
    [
      a.class(user_btn_class),
      get_on_submit(id, onsubmit),
    ],
    item,
  )
}

fn get_on_dropdown(ondropdown) {
  case ondropdown {
    Some(ondropdown) -> event.on_click(ondropdown)
    None -> a.none()
  }
}

fn get_on_dropdown_mouse(ondropdown) {
  case ondropdown {
    Some(ondropdown) -> event.on_mouse_leave(ondropdown)
    None -> a.none()
  }
}

fn get_on_submit(id, onsubmit) {
  case onsubmit {
    Some(onsubmit) -> event.on_click(onsubmit(id))
    None -> a.none()
  }
}

const user_arrow_class = "stroke-gray-500 dark:stroke-gray-400"

const user_dropdown_class = "shadow-theme-lg dark:bg-gray-dark absolute right-0 mt-[17px] flex w-[260px] flex-col rounded-2xl border border-gray-200 bg-white p-3 dark:border-gray-800"

const user_profile_class = "flex items-center text-gray-700 dark:text-gray-400 cursor-pointer"

const user_profile_picture_class = "mr-3 h-11 w-11 overflow-hidden rounded-full"

const user_profile_username_class = "text-theme-sm mr-1 block font-medium"

const user_dropdown_profile_class = "pb-2 border-b border-gray-200 dark:border-gray-800"

const user_btn_icon_class = "fill-gray-500 group-hover:fill-gray-700 dark:group-hover:fill-gray-300"

const user_menu_icon_class = "fill-gray-500 group-hover:fill-gray-700 dark:fill-gray-400 dark:group-hover:fill-gray-300"

const user_dropdown_menugrp_class = "flex flex-col gap-1 border-b border-gray-200 dark:border-gray-800 t-4 b-3 cursor-pointer"

const user_dropdown_menu_class = "group text-theme-sm flex items-center gap-3 rounded-lg px-3 py-2 font-medium text-gray-700 hover:bg-gray-100 hover:text-gray-700 dark:text-gray-400 dark:hover:bg-white/5 dark:hover:text-gray-300"

const user_dropdown_email_class = "text-theme-xs mt-0.5 block text-gray-500 dark:text-gray-400"

const user_dropdown_username_class = "text-theme-sm block font-medium text-gray-700 dark:text-gray-400"

const user_btn_class = "group text-theme-sm mt-3 flex items-center gap-3 rounded-lg px-3 py-2 font-medium text-gray-700 hover:bg-gray-100 hover:text-gray-700 dark:text-gray-400 dark:hover:bg-white/5 dark:hover:text-gray-300"
