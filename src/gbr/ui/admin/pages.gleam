////
//// 📑 UI super page element
////
////

import gleam/bool
import gleam/dict
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/uri

import lustre/attribute
import lustre/effect
import lustre/element
import lustre/element/html

import gbr/ui/admin/pages/domain

pub type Page(a) =
  domain.UIPage(a)

pub type Pages(a) =
  domain.UIPages(a)

/// New ui page
///
/// - id: Identification slug uri
/// - title: Title of page.
///
pub fn new(id: String, title: String) -> Page(a) {
  domain.UIPage(id:, title:, view: None, init: None)
}

/// Set view function to page identifcated by id
///
/// - pages: List of pages
/// - id: Page id
/// - view: Page view function
///
pub fn view(pages: Pages(a), id: String, view: fn() -> element.Element(a)) {
  find_id(pages, id)
  |> option.map(fn(page) { domain.UIPage(..page, view: Some(view)) })
  |> option.map(fn(page) { dict.insert(pages, id, page) })
  |> option.unwrap(pages)
}

/// Set init function to page identified by id
///
/// > To load resources on start page view.
///
/// - pages: List of pages
/// - id: Page id
/// - init: Page init function.
///
pub fn init(pages: Pages(a), id: String, init: fn() -> effect.Effect(a)) {
  find_id(pages, id)
  |> option.map(fn(page) { domain.UIPage(..page, init: Some(init)) })
  |> option.map(fn(page) { dict.insert(pages, id, page) })
  |> option.unwrap(pages)
}

/// List of pages to dictonary of id and page
///
/// - pages: List of pages
///
pub fn to_dict(pages: List(Page(a))) -> Pages(a) {
  {
    use page <- list.map(pages)
    #(page.id, page)
  }
  |> dict.from_list()
}

/// Find page by uri match page id.
///
/// - pages: Dict of page
/// - uri: Option uri ??? TODO ???
///
pub fn find(pages: Pages(a), uri: Option(uri.Uri)) {
  use <- bool.guard(option.is_none(uri), None)
  let assert Some(uri) = uri

  find_id(pages, uri.path)
}

/// Find page by id from dict
///
/// - pages: Dict of pages.
/// - id: Page id.
///
pub fn find_id(pages: Pages(a), id: String) {
  {
    use page <- result.map(dict.get(pages, id))

    page
  }
  |> option.from_result()
}

/// Auxiliar function to view span title element
///
/// - in: Page type instance.
///
pub fn to_span(in: Page(a)) {
  html.span([attribute.class("text-2xl dark:text-gray-100 text-gray-900")], [
    html.text(in.title),
  ])
}
