////
////
////

import gleam/erlang/process
import gleam/io
import gleam/string

import server

/// Main Falcon Admin Server
pub fn main() -> Nil {
  // Start falcon admin server
  case server.start(8080) {
    Ok(_started) -> process.sleep_forever()
    Error(err) ->
      io.println_error(
        "Horus Falcon Admin Server [ERROR] " <> string.inspect(err),
      )
  }
}
