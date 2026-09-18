////
////
////

import gleam/erlang/process
import gleam/io
import gleam/string

import server

/// Main Server
pub fn main() -> Nil {
  // Start
  case server.start(8080) {
    Ok(_started) -> process.sleep_forever()
    Error(err) ->
      io.println_error("GBR UI Showcase Server [ERROR] " <> string.inspect(err))
  }
}
