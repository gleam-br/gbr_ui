////
//// GBR: UI Showcase Server Module
////

import gleam/erlang/application

import mist
import wisp
import wisp/wisp_mist

import server/repository/db
import server/router
import server/web

pub fn start(port: Int) {
  wisp.configure_logger()

  let secret_key_base = wisp.random_string(64)
  let assert Ok(priv) = application.priv_directory("gbr_ui_showcase_server")

  // A database creation is created here, when the program starts.
  // This connection is used by all requests.
  let db = db.new()

  // A context is constructed to hold the database connection.
  let context = web.Context(db:, priv:)

  //  db:
  // The handle_request function is partially applied with the context to make
  // the request handler function that only takes a request.
  let handler = router.handle_request(_, context)

  handler
  |> wisp_mist.handler(secret_key_base)
  |> mist.new
  |> mist.port(port)
  |> mist.start
}
