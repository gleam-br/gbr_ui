////
//// 🔗 Api json using rsvp lib
////

import gleam/bit_array
import gleam/dynamic/decode
import gleam/http
import gleam/http/request
import gleam/int
import gleam/json
import gleam/list
import gleam/option.{type Option, None}
import gleam/pair
import gleam/result
import gleam/string
import gleam/uri

import rsvp

import lustre/effect

import gbr/js/jscore

import gbr/ui/env

// Alias
//

type Method =
  http.Method

type Header =
  #(String, String)

type Error =
  rsvp.Error

type OnData(a, b) =
  fn(Result(a, Error)) -> b

type Headers =
  List(Header)

/// Api http request type
///
/// > Only request json body
///
/// - uri: Uri to request
/// - url: Uri to request
/// - path: Uri path to request
/// - method: Http methods
/// - headers: Header http
/// - body: Option of body in json
///
pub opaque type Api {
  Api(
    uri: uri.Uri,
    path: String,
    query: List(#(String, String)),
    method: Method,
    headers: Headers,
    body: Option(json.Json),
  )
}

/// New api client with empty uri
///
pub fn new() -> Api {
  let uri = uri_base()
  let path = uri.path
  let query = []
  let method = http.Get
  let headers = [#(const_header_content_type, const_header_content_type_json)]

  Api(uri:, path:, query:, method:, headers:, body: None)
}

/// Send api request raw string
///
pub fn send_text(in: Api, ondata: OnData(String, b)) -> effect.Effect(b) {
  let Api(uri:, path:, query:, method:, headers:, body:) = in

  let handler =
    rsvp.expect_ok_response(fn(res) {
      let res = result.map(res, fn(res) { res.body })

      ondata(res)
    })

  send_(uri, path, query, method, body, headers, handler)
}

/// Send api request raw bytes
///
pub fn send_bytes(in: Api, ondata: OnData(BitArray, b)) -> effect.Effect(b) {
  let Api(uri:, path:, query:, method:, headers:, body:) = in

  let handler =
    rsvp.expect_ok_response(fn(res) {
      let res =
        res
        |> result.map(fn(res) {
          res.body
          |> bit_array.from_string
        })

      ondata(res)
    })

  send_(uri, path, query, method, body, headers, handler)
}

/// Send api request json
///
pub fn send(
  in: Api,
  ondata: OnData(a, b),
  decoder: decode.Decoder(a),
) -> effect.Effect(b) {
  let Api(uri:, path:, query:, method:, headers:, body:) = in
  let handler = rsvp.expect_json(decoder, ondata)

  send_(uri, path, query, method, body, headers, handler)
}

/// Set method to api request header
///
pub fn method(in: Api, method: http.Method) -> Api {
  Api(..in, method:)
}

/// Set body to api request
///
pub fn body(in: Api, body: json.Json) -> Api {
  Api(..in, body: option.Some(body))
}

/// Set path to api
///
pub fn path(in: Api, path: String) -> Api {
  let Api(uri:, ..) = in
  let path = uri.path <> path

  Api(..in, path:)
}

/// Set query params to api
///
pub fn query(in: Api, query: List(#(String, String))) -> Api {
  Api(..in, query:)
}

pub fn error(err: rsvp.Error) -> String {
  case err {
    rsvp.BadBody ->
      "Bad body\nThis error can happen when we successfully receive an HTTP "
      <> "response but the body of the response is invalid or not well-formed."
    rsvp.BadUrl(url) ->
      "Bad url="
      <> url
      <> "\nThis error can happen when the URL string provided to the get or "
      <> "post helpers is not well-formed."
    rsvp.NetworkError ->
      "Network error not connect to server"
      <> "\nThis error can happen when the HTTP request fails to connect to the "
      <> "server or there is some other connectivity issue."
    rsvp.HttpError(r) ->
      "HTTP Error status="
      <> int.to_string(r.status)
      <> "\nThis error can happen when the HTTP response status code is not in "
      <> "the 2xx range but a handler expected it to be."
    rsvp.UnhandledResponse(r) ->
      "Unhandled Response status="
      <> int.to_string(r.status)
      <> "\nThis error can be returned by a handler when it does not know how "
      <> "to handle a response. For example, the expect_json handler will "
      <> "return this error if the response content-type is not 'application/json'\n"
      <> "\nHeaders:\n"
      <> r.headers
      |> list.map(fn(header) {
        "- " <> pair.first(header) <> ":" <> pair.second(header)
      })
      |> string.join("\n")
    rsvp.JsonError(e) ->
      error_json(e)
      <> "\nThis error is returned when decoding a JSON response body fails."
  }
}

/// Set authorization header with Bearer token
///
pub fn authorization(in: Api, token: String) -> Api {
  let token = const_header_auth_prefix <> token
  let token = #(const_header_auth, token)

  Api(..in, headers: [token, ..in.headers])
}

// PRIVATE
//

// TODO How make dynamic arg env name
const const_url_base = "VITE_API_BASE_URL"

const const_header_content_type = "Content-Type"

const const_header_content_type_json = "application/json"

const const_header_auth = "Authorization"

const const_header_auth_prefix = "Bearer "

fn uri_base() {
  let default =
    jscore.global()
    |> jscore.get_object_inner_key("location", "origin")
    |> option.map(uri.parse)
    |> option.map(option.from_result)
    |> option.flatten()
    |> option.unwrap(uri.empty)

  env.get_meta_env(const_url_base)
  |> option.map(uri.parse)
  |> option.map(option.from_result)
  |> option.flatten()
  |> option.unwrap(default)
}

fn send_(uri, path, query, method, body, headers, handler) -> effect.Effect(b) {
  let assert Ok(req) = request.from_uri(uri)

  let req =
    body
    |> option.map(json.to_string)
    |> option.map(request.set_body(req, _))
    |> option.unwrap(req)

  // send
  req
  |> request.set_path(path)
  |> request.set_query(query)
  |> request.set_method(method)
  |> set_headers(headers)
  |> rsvp.send(handler)
}

fn set_headers(req, headers: Headers) {
  case headers {
    [] -> req
    [first, ..rest] ->
      request.set_header(req, first.0, first.1)
      |> set_headers(rest)
  }
}

fn error_json(err: json.DecodeError) -> String {
  case err {
    json.UnexpectedEndOfInput -> "Json unexpected end of input"
    json.UnexpectedByte(byte) -> "Json unexpected byte " <> byte
    json.UnexpectedSequence(seq) -> "Json unexpected sequence " <> seq
    json.UnableToDecode(dec_errors) ->
      "Json error unable to decode:\n"
      <> {
        use er <- list.map(dec_errors)
        "Expected: "
        <> er.expected
        <> " Found: "
        <> er.found
        <> ": "
        <> string.join(er.path, ",")
      }
      |> string.join("\n")
  }
}
// fn to_uri(uri_string: String) -> Result(uri.Uri, rsvp.Error) {
//   case uri_string {
//     "./" <> _ | "../" <> _ -> rsvp.parse_relative_uri(uri_string)
//     _ -> uri.parse(uri_string)
//   }
//   |> result.replace_error(rsvp.BadUrl(uri_string))
// }
