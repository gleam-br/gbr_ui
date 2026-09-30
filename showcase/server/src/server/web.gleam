////
//// GBR: UI Showcase Server Web module
////

import gleam/http
import server/repository/db

import cors_builder as cors
import wisp

/// Um ​​novo tipo de Contexto, que armazena quaisquer dados adicionais que os
/// manipuladores de requisição precisem além da requisição.
///
/// Aqui, ele armazena uma conexão com o banco de dados, mas poderia armazenar qualquer outra coisa
/// como chaves de API, funções de E/S (para que possam ser substituídas em
/// testes por implementações simuladas), configurações e assim por diante.
///
pub type Context {
  Context(db: db.Db, priv: String)
}

// -----------------------------------------------------------------------------
// --- API Funções
// -----------------------------------------------------------------------------

/// Wisp midleware
pub fn middleware(
  req: wisp.Request,
  priv: String,
  handle_request: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  let req = wisp.method_override(req)
  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes()
  use req <- wisp.handle_head(req)
  use req <- cors.wisp_middleware(req, cors())

  use <- wisp.serve_static(req, under: "/", from: priv <> "/static")

  handle_request(req)
}

// -----------------------------------------------------------------------------
// --- Funções auxiliares
// -----------------------------------------------------------------------------

/// TODO melhorar segurança aqui!
fn cors() {
  cors.new()
  |> cors.allow_origin("http://localhost:5173")
  |> cors.allow_header("content-type")
  |> cors.allow_header("origin")
  |> cors.allow_method(http.Get)
  |> cors.allow_method(http.Delete)
  |> cors.allow_method(http.Patch)
  |> cors.allow_method(http.Post)
}
