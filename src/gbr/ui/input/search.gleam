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

import gleam/option.{type Option, None, Some}

import lustre/attribute as a
import lustre/element/html
import lustre/event

import gbr/ui/form
import gbr/ui/input
import gbr/ui/svg
import gbr/ui/svg/form as svg_form

import gbr/ui/core/model.{type UIRender}

type Search =
  UISearch

type Render(a) =
  UISearchRender(a)

type Evt(a) =
  Option(fn(String) -> a)

pub opaque type UISearch {
  UISearch(term: String, loading: Bool)
}

pub opaque type UISearchRender(a) {
  UISearchRender(
    in: Search,
    onsubmit: Evt(a),
    onchange: Evt(a),
    onkeypress: Evt(a),
  )
}

pub fn new(term: String) -> Search {
  UISearch(term:, loading: False)
}

pub fn loading(in: Search, loading: Bool) -> Search {
  UISearch(..in, loading:)
}

pub fn onchange(in: Render(a), onchange: Evt(a)) -> Render(a) {
  UISearchRender(..in, onchange: onchange)
}

pub fn onsubmit(in: Render(a), onsubmit: Evt(a)) -> Render(a) {
  UISearchRender(..in, onsubmit: onsubmit, onchange: onsubmit)
}

pub fn onkeypress(in: Render(a), onkeypress: Evt(a)) -> Render(a) {
  UISearchRender(..in, onkeypress:)
}

pub fn at(in: Search) -> Render(a) {
  UISearchRender(in:, onsubmit: None, onchange: None, onkeypress: None)
}

pub fn render(at: Render(a)) -> UIRender(a) {
  html.div([a.class(search_class)], [
    form.new("form-input-search")
    |> form.classes(["relative"])
    |> form.at_inline(inline(at))
    |> form.render(),
  ])
}

// PRIVATE
//

fn inline(at: Render(a)) {
  let UISearchRender(in:, onsubmit:, onchange:, onkeypress:) = at
  let UISearch(term:, ..) = in

  [
    html.span([a.class(search_icon_class)], [
      svg.new("form-input-search-icon", 20, 20)
      |> svg_form.search()
      |> svg.classes([search_icon_svg_class])
      |> svg.render(),
    ]),
    input.text("ui-input-search")
      |> input.search()
      |> input.placeholder("Buscar por...")
      |> input.at()
      |> input.on_keypress_opt(onkeypress)
      |> do_onchange(onchange, term)
      |> input.render(),
    html.button([a.class(search_button_class), ..do_onsubmit(onsubmit, term)], [
      html.span([], [html.text(" ⌘ ")]),
      html.span([], [html.text(" K ")]),
    ]),
  ]
}

fn do_onsubmit(onsubmit, term) {
  case onsubmit {
    Some(evt) -> [event.on_click(evt(term))]
    None -> []
  }
}

fn do_onchange(in, onchange, term) {
  case onchange {
    Some(evt) -> {
      in
      |> input.on_change(evt)
      |> input.on_input(evt)
      |> input.on_paste(evt(term))
    }
    None -> in
  }
}

const search_icon_class = "absolute top-1/2 left-4 -translate-y-1/2"

const search_icon_svg_class = "fill-gray-500 dark:fill-gray-400"

const search_button_class = "absolute top-1/2 right-2.5 inline-flex -translate-y-1/2 items-center gap-0.5 rounded-lg border border-gray-200 bg-gray-50 px-[7px] py-[4.5px] text-xs -tracking-[0.2px] text-gray-500 dark:border-gray-800 dark:bg-white/[0.03] dark:text-gray-400"

pub const search_class = "hidden lg:block"
