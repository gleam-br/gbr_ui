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

pub fn ultimo_pagamento(
  ctx: web.Context,
  consultor: String,
) -> response.Response(wisp.Body) {
  todo
}

pub fn horas(
  ctx: web.Context,
  consultor: String,
) -> response.Response(wisp.Body) {
  todo
}

pub fn cancelar(ctx: web.Context, id: String) -> response.Response(wisp.Body) {
  todo
}
