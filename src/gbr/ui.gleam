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
//// pub fn render(in: Login) -> Element(LoginEvent) {
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
//// pub fn render(in: AdminHome) -> Element(AdminEvent) {
////   let AdminHome(sidebar:, header:, content:, breadcrumb:) = in
////
////   ui.main(header:, sidebar:, content:, breadcrumb:)
//// }
//// ```
////

import gbr/ui/svg
import gleam/bool
import gleam/option.{type Option, None}

import lustre/attribute.{alt, class, src}

import lustre/element
import lustre/element/html

/// UI render required element of generic event `a`.
///
/// Wrapper to `lustre/element.{type Elment}`
///
pub type UIRender(a) =
  element.Element(a)

/// List of `gbr/ui.{type UIRender}`.
///
pub type UIRenders(a) =
  List(UIRender(a))

/// List of `gbr/ui.{type UIRenderOpt}`.
///
pub type UIRenderOpts(a) =
  List(UIRenderOpt(a))

/// UI render option element of generic event `a`.
///
/// Option to `gbr/ui.{type UIRender}`
///
pub type UIRenderOpt(a) =
  Option(UIRender(a))

/// Construct new super svg element `gbr/ui/svg.{of}`.
///
pub const svg = svg.of

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
/// pub fn render(in: Login) -> Element(LoginEvent) {
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
  html.div([class(horizontal_class)], [
    html.div([class(horizontal_main_class)], inner),
  ])
}

/// UI layout partial with header and sidebar only.
///
/// Better choise when you need only partial main layout.
///
/// ### Fn desc: Transform two `2 -> 1`
///
/// Two elements to one element with partial main layout ui.
///
pub fn partial(
  header header: UIRender(a),
  sidebar sidebar: UIRender(a),
) -> UIRender(a) {
  main(header:, sidebar:, content: None)
}

/// UI main layout with header, sidebar, breadcrumb and content.
///
/// Excelent layout to admin home page.
///
/// Better choise to work with [gbr_ui_router](https://github.com/gleam-br/gbr_ui_router) links in sidebar to update content element.
///
/// Supose admin home render function:
///
/// ```gleam
/// pub fn render(in: AdminHome) -> Element(AdminEvent) {
///   let AdminHome(sidebar:, header:, content:, breadcrumb:) = in
///
///   ui.main(header:, sidebar:, content:, breadcrumb:)
/// }
/// ```
///
/// ### Fn desc: Transform three `3 -> 1`
///
/// Three elements to one element with main layout.
///
pub fn main(
  header header: UIRender(a),
  sidebar sidebar: UIRender(a),
  content content: UIRenderOpt(a),
) -> UIRender(a) {
  main_with_breadcrumb(header:, sidebar:, content:, breadcrumb: None)
}

/// Same of `gbr/ui.{main}` with optional breadcrumb element.
///
pub fn main_with_breadcrumb(
  header header: UIRender(a),
  sidebar sidebar: UIRender(a),
  content content: UIRenderOpt(a),
  breadcrumb breadcrumb: UIRenderOpt(a),
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
      html.main([class(main_body_class)], [
        breadcrumb,
        content,
      ]),
      //element.none(), footer area ... todo ...
    ]),
  ])
}

/// UI grid layout with left, right, inner elements.
///
/// Excelent layout to one page message from errors, e.g. 404 or page to payment success message.
///
/// Supose page 404 with grid img background render function:
///
/// ```gleam
/// pub fn render() -> Element(Msg) {
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
  html.div([class(grid_content_class)], [
    html.div([class(grid_main_class)], [
      html.div([class(grid_left_class)], left),
      html.div([class(grid_right_class)], right),
      ..inner
    ]),
  ])
}

// PRIVATE
//

const loader_class = "fixed left-0 top-0 z-999999 flex h-screen w-screen items-center justify-center bg-white dark:bg-black"

const loader_spin_class = "h-16 w-16 animate-spin rounded-full border-4 border-solid border-brand-500 border-t-transparent"

const main_class = "flex h-screen overflow-hidden bg-gray-100 dark:bg-gray-900"

const main_content_class = "relative flex flex-1 flex-col overflow-x-hidden overflow-y-auto"

const main_body_class = "mx-auto max-w-(--breakpoint-2xl) p-4 md:p-6"

const horizontal_class = "relative p-6 sm:p-0"

const horizontal_main_class = "relative flex flex-col justify-center w-full h-screen bg-white dark:bg-gray-900 sm:p-0 lg:flex-row"

const grid_content_class = "relative items-center hidden w-full h-full bg-brand-950 dark:bg-white/5 lg:grid lg:w-1/2"

const grid_main_class = "flex items-center justify-center z-1"

const grid_left_class = "absolute right-0 top-0 -z-1 w-full max-w-[250px] xl:max-w-[450px]"

const grid_right_class = "absolute bottom-0 left-0 -z-1 w-full max-w-[250px] rotate-180 xl:max-w-[450px]"
