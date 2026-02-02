////
//// 🏡 UI home page admin.
////

import gleam/option.{type Option, None, Some}

import lustre/effect
import lustre/element

import gbr/ui
import gbr/ui/logo

import gbr/ui/admin/header
import gbr/ui/admin/sidebar
import gbr/ui/admin/sidebar/menu
import gbr/ui/admin/user

// Alias
//

type Home =
  HomePage

type Render(a) =
  HomePageRender(a)

type Event =
  HomePageEvent

type OnEvent(a) =
  fn(Event) -> a

type Update(a) =
  #(Home, effect.Effect(a))

type Logo =
  logo.UILogo

type User =
  user.UIUser

type Menu =
  menu.UISidebarMenu

type Sidebar =
  sidebar.UISidebar

type Header =
  header.UIHeader

/// Home page element
///
/// - sidebar: Sidebar element
/// - header: Header element
///
pub opaque type HomePage {
  HomePage(sidebar: Sidebar, header: Header)
}

/// Home page render element type
///
/// - in: Home page info
/// - onhome: Events on home, e.g., on sidebar change
/// - ondark: Event on dark mode toggle
///
pub opaque type HomePageRender(a) {
  HomePageRender(in: HomePage, onhome: Option(OnEvent(a)), ondark: Option(a))
}

/// Home page event
///
/// - OnUserDropdown: User dropdown is toggle
/// - OnUserDropdownSubmit: User dropdown button(s) submit
/// - OnSidebarClick: Sidebar menu clicked
/// - OnSidebar: Sidebar is toggle
/// - OnAppMobile: App button clicked on mobile screen
///
pub type HomePageEvent {
  OnAppMobile
  OnUserDropdown
  OnUserDropdownClick(String)
  OnSidebar
  OnSidebarClick(String, Menu)
}

/// New home page type
///
/// - menus: Menu list to sidebar
///
pub fn new() -> HomePage {
  let header = header.new("header")
  let sidebar =
    sidebar.new("sidebar")
    |> sidebar.root([])

  HomePage(sidebar:, header:)
}

/// Set home page sidebar menus
///
/// - in: Home page type instance
/// - menus: List of menu type instances
///
pub fn menus(in: HomePage, menus: List(menu.UISidebarMenu)) -> HomePage {
  let sidebar = sidebar.root(in.sidebar, menus)

  HomePage(..in, sidebar:)
}

/// Set logo in header and sidebar elements
///
/// - in: Home page type instance.
/// - logo: UI logo element type instance.
///
pub fn logo(in: HomePage, logo: Logo) {
  let header =
    in.header
    |> header.logo(logo)
  let sidebar =
    in.sidebar
    |> sidebar.logo(logo)

  HomePage(header:, sidebar:)
}

/// Set user element info to home page
///
pub fn user(in: Home, user: User) -> Home {
  let header = header.user(in.header, user)

  HomePage(..in, header:)
}

/// Select menu into sidebar menu by id
///
/// - in: Home page info
/// - id: Menu id to select
///
pub fn sidebar_select(in: Home, id: String) -> Home {
  let menu = sidebar.menu(in.sidebar, id)

  case menu {
    None -> in
    Some(menu) -> {
      let sidebar = sidebar.selected(in.sidebar, id, menu)

      HomePage(..in, sidebar:)
    }
  }
}

///
///
pub fn render(in: Home) -> Render(a) {
  HomePageRender(in:, onhome: None, ondark: None)
}

/// Set handler to on home events
///
/// - in: Home page render element info
/// - onhome: Handler to events
///
pub fn onhome(in: Render(a), onhome: OnEvent(a)) -> Render(a) {
  HomePageRender(..in, onhome: Some(onhome))
}

/// Set handler to on dark mode toggle event
///
/// - in: Home page render element info
/// - ondark: Handler to dark mode event
///
pub fn ondark(in: Render(a), ondark: a) -> Render(a) {
  HomePageRender(..in, ondark: Some(ondark))
}

/// Render home page element
///
/// - in: Home page information
/// - content: Home option main content element
///
pub fn view(at: Render(a), content: element.Element(a)) -> element.Element(a) {
  let HomePageRender(in:, onhome:, ondark:) = at
  let HomePage(header:, sidebar:) = in

  let header = render_header(header, onhome, ondark)
  let sidebar = render_sidebar(sidebar, onhome)

  ui.primary(header:, sidebar:, content: Some(content))
}

/// Update home info from event handle
///
/// - in: Home page info
/// - event: Home page event to handle
///
pub fn update(in: Home, event: Event) -> Update(a) {
  let HomePage(header:, sidebar:) = in

  case event {
    OnSidebarClick(id, menu) -> {
      let sidebar = sidebar.selected(sidebar, id, menu)
      let home = HomePage(..in, sidebar:)

      #(home, effect.none())
    }
    OnSidebar -> {
      let header = header.toggle_sidebar(header)
      let sidebar = sidebar.toggle(sidebar)
      let home = HomePage(header:, sidebar:)

      #(home, effect.none())
    }
    OnUserDropdown -> {
      let header = header.toggle_dropdown(header)
      let home = HomePage(..in, header:)

      #(home, effect.none())
    }
    OnAppMobile -> {
      let header = header.toggle_mobile(header)
      let home = HomePage(..in, header:)

      #(home, effect.none())
    }
    _ -> #(in, effect.none())
  }
}

// PRIVATE
//

fn render_header(header, onhome, ondark) {
  header.render(header)
  |> header_events(onhome, ondark)
  |> header.view()
}

fn render_sidebar(sidebar, onhome) {
  let onhome =
    onhome
    |> option.map(fn(onhome) {
      fn(id, menu) {
        OnSidebarClick(id, menu)
        |> onhome()
      }
    })

  sidebar.render(sidebar, onhome)
  |> sidebar.view()
}

fn header_events(header, onhome, ondark) {
  header
  |> header.on_darkmode_opt(ondark)
  |> header.on_sidebar_opt(
    onhome
    |> option.map(fn(onhome) { onhome(OnSidebar) }),
  )
  |> header.on_mobile_opt(
    onhome
    |> option.map(fn(onhome) { onhome(OnAppMobile) }),
  )
  |> header.on_dropdown_opt(
    onhome
    |> option.map(fn(onhome) { onhome(OnUserDropdown) }),
  )
  |> header.on_submit_opt(
    onhome
    |> option.map(fn(onhome) {
      fn(id_btn) {
        OnUserDropdownClick(id_btn)
        |> onhome
      }
    }),
  )
}
