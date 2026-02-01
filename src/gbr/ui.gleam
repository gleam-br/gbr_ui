////
//// 🎨 Gleam UI library by @gleam-br
////
//// Loader:
////
//// ```gleam
//// fn view(model: Model) -> Element(ModelEvent) {
////    let Model(loading:) = model
////
////    loading
////    |> ui.loader()
//// }
//// ```
////
//// Horizontal:
////
//// ```gleam
//// pub fn view(in: Login) -> Element(LoginEvent) {
////   let Login(basic:, logo:) = in
////
////   [basic, logo]
////   |> ui.horizontal()
//// }
//// ```
////
//// Main:
////
//// ```gleam
//// pub fn view(in: AdminHome) -> Element(AdminEvent) {
////   let AdminHome(sidebar:, header:, content:, breadcrumb:) = in
////
////   ui.primary(header:, sidebar:, content:, breadcrumb:)
//// }
//// ```
////

import gleam/bool
import gleam/list
import gleam/option.{None}

import lustre/attribute.{class}
import lustre/element
import lustre/element/html

import gbr/ui/admin/pages/domain as pages
import gbr/ui/admin/sidebar/menu
import gbr/ui/svg

import gbr/ui/core/model.{
  type UIAttrs, type UIBoxes, type UIOptRender, type UIRender, type UIRenders,
  UIBox,
}

// Alias
//

type Page(a) =
  pages.UIPage(a)

/// Construct new super svg element `gbr/ui/svg.{new}`.
///
pub const svg = svg.new

/// UI loader layout with ui screen full blur and a center spin loader.
///
/// Better choice to work with [gbr_js](https://github.com/gleam-br/gbr_js) and `gbr/js/global.{dom_content_loaded}`.
///
/// Supose on dom loaded dispatch OnLoading(False) when:
///   - init: Model(loading: True)
///   - after: Model(loading: False):
///
/// ```gleam
/// fn on_dom_loaded(runtime) {
///   use _ <- function.tap(runtime)
///   use _ <- global.dom_content_loaded()
///
///   AdminEventOnLoading(False)
///   |> lustre.dispatch()
///   |> lustre.send(runtime, _)
/// }
///
/// fn view(model: Model) -> Element(ModelEvent) {
///    let Model(loading:) = model
///
///    loading
///    |> ui.loader()
/// }
/// ```
///
/// ### Fn desc: Trasform one `1 -> 1`
///
/// Bool type to loader element layout
///
/// -  `True`: Render loader
/// -  `False`: Render `lustre/element.{none}`
///
pub fn loader(loading: Bool) -> UIRender(a) {
  use <- bool.guard(!loading, element.none())

  html.div([class(loader_class)], [
    html.div([class(loader_spin_class)], []),
  ])
}

/// UI layout with horizontal inner elements.
///
/// Better choise to work with `gbr/ui/login.{basic}`.
///
/// Supose login render function:
///
/// ```gleam
/// pub fn view(in: Login) -> Element(LoginEvent) {
///   let Login(basic:, logo:) = in
///
///   [basic, logo]
///   |> ui.horizontal()
/// }
/// ```
/// ### Fn desc: Reduce `* -> 1`
///
/// List of elements to one element with horizontal layout inner elements.
///
pub fn horizontal(inner: UIRenders(a)) -> UIRender(a) {
  html.div([class("relative z-1 bg-white p-6 sm:p-0 dark:bg-gray-900")], [
    html.div(
      [
        class(
          "relative flex h-screen w-full flex-col justify-center sm:p-0 lg:flex-row dark:bg-gray-900",
        ),
      ],
      inner,
    ),
  ])
}

/// UI layout partial with header and sidebar only.
///
/// Better choise when you need only partial primary layout.
///
/// ### Fn desc: Transform two `2 -> 1`
///
/// Two elements to one element with partial primary layout ui.
///
pub fn partial(
  header header: UIRender(a),
  sidebar sidebar: UIRender(a),
) -> UIRender(a) {
  primary(header:, sidebar:, content: None)
}

/// UI primary layout with header, sidebar, breadcrumb and content.
///
/// Excelent layout to admin home page.
///
/// Better choise to work with [gbr_ui_router](https://github.com/gleam-br/gbr_ui_router) links in sidebar to update content element.
///
/// Supose admin home render function:
///
/// ```gleam
/// pub fn view(in: AdminHome) -> Element(AdminEvent) {
///   let AdminHome(sidebar:, header:, content:, breadcrumb:) = in
///
///   ui.primary(header:, sidebar:, content:, breadcrumb:)
/// }
/// ```
///
/// ### Fn desc: Transform three `3 -> 1`
///
/// Three elements to one element with primary layout.
///
pub fn primary(
  header header: UIRender(a),
  sidebar sidebar: UIRender(a),
  content content: UIOptRender(a),
) -> UIRender(a) {
  primary_with_breadcrumb(header:, sidebar:, content:, breadcrumb: None)
}

/// UI page with title and inner elements
///
/// - title: Page title text
/// - inner: Inner elements
///
pub fn page(title: String, inner: UIRenders(a)) -> UIRender(a) {
  html.div(
    [
      class(
        "rounded-2xl border border-gray-200 bg-white dark:border-gray-800 dark:bg-white/[0.03]",
      ),
    ],
    [
      html.div([class("px-5 py-4 sm:px-6 sm:py-5")], [
        html.h3(
          [class("text-base font-medium text-gray-800 dark:text-white/90")],
          [html.text(title)],
        ),
      ]),
      html.div(
        [
          class(
            "space-y-6 border-t border-gray-100 p-5 sm:p-6 dark:border-gray-800",
          ),
        ],
        inner,
      ),
    ],
  )
}

/// UI grid layout with left, right, inner elements.
///
/// Excelent layout to one page message from errors, e.g. 404 or page to payment success message.
///
/// Supose page 404 with grid img background render function:
///
/// ```gleam
/// pub fn view() -> Element(Msg) {
///   let img = html.img([src("/assets/grid-01.svg"), alt("Grid")])
///   let inner = [
///     html.h1([], [html.text("404: Not found")])
///   ]
///
///   ui.grid(left: img, right: img, inner:)
/// }
/// ```
///
/// ### Fn desc: Transform three `3 -> 1`
///
/// Three elements to one element with grid layout.
///
pub fn grid(
  left: UIRenders(a),
  right: UIRenders(a),
  inner: UIRenders(a),
) -> UIRender(a) {
  html.div(
    [
      class(
        "bg-brand-950 relative hidden h-full w-full items-center lg:grid lg:w-1/2 dark:bg-white/5",
      ),
    ],
    [
      html.div([class("z-1 flex items-center justify-center")], [
        html.div(
          [
            class(
              "absolute right-0 top-0 -z-1 w-full max-w-[250px] xl:max-w-[450px]",
            ),
          ],
          left,
        ),
        html.div(
          [
            class(
              "absolute bottom-0 left-0 -z-1 w-full max-w-[250px] rotate-180 xl:max-w-[450px]",
            ),
          ],
          right,
        ),
        ..inner
      ]),
    ],
  )
}

/// UI boxes layout
///
pub fn box(in: UIBoxes(a), attrs: UIAttrs(a)) -> UIRender(a) {
  let attrs = [class(box_class), ..attrs]
  let inner = box_inner(in)

  html.div(attrs, inner)
}

/// Same of `gbr/ui.primary` with optional breadcrumb element.
///
/// TODO: WIP
///
pub fn primary_with_breadcrumb(
  header header: UIRender(a),
  sidebar sidebar: UIRender(a),
  content content: UIOptRender(a),
  breadcrumb breadcrumb: UIOptRender(a),
) -> UIRender(a) {
  let breadcrumb = option.unwrap(breadcrumb, element.none())
  let content = option.unwrap(content, element.none())

  // page wrapper
  html.div([class(main_class)], [
    // sidebar area
    sidebar,
    // content area
    html.div([class(main_content_class)], [
      //element.none(), overlay mobile, close when outside menu ... todo ...
      // header area
      header,
      // main area
      html.main([], [
        html.div([class(main_body_class)], [
          breadcrumb,
          content,
        ]),
      ]),
      //element.none(), footer area ... todo ...
    ]),
  ])
}

/// UI content layout view w/ header, content, footer
///
/// - content: View component
/// - header: View component
/// - footer: View component
///
pub fn content(
  content: UIRenders(a),
  header: UIRenders(a),
  footer: UIRenders(a),
) -> UIRender(a) {
  html.div(
    [
      attribute.class(
        "rounded-2xl border border-gray-200 bg-white pt-4 dark:border-gray-800 dark:bg-white/[0.03]",
      ),
    ],
    [
      // header
      html.div(
        [
          attribute.class(
            "mb-4 flex flex-col gap-2 px-5 sm:flex-row sm:items-center sm:justify-between sm:px-6",
          ),
        ],
        header,
      ),
      html.div(
        [
          attribute.class(
            "space-y-4 border-t border-gray-100 p-5 sm:p-6 dark:border-gray-700 custom-scrollbar max-w-full overflow-x-auto overflow-y-visible px-5 sm:px-6",
          ),
        ],
        content,
      ),
      html.div(
        [
          attribute.class(
            "border-t border-gray-200 px-6 py-4 dark:border-gray-800",
          ),
        ],
        footer,
      ),
    ],
  )
}

/// TODO Move it to util module
///
pub fn page_to_menu(in: Page(a)) {
  menu.new(in.id)
  |> menu.title(in.title)
}

// PRIVATE
//

fn box_inner(in) {
  use box <- list.map(list.reverse(in))
  let UIBox(title:, content:, footer:, attrs:) = box

  html.div(attrs, [
    html.h3([class(box_title_class)], [title]),
    html.p([class(box_body_class)], [content]),
    html.div([class(box_footer_class)], [footer]),
  ])
}

const loader_class = "fixed left-0 top-0 z-999999 flex h-screen w-screen items-center justify-center bg-white dark:bg-black"

const loader_spin_class = "h-16 w-16 animate-spin rounded-full border-4 border-solid border-brand-500 border-t-transparent"

const main_class = "flex h-screen overflow-hidden bg-gray-100 dark:bg-gray-900"

const main_content_class = "relative flex flex-1 flex-col overflow-x-hidden overflow-y-auto"

const main_body_class = "mx-auto max-w-(--breakpoint-2xl) p-4 md:p-6"

const box_class = "mx-auto mb-10 w-full max-w-60 rounded-2xl bg-gray-50 px-4 py-5 text-center dark:bg-white/[0.03]"

const box_title_class = "mb-2 font-semibold text-gray-900 dark:text-white"

const box_body_class = "mb-4 text-theme-sm text-gray-500 dark:text-gray-400"

const box_footer_class = "flex items-center justify-center rounded-lg bg-brand-500 p-3 text-theme-sm font-medium text-white hover:bg-brand-600"
