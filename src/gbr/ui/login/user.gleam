////
//// Gleam UI user info super element.
////

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string

import lustre/attribute as a
import lustre/element
import lustre/element/html
import lustre/event

import gbr/ui/svg
import gbr/ui/svg/icons as svg_icons

import gbr/ui/core/model.{type UIRender, type UIRenders}

type User =
  UIUser

type Render(a) =
  UIUserRender(a)

type Profile =
  UIProfile

type Dropdown =
  UIDropdown

type Icon =
  Option(svg.Identity)

pub opaque type UIProfile {
  UIProfile(
    username: String,
    email: String,
    department: String,
    full_name: String,
    picture: String,
  )
}

pub type UIDropdown {
  UIDropdown(visible: Bool, menu_list: MenuList, button_list: ButtonList)
}

pub type Menu {
  Menu(label: String, href: String, icon: Icon)
}

pub type MenuList =
  List(Menu)

pub type Button {
  Button(id: String, label: String, icon: Icon)
}

pub type ButtonList =
  List(Button)

pub type UIUser {
  UIUser(profile: Profile, dropdown: Option(Dropdown))
}

pub opaque type UIUserRender(a) {
  UIUserRender(
    in: User,
    on_dropdown: Option(a),
    on_dropdown_leave: Option(a),
    on_submit: Option(fn(String) -> a),
  )
}

pub fn new(profile: Profile) -> User {
  UIUser(profile:, dropdown: None)
}

pub fn at(in: User) -> Render(a) {
  UIUserRender(in:, on_dropdown: None, on_dropdown_leave: None, on_submit: None)
}

pub fn on_submit(at: Render(a), onsubmit: fn(String) -> a) -> Render(a) {
  UIUserRender(..at, on_submit: Some(onsubmit))
}

pub fn on_dropdown(at: Render(a), ondropdown: a) {
  UIUserRender(..at, on_dropdown: Some(ondropdown))
}

pub fn on_dropdown_leave(at: Render(a), ondropdown: a) {
  UIUserRender(..at, on_dropdown: Some(ondropdown))
}

pub fn render(at: Render(a)) -> UIRender(a) {
  let UIUserRender(in:, on_submit:, on_dropdown:, on_dropdown_leave:) = at
  let UIUser(profile:, dropdown:) = in
  let UIProfile(username:, email:, department:, full_name:, picture:) = profile
  let #(user_arrow_toggle_class, user_dropdown_toggle_class) =
    option.map(dropdown, fn(dropdown) {
      let UIDropdown(visible:, ..) = dropdown

      case visible {
        True -> #("rotate-180", "block")
        False -> #("", "hidden")
      }
    })
    |> option.unwrap(#("", "hidden"))

  // let UIDropdown(visible:, menu_list:, button_list:) = dropdown

  let on_dropdown =
    option.map(on_dropdown, event.on_click)
    |> option.unwrap(a.none())
  let on_dropdown_leave =
    option.map(on_dropdown_leave, fn(a) {
      [event.on_click(a), event.on_mouse_leave(a)]
    })
    |> option.unwrap([a.none()])

  let dropdown = case dropdown {
    Some(UIDropdown(button_list:, menu_list:, ..)) -> [
      html.ul([a.class(user_dropdown_menugrp_class)], menu_list_(menu_list)),
      ..button_list_(on_submit, button_list)
    ]
    None -> [element.none()]
  }

  html.div(
    [
      a.class("relative"),
    ],
    [
      html.a(
        [
          a.class(user_profile_class),
          on_dropdown,
        ],
        [
          html.span([a.class(user_profile_picture_class)], [
            html.img([a.src(picture)]),
          ]),
          html.span([a.class(user_profile_username_class)], [
            html.text(username),
          ]),
          svg.new("login-user-icon-arrow", 20, 18)
            |> svg_icons.arrow()
            |> svg.classes([user_arrow_toggle_class, ..user_arrow_class])
            |> svg.render(),
        ],
      ),
      html.div(
        [
          a.class(user_dropdown_toggle_class),
          a.class(string.join(user_dropdown_class, " ")),
          ..on_dropdown_leave
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
          // dropdown
          ..dropdown
        ],
      ),
    ],
  )
}

pub fn profile(in: User, profile: Profile) {
  UIUser(..in, profile:)
}

pub fn dropdown(in: User, dropdown: Dropdown) {
  UIUser(..in, dropdown: Some(dropdown))
}

// PRIVATE
//

fn menu_list_(menu_list: MenuList) -> UIRenders(a) {
  use Menu(label:, href:, icon:) <- list.map(menu_list)

  let item = case icon {
    Some(identity) -> [
      svg.new("login-user-icon-menu", 24, 24)
        |> identity()
        |> svg.classes([user_menu_icon_class])
        |> svg.render(),
      html.text(label),
    ]
    None -> [html.text(label)]
  }

  html.li([], [
    html.a(
      [
        a.href(href),
        a.class(user_dropdown_menu_class),
      ],
      item,
    ),
  ])
}

fn button_list_(onsubmit, button_list: ButtonList) -> UIRenders(a) {
  use Button(id:, label:, icon:) <- list.map(button_list)

  let item = case icon {
    Some(identity) -> [
      svg.new("logo-user-icon-btn", 24, 24)
        |> identity()
        |> svg.classes([user_btn_icon_class])
        |> svg.render(),
      html.text(label),
    ]
    None -> [html.text(label)]
  }

  let on_click =
    option.map(onsubmit, fn(on) { event.on_click(on(id)) })
    |> option.unwrap(a.none())

  html.button([on_click, a.class(user_btn_class)], item)
}

const user_arrow_class = ["stroke-gray-500 dark:stroke-gray-400"]

const user_dropdown_class = [
  "shadow-theme-lg dark:bg-gray-dark absolute right-0 mt-[17px] flex w-[260px] flex-col rounded-2xl border border-gray-200 bg-white p-3 dark:border-gray-800",
]

const user_profile_class = "flex items-center text-gray-700 dark:text-gray-400 cursor-pointer"

const user_profile_picture_class = "mr-3 h-11 w-11 overflow-hidden rounded-full"

const user_profile_username_class = "text-theme-sm mr-1 block font-medium"

const user_dropdown_profile_class = "pb-2 border-b border-gray-200 dark:border-gray-800"

const user_btn_icon_class = "fill-gray-500 group-hover:fill-gray-700 dark:group-hover:fill-gray-300"

const user_menu_icon_class = "fill-gray-500 group-hover:fill-gray-700 dark:fill-gray-400 dark:group-hover:fill-gray-300"

const user_dropdown_menugrp_class = "flex flex-col gap-1 order-b order-gray-200 ark:border-gray-800 t-4 b-3"

const user_dropdown_menu_class = "group text-theme-sm flex items-center gap-3 rounded-lg px-3 py-2 font-medium text-gray-700 hover:bg-gray-100 hover:text-gray-700 dark:text-gray-400 dark:hover:bg-white/5 dark:hover:text-gray-300"

const user_dropdown_email_class = "text-theme-xs mt-0.5 block text-gray-500 dark:text-gray-400"

const user_dropdown_username_class = "text-theme-sm block ont-medium text-gray-700 dark:text-gray-400"

const user_btn_class = "group text-theme-sm mt-3 flex items-center gap-3 rounded-lg px-3 py-2 font-medium text-gray-700 hover:bg-gray-100 hover:text-gray-700 dark:text-gray-400 dark:hover:bg-white/5 dark:hover:text-gray-300"
