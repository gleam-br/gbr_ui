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

pub fn incluir(
  ctx: web.Context,
  req: request.Request(wisp.Connection),
) -> response.Response(wisp.Body) {
  todo
}

pub fn next(
  ctx: web.Context,
  req: request.Request(wisp.Connection),
) -> response.Response(wisp.Body) {
  todo
}

pub fn contents(
  ctx: web.Context,
  req: request.Request(wisp.Connection),
) -> response.Response(wisp.Body) {
  todo
}

pub fn download(
  ctx: web.Context,
  platform: String,
  version: String,
) -> response.Response(wisp.Body) {
  todo
}
