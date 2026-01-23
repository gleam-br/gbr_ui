////
//// 🔍 Gleam UI input search super element.
////
//// ```gleam
//// import gbr/ui/input/search
////
//// type Event {
////   MySearch(term: String)
//// }
////
//// fn update(model, msg) {
////   case msg {
////     MySearch(term) -> term
////   }
//// }
////
//// fn view(model: String) {
////   search.new()
////     |> search.term(model)
////     |> search.onsubmit(MySearch(msg))
////     |> search()
//// }
//// ```
////

import gbr/ui/svg/icons
import lustre/attribute as a
import lustre/element/html
import lustre/event

import gbr/ui/form
import gbr/ui/input
import gbr/ui/svg
import gbr/ui/svg/form as svg_form

import gbr/ui/core/model.{type UIProperties, type UIRender}

type Search =
  UISearch

type Render(a) =
  UISearchRender(a)

type Input =
  input.UIInput

type InputRender(a) =
  input.UIInputRender(a)

type OnSubmit(a) =
  fn(UIProperties) -> a

pub opaque type UISearch {
  UISearch(el: Input)
}

pub opaque type UISearchRender(a) {
  UISearchRender(in: InputRender(a), onsubmit: OnSubmit(a))
}

pub fn new(id: String) -> Search {
  let el =
    input.text(id)
    |> input.class(search_input_class)

  UISearch(el:)
}

pub fn value(in: Search, value: String) -> Search {
  let el = input.value(in.el, value)

  UISearch(el:)
}

pub fn render(in: Search, onsubmit: OnSubmit(a)) -> Render(a) {
  let in = input.render(in.el, [], [])

  UISearchRender(in:, onsubmit:)
}

pub fn onchange(at: Render(a), onchange: fn(String) -> a) -> Render(a) {
  let in =
    at.in
    |> input.on_change(onchange)
    |> input.on_input(onchange)

  UISearchRender(..at, in:)
}

pub fn view(at: Render(a)) -> UIRender(a) {
  let UISearchRender(in:, onsubmit:) = at

  html.div([a.class(search_class), event.on_submit(onsubmit)], [
    form.new("form-input-search")
    |> form.class("relative")
    |> form.render_inner(inline(in))
    |> form.view(),
  ])
}

// PRIVATE
//

fn inline(in) {
  [
    html.span([a.class(search_icon_class)], [
      svg.new(20, 20)
      |> svg_form.search()
      |> svg.class(search_icon_svg_class)
      |> svg.view(),
    ]),
    input.view(in),
    html.button([a.type_("submit"), a.class(search_button_class)], [
      svg.new(20, 20)
      |> icons.arrow_forward()
      |> svg.view(),
      // todo onkeydown
    // html.span([], [html.text(" ⌘ ")]),
    // html.span([], [html.text(" K ")]),
    ]),
  ]
}

const search_icon_class = "absolute top-1/2 left-4 -translate-y-1/2"

const search_icon_svg_class = "fill-gray-500 dark:fill-gray-400"

const search_button_class = "absolute top-1/2 right-2.5 inline-flex -translate-y-1/2 items-center gap-0.5 rounded-lg border border-gray-200 bg-gray-50 px-[7px] py-[4.5px] text-xs -tracking-[0.2px] text-gray-500 dark:border-gray-800 dark:bg-white/[0.03] dark:text-gray-400"

const search_class = "hidden lg:block"

const search_input_class = "dark:bg-dark-900 shadow-theme-xs focus:border-brand-300 focus:ring-brand-500/10 dark:focus:border-brand-800 h-11 w-full rounded-lg border border-gray-200 bg-transparent py-2.5 pr-14 pl-12 text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden xl:w-[430px] dark:border-gray-800 dark:bg-gray-900 dark:bg-white/[0.03] dark:text-white/90 dark:placeholder:text-white/30"
