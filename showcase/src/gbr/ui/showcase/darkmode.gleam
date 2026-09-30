////
//// 🌒 GBR: UI Showcase dark mode module
////
//// Um caminho fácil p/ gerenciarmos o tema de dark mode da aplicação.
////

import gleam/bool
import gleam/option.{type Option}
import gleam/result

import gbr/ui/showcase/storage

// ----------------------------------------------------------------------------
// --- Tipos
// ----------------------------------------------------------------------------

/// Browser dark mode type
///
/// - name: Nome da chave usada para armazenar o estado o local storage.
/// - selector: Onde está a classe p/ configurarmos o tema darkmode.
/// - class: Qual a classe de estilo que configura o tema darkmode.
///
pub opaque type DarkMode {
  Builder(name: String, selector: String, class: String, enabled: Bool)
}

// ----------------------------------------------------------------------------
// --- Builder
// ----------------------------------------------------------------------------

/// Cria um novo tipo darkmode com valores padrão.
///
/// - name: "browser/darkmode"
/// - selector: "body"
/// - class: "dark"
///
pub fn new() -> DarkMode {
  let name = const_key_storage
  let selector = const_element_selector
  let class = const_class_darkmode

  Builder(name:, selector:, class:, enabled: False)
}

/// Configura o nome da chave usada para armazenar o estado do tema darkmode.
///
/// - in: Dark mode info.
/// - name: Nome da chave do local storage, e.g. "browser/darkmode".
///
pub fn with_name(in: DarkMode, name: String) -> DarkMode {
  Builder(..in, name:)
}

/// Configura a classe de estilo que p/ o tema darkmode.
///
/// - in: Dark mode info
/// - class: Classe de estilo do tema darkmode.
///
pub fn with_class(in: DarkMode, class: String) -> DarkMode {
  Builder(..in, class:)
}

/// Configura o selector que é usado para encontrar o elemento darkmode.
///
/// - in: Dark mode info
/// - selector: Selector element p/ configurar o dark mode, e.g. "body"
///
pub fn with_selector(in: DarkMode, selector: String) -> DarkMode {
  Builder(..in, selector:)
}

// ----------------------------------------------------------------------------
// --- API Funções
// ----------------------------------------------------------------------------

/// Retorna se o tema darkmode está habilitado.
///
/// - in: Dark mode info
///
pub fn load_enabled(in: DarkMode) -> DarkMode {
  let Builder(name:, class:, ..) = in

  let enabled =
    storage.local()
    |> result.map(storage.get_item(_, name))
    |> result.flatten()
    |> result.map(fn(item) { item == bool.to_string(True) })
    |> result.unwrap(match_media("(prefers-color-scheme: " <> class <> ")"))

  Builder(..in, enabled:)
}

/// Configura o tema darkmode a partir do media class.
///
pub fn from_media(in: DarkMode) -> DarkMode {
  let Builder(selector:, class:, enabled:, ..) as in = load_enabled(in)

  case enabled {
    True -> {
      let Nil = ffi_add_class(selector, class)
      in
    }
    False -> {
      let Nil = ffi_remove_class(selector, class)
      in
    }
  }
}

/// Alterna o tema dakmode
///
/// - force: Se incluído, torna o toggle em uma operação `one way-only` (set).
///
pub fn toggle(in: DarkMode, force: Option(Bool)) -> Result(DarkMode, String) {
  let Builder(name:, class:, ..) = in
  let enabled = ffi_toggle_class(in.selector, class, force)

  use db <- result.try(storage.local())
  use _ <- result.map(storage.set_item(db, name, bool.to_string(enabled)))

  Builder(..in, enabled:)
}

// ----------------------------------------------------------------------------
// --- Constantes
// ----------------------------------------------------------------------------

const const_key_storage = "browser/darkmode"

const const_element_selector = "body"

const const_class_darkmode = "dark"

// ----------------------------------------------------------------------------
// --- FFI Javascript
// ----------------------------------------------------------------------------

@external(javascript, "../../../showcase_ffi.mjs", "matchMedia")
fn match_media(selector: String) -> Bool

@external(javascript, "../../../showcase_ffi.mjs", "add_class")
fn ffi_add_class(select: String, class: String) -> Nil

@external(javascript, "../../../showcase_ffi.mjs", "remove_class")
fn ffi_remove_class(select: String, class: String) -> Nil

@external(javascript, "../../../showcase_ffi.mjs", "toggle_class")
fn ffi_toggle_class(select: String, classs: String, force: Option(Bool)) -> Bool
