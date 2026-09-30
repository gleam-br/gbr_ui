////
//// GBR: UI Showcase Api module
////

import gleam/fetch
import gleam/http/request
import gleam/http/response
import gleam/javascript/promise
import gleam/uri

import gbr/ui/showcase/client

// -----------------------------------------------------------------------------
// --- API
// -----------------------------------------------------------------------------

pub fn create(uri: uri.Uri) -> client.Api {
  client.Handler(
    handle: new_handle(fetch_string),
    handle_bits: new_handle(fetch_bits),
  )
  |> client.new(uri, _)
}

// -----------------------------------------------------------------------------
// --- Handle `gleam_fetch`
// -----------------------------------------------------------------------------

/// Cria novo adaptador fetch handle p/ o client api
fn new_handle(fetch) {
  // retona high-order funtion contendo o adaptador
  fn(
    request: request.Request(String),
    on_response: fn(Result(response.Response(a), client.ApiError)) -> Nil,
  ) -> Nil {
    {
      use resp <- promise.await(fetch(request))

      case resp {
        Ok(resp) -> {
          Ok(resp)
          |> on_response()
          |> promise.resolve()
        }
        Error(err) -> {
          case err {
            fetch.NetworkError(reason) -> client.NetworkError(reason)
            fetch.UnableToReadBody -> client.UnableToReadBody
            fetch.InvalidJsonBody -> client.InvalidJsonBody
          }
          |> Error()
          |> on_response()
          |> promise.resolve()
        }
      }
    }

    Nil
  }
}

/// fetch req(string)->res(bit_array)
fn fetch_bits(request) {
  use resp <- promise.try_await(fetch.send(request))
  use resp <- promise.try_await(fetch.read_bytes_body(resp))

  promise.resolve(Ok(resp))
}

/// fetch req(string)->res(string)
fn fetch_string(request) {
  use resp <- promise.try_await(fetch.send(request))
  use resp <- promise.try_await(fetch.read_text_body(resp))

  promise.resolve(Ok(resp))
}
