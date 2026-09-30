////
//// 🔗 GBR: UI Showcase Client Http Module
////

import gleam/dynamic/decode
import gleam/http
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/json
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/uri

// -----------------------------------------------------------------------------
// Alias
// -----------------------------------------------------------------------------

type Param =
  #(String, String)

type Params =
  List(Param)

type ApiResponse =
  Result(Response(String), ApiError)

type ApiResponseBits =
  Result(Response(BitArray), ApiError)

type HandleResponse =
  fn(ApiResponse) -> Nil

type HandleResponseBits =
  fn(ApiResponseBits) -> Nil

// -----------------------------------------------------------------------------
// -- Tipos principais
// -----------------------------------------------------------------------------

/// Tipo que representa uma requisição a api e como deve ser o retorno.
///
/// Este tipo abstrai a implementação de fato da requisição ao servidor.
/// - Podemos utilizar esta biblioteca no javascript usando o `fetch`.
/// - Podemos utilizar esta biblioteca no erlang usando o `httpc`.
pub type Handler {
  Handler(
    handle: fn(Request(String), HandleResponse) -> Nil,
    handle_bits: fn(Request(String), HandleResponseBits) -> Nil,
  )
}

/// Tipo que representa os possíveis erros
pub type ApiError {
  InvalidUri(Nil)
  InvalidStatus(Int)
  InvalidJsonDecode(json.DecodeError)
  InvalidJsonBody
  UnableToReadBody
  NetworkError(String)
  Unauthorized
  Forbideen
  Unknown(String)
}

/// Api http request type
///
/// > Somente p/ requisições Json
///
/// - uri: Uri request
/// - path: Uri path to request
/// - method: Http methods
/// - headers: Header http
/// - body: Option body (em json)
///
pub opaque type Api {
  Builder(
    uri: uri.Uri,
    path: String,
    query: Params,
    method: http.Method,
    headers: Params,
    body: Option(json.Json),
    handler: Handler,
  )
}

// -----------------------------------------------------------------------------
// --- Builder
// -----------------------------------------------------------------------------

/// New api client with empty uri
pub fn new(uri: uri.Uri, handler: Handler) -> Api {
  let path = uri.path
  let method = http.Get
  let query = []
  let headers = []

  Builder(uri:, path:, query:, method:, headers:, body: None, handler:)
}

/// Insere o método http na requisição
pub fn with_method(in: Api, method: http.Method) -> Api {
  Builder(..in, method:)
}

/// Insere a o path da uri na requisição
pub fn with_path(in: Api, path: String) -> Api {
  Builder(..in, path:)
}

/// Insere os parâmetros de query p/ a requisição
pub fn with_query_params(in: Api, query: Params) -> Api {
  Builder(..in, query:)
}

/// Insere a o corpo json na requisição
pub fn with_json(in: Api, body: json.Json) -> Api {
  Builder(..in, body: Some(body))
}

/// Insere os parâmetros de query p/ a requisição
pub fn with_headers(in: Api, headers: Params) -> Api {
  Builder(..in, headers:)
}

// -----------------------------------------------------------------------------
// --- Helpers
// -----------------------------------------------------------------------------

/// Helper p/ incluir o header content-type: applicaton-json
pub fn new_header_content_type_json() -> #(String, String) {
  #(const_header_content_type, const_header_content_type_json)
}

/// Helper p/ incluir o header authorization: bearer <jwt>
pub fn new_header_authorization(jwt: String) -> #(String, String) {
  #(const_header_auth, const_header_auth_prefix <> jwt)
}

/// Helper p/ incluir o header authorization: bearer <jwt>
pub fn new_header_authorization_custom(
  header_auth_key: String,
  jwt: String,
) -> #(String, String) {
  #(header_auth_key, const_header_auth_prefix <> jwt)
}

/// Helper que encapsula a resposta da api em uma função callback
pub fn response_ok_bits(on_response: fn(Result(BitArray, ApiError)) -> Nil) {
  fn(response: ApiResponseBits) {
    response_unwrap_bits(response)
    |> on_response()
  }
}

/// Helper que encapsula a resposta em bytes da api em uma função callback
pub fn response_ok(
  decode: decode.Decoder(b),
  on_response: fn(Result(b, ApiError)) -> Nil,
) {
  fn(response: ApiResponse) {
    response_unwrap(response, decode)
    |> on_response()
  }
}

// -----------------------------------------------------------------------------
// -- Api
// -----------------------------------------------------------------------------

/// Send request p/ a Api.
pub fn send(in: Api, response: HandleResponse) -> Nil {
  let Builder(uri:, path:, query:, method:, headers:, body:, handler:) = in

  let send = fn(req) {
    body
    |> option.map(json.to_string)
    |> option.map(request.set_body(req, _))
    |> option.unwrap(req)
    |> request.set_path(path)
    |> request.set_query(query)
    |> request.set_method(method)
    |> set_headers(headers)
    |> handler.handle(response)
  }

  // new request from uri
  let req =
    request.from_uri(uri)
    |> result.map_error(InvalidUri)

  case req {
    Ok(req) -> send(req)
    Error(err) -> response(Error(err))
  }
}

/// Send request api e retorno em BitArray
pub fn send_bytes(in: Api, response: HandleResponseBits) -> Nil {
  let Builder(uri:, path:, query:, method:, headers:, body:, handler:) = in

  let send = fn(req) {
    body
    |> option.map(json.to_string)
    |> option.map(request.set_body(req, _))
    |> option.unwrap(req)
    |> request.set_path(path)
    |> request.set_query(query)
    |> request.set_method(method)
    |> set_headers(headers)
    |> handler.handle_bits(response)
  }

  // new request from uri
  let req =
    request.from_uri(uri)
    |> result.map_error(InvalidUri)

  case req {
    Ok(req) -> send(req)
    Error(err) -> response(Error(err))
  }
}

// -----------------------------------------------------------------------------
// --- Constantes
// -----------------------------------------------------------------------------

const const_header_content_type: String = "Content-Type"

const const_header_content_type_json: String = "application/json"

const const_header_auth: String = "Authorization"

const const_header_auth_prefix: String = "Bearer "

// -----------------------------------------------------------------------------
// --- Funções auxiliares
// -----------------------------------------------------------------------------

fn set_headers(req: Request(a), headers: Params) -> Request(a) {
  case headers {
    [] -> req
    [first, ..rest] ->
      request.set_header(req, first.0, first.1)
      |> set_headers(rest)
  }
}

fn response_unwrap(
  response: ApiResponse,
  decode: decode.Decoder(b),
) -> Result(b, ApiError) {
  use response <- result.try(response)

  case response {
    response if response.status == 200 || response.status == 201 -> {
      json.parse(response.body, decode)
      |> result.map_error(InvalidJsonDecode)
    }
    response -> Error(InvalidStatus(response.status))
  }
}

fn response_unwrap_bits(response: ApiResponseBits) {
  use response <- result.try(response)

  case response {
    response if response.status == 200 || response.status == 201 -> {
      Ok(response.body)
    }
    response -> Error(InvalidStatus(response.status))
  }
}
