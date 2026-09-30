////
////
////

import gleam/http/request
import gleam/http/response
import gleam/json
import gleam/list

import shork
import wisp

import server/web

fn get_list(db, sql, decoder, to_json, values) {
  let set_values = fn(query) {
    {
      use acc, value <- list.fold(values, query)

      shork.parameter(acc, value)
    }
  }

  let result =
    shork.query(sql)
    |> set_values()
    |> shork.returning(decoder)
    |> shork.execute(db)

  case result {
    Ok(result) -> {
      json.array(result.rows, to_json)
      |> json.to_string()
      |> wisp.json_response(200)
    }
    Error(err) -> {
      echo err
      wisp.internal_server_error()
    }
  }
}

pub fn plataformas(ctx: web.Context, _req) {
  todo
  // let decoder = {
  //   use id <- decode.field(0, decode.int)
  //   use description <- decode.field(1, decode.optional(decode.string))
  //   use path <- decode.field(2, decode.optional(decode.string))
  //   use initials <- decode.field(3, decode.optional(decode.string))

  //   domain.Platform(id:, description:, path:, initials:)
  //   |> decode.success()
  // }

  // get_list(
  //   ctx.db,
  //   "select id, description, path, initials from platform",
  //   decoder,
  //   domain.to_json_platform,
  //   [],
  // )
}

pub fn tecnologias(
  ctx: web.Context,
  _req: request.Request(wisp.Connection),
) -> response.Response(wisp.Body) {
  todo
  // let decoder = {
  //   use id <- decode.field(0, decode.int)
  //   use description <- decode.field(1, decode.optional(decode.string))
  //   use path <- decode.field(2, decode.optional(decode.string))
  //   use initials <- decode.field(3, decode.optional(decode.string))

  //   domain.Platform(id:, description:, path:, initials:)
  //   |> decode.success()
  // }

  // get_list(
  //   ctx.db,
  //   "select id, description, path, initials from technology",
  //   decoder,
  //   domain.to_json_platform,
  //   [],
  // )
}

pub fn customers(
  ctx: web.Context,
  req: request.Request(wisp.Connection),
) -> response.Response(wisp.Body) {
  todo
  // let decoder = {
  //   use id <- decode.field(0, decode.int)
  //   use name <- decode.field(1, decode.string)

  //   domain.Client(id:, name:)
  //   |> decode.success()
  // }

  // let assert Ok(ids) =
  //   shork.query(
  //     "SELECT id
  // 			FROM showcase.x_technology
  // 			WHERE technology_id = ?",
  //   )
  //   |> shork.parameter(shork.int(1))
  //   |> shork.returning({
  //     use id <- decode.field(0, decode.int)
  //     id
  //     |> decode.success()
  //   })
  //   |> shork.execute(ctx.db)
  //   |> result.map(fn(r) { r.rows })

  // let sql =
  //   "
  // SELECT distinct h.groupid AS id, replace(substring_index(substring_index(name,' - ',-1),'[',1),']','') AS name
  // 			FROM showcase.hosts_groups hg
  // 			INNER JOIN showcase.hosts_groups hg2 ON hg.hostid = hg2.hostid
  // 			INNER JOIN showcase.hstgrp h ON hg2.groupid = h.groupid
  // 			WHERE hg.groupid IN (?) and hg2.groupid NOT IN (?) AND h.name NOT LIKE '%[%' AND h.groupid != 292 AND h.groupid != 370
  // "

  // get_list(ctx.db, sql, decoder, domain.to_json_customer, [
  //   shork.int(110),
  //   shork.int(110),
  // ])
}

pub fn hosts(
  ctx: web.Context,
  req: request.Request(wisp.Connection),
) -> response.Response(wisp.Body) {
  todo
}

pub fn tipos_suporte(
  ctx: web.Context,
  req: request.Request(wisp.Connection),
) -> response.Response(wisp.Body) {
  todo
}

pub fn tipos_severidade(
  ctx: web.Context,
  req: request.Request(wisp.Connection),
) -> response.Response(wisp.Body) {
  todo
}

pub fn consultores(
  ctx: web.Context,
  req: request.Request(wisp.Connection),
) -> response.Response(wisp.Body) {
  todo
}

pub fn projeto_tipos(
  ctx: web.Context,
  req: request.Request(wisp.Connection),
) -> response.Response(wisp.Body) {
  todo
}

pub fn projeto_status(
  ctx: web.Context,
  req: request.Request(wisp.Connection),
) -> response.Response(wisp.Body) {
  todo
}

pub fn tecnologias_ssp(
  ctx: web.Context,
  req: request.Request(wisp.Connection),
) -> response.Response(wisp.Body) {
  todo
}

pub fn customers_ssp(
  ctx: web.Context,
  req: request.Request(wisp.Connection),
) -> response.Response(wisp.Body) {
  todo
}
