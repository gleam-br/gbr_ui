////
//// 📚 UI super table element
////

import gbr/ui
import gbr/ui/admin/button
import gbr/ui/svg
import gbr/ui/svg/icons
import gleam/list
import gleam/option.{type Option, None, Some}

import lustre/attribute
import lustre/element
import lustre/element/html

import gbr/ui/core/el
import gbr/ui/core/model.{type UIRenders}
import gbr/ui/typo

// Alias
//

type Columns =
  List(Column)

type Table(a) =
  UITable(a)

type Render(a, evt) =
  UITableRender(a, evt)

/// Table type
///
/// - el: Base element type
/// - columns: List of columns
///
pub type UITable(a) {
  UITable(el: el.UIEl, columns: Columns, ids: List(a))
}

/// Table column type
///
pub type Column {
  Column(key: String, label: String)
}

/// table render type
///
/// - in: Table type
/// - header: Header view
/// - footer: Footer view
/// - column: Column data view
/// - head: Column head label view
///
pub type UITableRender(a, evt) {
  UITableRender(
    in: Table(a),
    header: UIRenders(evt),
    footer: UIRenders(evt),
    empty: UIRenders(evt),
    column: Option(ColumnData(a, evt)),
    thead: Option(ColumnHead(evt)),
  )
}

// Header table view component
//
// type Header(a) =
//   fn() -> element.Element(a)

/// Column key to thead view component
///
type ColumnHead(a) =
  fn(String) -> element.Element(a)

/// Column key and data id to tbody view component
///
pub type ColumnData(a, evt) =
  fn(String, a) -> element.Element(evt)

/// New super table element
///
pub fn new(id: String) -> Table(a) {
  let el = el.new(id)

  UITable(el:, columns: [], ids: [])
}

/// Append class to element
///
pub fn class(in: Table(a), class: String) -> Table(a) {
  let el = el.class(in.el, class)

  UITable(..in, el:)
}

/// Set list of columns
///
pub fn columns(in: Table(a), columns: Columns) -> Table(a) {
  UITable(..in, columns:)
}

/// Set list of data ids.
///
pub fn ids(in: Table(a), ids: List(a)) -> Table(a) {
  UITable(..in, ids:)
}

/// Render type from table element
///
pub fn render(in: Table(a)) -> Render(a, evt) {
  UITableRender(
    in:,
    column: None,
    thead: None,
    header: [],
    footer: [],
    empty: [],
  )
}

/// On render column passsing column key and item id value.
///
/// - at: Table type instance.
/// - column: On column with args:
///   - Column key.
///   - Item id value.
///
/// Should return one lustre element representing column data.
///
pub fn oncolumn(
  at: Render(a, evt),
  column: ColumnData(a, evt),
) -> Render(a, evt) {
  UITableRender(..at, column: Some(column))
}

/// Set header function view component
///
pub fn header(at: Render(a, evt), header: UIRenders(evt)) -> Render(a, evt) {
  UITableRender(..at, header:)
}

/// Set footer function view component
///
pub fn footer(at: Render(a, evt), footer: UIRenders(evt)) -> Render(a, evt) {
  UITableRender(..at, footer:)
}

/// Set when is empty table function view component
///
pub fn empty(at: Render(a, evt), empty: UIRenders(evt)) -> Render(a, evt) {
  UITableRender(..at, empty:)
}

/// Return view element
///
pub fn view(at: Render(a, evt)) -> element.Element(evt) {
  let UITableRender(in:, column:, header:, footer:, thead:, empty:) = at
  let UITable(el:, columns:, ids:) = in
  let attrs = el.attrs(el)
  let has_ids = !list.is_empty(ids)
  let has_empty = !list.is_empty(empty)

  let thead =
    html.thead(
      [attribute.class("border-y border-gray-100 py-3 dark:border-gray-800")],
      [
        html.tr(
          [],
          columns
            |> list.map(fn(th) {
              let Column(key, label) = th

              html.th(
                [
                  attribute.class("py-3 pr-5 whitespace-nowrap sm:pr-6"),
                ],
                [
                  // custom thead.tr.th
                  thead
                  |> option.map(fn(func) { func(key) })
                  |> option.unwrap(
                    html.div([attribute.class("flex items-center")], [
                      typo.p(label)
                      |> typo.class(
                        "text-theme-sm text-gray-500 dark:text-gray-400",
                      )
                      |> typo.view(),
                    ]),
                  ),
                ],
              )
            }),
        ),
      ],
    )
  let tbody =
    html.tbody(
      [attribute.class("divide-y divide-gray-100 dark:divide-gray-800")],
      // list of ids
      case has_ids, has_empty {
        False, False -> [
          html.tr([], [
            html.td(
              [attribute.colspan(2), attribute.class("text-center py-10")],
              [
                typo.span("No avaiable items")
                |> typo.class("text-gray-500 dark:text-gray-400")
                |> typo.view(),
              ],
            ),
          ]),
        ]
        False, True -> empty
        True, _ -> {
          ids
          |> list.map(fn(id) {
            html.tr(
              [],
              columns
                |> list.map(fn(td) {
                  let Column(key, _) = td

                  html.td([attribute.class("px-1")], [
                    // fn view_data from get_data
                    column
                    |> option.map(fn(column) { column(key, id) })
                    |> option.unwrap(element.none()),
                  ])
                }),
            )
          })
        }
      },
    )
  let content =
    html.table([attribute.class("min-w-full"), ..attrs], [
      case has_ids {
        True -> thead
        False -> element.none()
      },
      tbody,
    ])

  ui.content([content], header, footer)
}

/// WIP table pagination
///
pub fn footer_pagination() {
  [
    html.div([attribute.class("flex items-center justify-between")], [
      // todo onclick
      button.new("table_propriedade_footer_btn_next")
        |> button.tertiary()
        |> button.label("Anterior")
        |> button.sm()
        |> button.render_left([
          svg.new(20, 20)
          |> icons.arrow_back()
          |> svg.view(),
        ])
        |> button.view(),
      // todo pagination to table
      typo.span("Página 1 de 10")
        |> typo.class(
          "block text-sm font-medium text-gray-700 sm:hidden dark:text-gray-400",
        )
        |> typo.view(),
      // tod gbr_list
      html.ul(
        [attribute.class("hidden items-center gap-0.5 sm:flex")],
        [
          #("1", True),
          #("2", False),
          #("3", False),
          #("...", False),
          #("8", False),
          #("9", False),
          #("10", False),
        ]
          |> list.map(fn(page) {
            let #(page, selected) = page
            html.li([], [
              html.a(
                [
                  attribute.classes([
                    #(
                      "bg-brand-500/[0.08] text-brand-500 dark:text-brand-500",
                      selected,
                    ),
                  ]),
                  attribute.classes([
                    #("text-gray-700 dark:text-gray-400", !selected),
                  ]),
                  attribute.class(
                    "text-theme-sm hover:bg-brand-500/[0.08] hover:text-brand-500 dark:hover:text-brand-500 flex h-10 w-10 items-center justify-center rounded-lg font-medium cursor-pointer",
                  ),
                ],
                [html.text(" " <> page <> " ")],
              ),
            ])
          }),
      ),
      // todo onclick
      button.new("table_propriedade_footer_btn_next")
        |> button.tertiary()
        |> button.label("Próximo")
        |> button.sm()
        |> button.render_right([
          svg.new(20, 20)
          |> icons.arrow_forward()
          |> svg.view(),
        ])
        |> button.view(),
    ]),
  ]
}
