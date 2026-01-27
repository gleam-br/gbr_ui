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

type Table =
  UITable

type Render(a) =
  UITableRender(a)

/// Table type
///
/// - el: Base element type
/// - columns: List of columns
///
pub type UITable {
  UITable(el: el.UIEl, columns: Columns, ids: List(String))
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
pub type UITableRender(a) {
  UITableRender(
    in: Table,
    header: UIRenders(a),
    footer: UIRenders(a),
    column: Option(ColumnData(a)),
    thead: Option(ColumnHead(a)),
  )
}

/// Header table view component
///
type Header(a) =
  fn() -> element.Element(a)

/// Column key to thead view component
///
type ColumnHead(a) =
  fn(String) -> element.Element(a)

/// Column key and data id to tbody view component
///
type ColumnData(a) =
  fn(String, String) -> element.Element(a)

/// New super table element
///
pub fn new(id: String) -> Table {
  let el = el.new(id)

  UITable(el:, columns: [], ids: [])
}

/// Set list of columns
///
pub fn columns(in: Table, columns: Columns) -> Table {
  UITable(..in, columns:)
}

/// Set list of data ids.
///
pub fn ids(in: Table, ids: List(String)) -> Table {
  UITable(..in, ids:)
}

/// Render type from table element
///
pub fn render(in: Table) -> Render(a) {
  UITableRender(in:, column: None, thead: None, header: [], footer: [])
}

/// Set column data function view component
///
pub fn column(at: Render(a), column: ColumnData(a)) -> Render(a) {
  UITableRender(..at, column: Some(column))
}

/// Set header function view component
///
pub fn header(at: Render(a), header: UIRenders(a)) -> Render(a) {
  UITableRender(..at, header:)
}

/// Set footer function view component
///
pub fn footer(at: Render(a), footer: UIRenders(a)) -> Render(a) {
  UITableRender(..at, footer:)
}

/// Return view element
///
pub fn view(at: Render(a)) -> element.Element(a) {
  let UITableRender(in:, column:, header:, footer:, thead:) = at
  let UITable(el:, columns:, ids:) = in

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
      ids
        |> list.map(fn(id) {
          html.tr(
            [],
            columns
              |> list.map(fn(td) {
                let Column(key, _) = td

                html.td([], [
                  // fn view_data from get_data
                  column
                  |> option.map(fn(column) { column(id, key) })
                  |> option.unwrap(
                    typo.p(key <> id)
                    |> typo.class(
                      "text-theme-sm text-gray-500 dark:text-gray-400",
                    )
                    |> typo.view(),
                  ),
                ])
              }),
          )
        }),
    )
  let content =
    html.table([attribute.class("min-w-full")], [
      thead,
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
