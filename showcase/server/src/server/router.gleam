////
//// GBR: UI Showcase Server Router module
////

import gleam/http
import gleam/option.{None}

import wisp.{type Request, type Response}

import server/repository/autenticacao
import server/web

/// Trata a requisição roteando p/ a devida funcionalidade
pub fn handle_request(req: Request, ctx: web.Context) -> Response {
  // Web middleware insere configurações p/ o http
  use req <- web.middleware(req, ctx.priv)

  // O módulo de roteamento agora lida apenas com roteamento e encaminha para os
  // módulos de recursos para lidar com solicitações.
  case wisp.path_segments(req) {
    [] ->
      case req.method {
        http.Get -> serve_index(ctx.priv <> "/static")
        _ -> wisp.not_found()
      }
    //
    // --- Security
    // TODO precisa retornar um token válido
    //
    ["security", "login"] -> autenticacao.login(ctx, req)
    ["security", "login", "refresh", ..rest] ->
      autenticacao.refresh(ctx, req, rest)
    //
    // --- Geral: Portifólio
    //
    _ -> wisp.not_found()
  }
}

fn serve_index(priv) {
  wisp.ok()
  |> wisp.set_header("content-type", "text/html")
  |> wisp.set_body(wisp.File(
    path: priv <> "/index.html",
    offset: 0,
    limit: None,
  ))
}
