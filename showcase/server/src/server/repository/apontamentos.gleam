////
////
////
////

import gleam/http/request
import gleam/http/response

import wisp

import server/web

pub fn listar(ctx, req) {
  todo
}

pub fn inserir(
  ctx: web.Context,
  req: request.Request(wisp.Connection),
) -> response.Response(wisp.Body) {
  todo
}

pub fn alterar(
  ctx: web.Context,
  id: String,
  req: request.Request(wisp.Connection),
) -> response.Response(wisp.Body) {
  todo
}

pub fn excluir(ctx: web.Context, id: String) -> response.Response(wisp.Body) {
  todo
}
