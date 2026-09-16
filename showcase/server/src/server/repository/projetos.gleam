////
////
////

import gleam/http/request
import gleam/http/response

import wisp

import server/web

pub fn listar(
  ctx: web.Context,
  req: request.Request(wisp.Connection),
) -> response.Response(wisp.Body) {
  todo
}

pub fn recuperar(
  ctx: web.Context,
  id: String,
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

pub fn incompletos(
  ctx: web.Context,
  req: request.Request(wisp.Connection),
) -> response.Response(wisp.Body) {
  todo
}

pub fn propriedades(
  ctx: web.Context,
  req: request.Request(wisp.Connection),
) -> response.Response(wisp.Body) {
  todo
}

pub fn propriedades_por_id(
  ctx: web.Context,
  id: String,
  req: request.Request(wisp.Connection),
) -> response.Response(wisp.Body) {
  todo
}

pub fn contatos(
  ctx: web.Context,
  id: String,
  req: request.Request(wisp.Connection),
) -> response.Response(wisp.Body) {
  todo
}

pub fn tecnologias(
  ctx: web.Context,
  id: String,
  req: request.Request(wisp.Connection),
) -> response.Response(wisp.Body) {
  todo
}

pub fn contrato(
  ctx: web.Context,
  id: String,
  req: request.Request(wisp.Connection),
) -> response.Response(wisp.Body) {
  todo
}
