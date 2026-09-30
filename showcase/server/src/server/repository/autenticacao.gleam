////
////
////
////

import gleam/dynamic/decode
import gleam/float
import gleam/int
import gleam/json
import gleam/list
import gleam/time/timestamp

import gwt
import wisp

import server/web

pub fn login(_ctx: web.Context, req: wisp.Request) -> wisp.Response {
  // verify format
  use json <- wisp.require_json(req)

  let decoder = {
    use user <- decode.field("user", decode.string)
    use password <- decode.field("password", decode.string)

    #(user, password)
    |> decode.success()
  }

  // verify data
  let assert Ok(#(user, password)) = decode.run(json, decoder)

  echo user
  echo password

  let token = new_token()
  wisp.json_response(token, 200)
}

pub fn refresh(
  _ctx: web.Context,
  req: wisp.Request,
  _rest: List(String),
) -> wisp.Response {
  let assert Ok(_token) =
    wisp.get_query(req)
    |> list.key_find("token")

  let token = new_token()
  wisp.json_response(token, 200)
}

fn new_token() {
  let now =
    timestamp.system_time()
    |> timestamp.to_unix_seconds()
    |> float.truncate()

  let jwt =
    gwt.new()
    |> gwt.set_subject("paulo.sales")
    |> gwt.set_audience("GTDEV")
    |> gwt.set_payload_claim("name", json.string("Paulo R. A. Sales"))
    |> gwt.set_payload_claim("mail", json.string("contato@gleam.dev.br"))
    |> gwt.set_payload_claim("avatar", json.string("/profile.png"))
    |> gwt.set_not_before(now + 30_000)
    |> gwt.set_expiration(now + 36_000)
    |> gwt.set_jwt_id(int.random(100_000_000) |> int.to_string())

  gwt.to_string(jwt)
}
