////
//// 🔑 GBR: UI Showcase JWT module
////
//// Olá, estamos no módulo para tratarmos o Json Web Token de segurança da
//// nossa interface visual.
////
//// ## Uso
////
//// ```gleam
////
//// import gbr/ui/showcase/security/jwt
////
//// let assert empty = jwt.empty()
//// let assert Ok(from_str) = jwt.from_string("....")
//// let assert Ok(from_bits) = jwt.from_bit_array(<<...>>)
////
//// let assert Ok(issuer) = jwt.issuer(from_bits)
//// let assert Ok(subject) = jwt.subject(from_bits)
//// let assert Ok(id) = jwt.id(from_bits)
////
//// let jwt_str = jwt.to_string(jwt)
////
//// ```
////

import gleam/bit_array
import gleam/bool
import gleam/dict.{type Dict}
import gleam/dynamic/decode.{type DecodeError, type Decoder, type Dynamic}
import gleam/json
import gleam/list
import gleam/option.{type Option}
import gleam/result
import gleam/string

//
// ----- Tipos
//

/// Tipo opaco contendo informações sobre o token.
///
pub opaque type Jwt {
  Jwt(
    raw: String,
    header: Dict(String, Dynamic),
    payload: Dict(String, Dynamic),
  )
}

/// Tipo que representa os erros na tentativa de decodificar o token, etc.
///
pub type JwtError {
  TokenEmpty
  HeaderEmpty
  HeaderInvalid
  PayloadEmpty
  PayloadInvalid
  ClaimEmpty
  ClaimNotFound(String)
  ClaimInvalid(List(DecodeError))
}

//
// ----- Contrutores
//

pub fn empty() {
  Jwt(raw: "", header: dict.new(), payload: dict.new())
}

/// Constroi um token a partir de uma string.
///
/// - raw: JWT representado em formato `String´.
///
pub fn from_string(raw: String) -> Result(Jwt, JwtError) {
  use <- bool.guard(string.is_empty(raw), Error(TokenEmpty))

  use #(header, payload, _) <- result.map(parts(raw))

  Jwt(raw:, header:, payload:)
}

/// Constroi um token a partir de um binário.
///
pub fn from_bit_array(bit: BitArray) -> Result(Jwt, JwtError) {
  use raw <- result.try(
    bit_array.to_string(bit)
    |> result.replace_error(PayloadInvalid),
  )

  from_string(raw)
}

/// Recupera o token em formato `String`.
///
pub fn to_string(in: Jwt) -> String {
  in.raw
}

//
// ----- Getter
//

/// Recupera o `iss`.
///
pub fn issuer(from jwt: Jwt) -> Result(String, JwtError) {
  get_by_key(jwt, "iss", decode.string)
}

/// Recupera `sub`.
///
pub fn subject(from jwt: Jwt) -> Result(String, JwtError) {
  get_by_key(jwt, "sub", decode.string)
}

/// Recupera `aud`.
///
pub fn audience(from jwt: Jwt) -> Result(String, JwtError) {
  get_by_key(jwt, "aud", decode.string)
}

/// Recupera `jti`.
///
pub fn id(from jwt: Jwt) -> Result(String, JwtError) {
  get_by_key(jwt, "jti", decode.string)
}

/// Recupera `iat`.
///
pub fn issued_at(from jwt: Jwt) -> Result(Int, JwtError) {
  get_by_key(jwt, "iat", decode.int)
}

/// Recupera `nbf`.
///
pub fn not_before(from jwt: Jwt) -> Result(Int, JwtError) {
  get_by_key(jwt, "nbf", decode.int)
}

/// Recupera `exp`.
///
pub fn expiration(from jwt: Jwt) -> Result(Int, JwtError) {
  get_by_key(jwt, "exp", decode.int)
}

/// Recupera e decodifica `claim`.
///
pub fn get_by_key(
  from jwt: Jwt,
  claim claim: String,
  decoder decoder: Decoder(a),
) -> Result(a, JwtError) {
  use claim_value <- result.try(
    jwt.payload
    |> dict.get(claim)
    |> result.replace_error(ClaimEmpty),
  )

  decode.run(claim_value, decoder)
  |> result.map_error(ClaimInvalid)
}

//
// ----- Helper
//

/// Compara dois tokens jwt.
///
pub fn compare(jwt1, jwt2) {
  let token1 = to_string(jwt1)
  let token2 = to_string(jwt2)

  string.compare(token1, token2)
}

/// Traduz o erro em formato `String`.
///
pub fn error_to_string(err: JwtError) {
  case err {
    TokenEmpty -> "Token string is empty or null"
    HeaderEmpty -> "Header is empty or null"
    HeaderInvalid -> "Header is invalid"
    PayloadEmpty -> "Payload is empty or null"
    PayloadInvalid -> "Payload is invalid"
    ClaimEmpty -> "Claim is empty or null"
    ClaimNotFound(name) -> "Claim not found " <> name
    ClaimInvalid(list_dec_error) -> {
      let dec_errors =
        list.map(list_dec_error, fn(dec_error) {
          "Expected: " <> dec_error.expected <> "Found: " <> dec_error.found
        })
      "Claim is invalid: " <> string.join(dec_errors, "\n")
    }
  }
}

//
// ----- Private
//

fn parts(
  jwt_string: String,
) -> Result(
  #(Dict(String, Dynamic), Dict(String, Dynamic), Option(String)),
  JwtError,
) {
  let parts = string.split(jwt_string, ".")

  use encoded_header <- result.try(
    list.first(parts)
    |> result.replace_error(HeaderEmpty),
  )

  let parts = list.drop(parts, 1)

  use header_string <- result.try(
    encoded_header
    |> bit_array.base64_url_decode()
    |> result.try(bit_array.to_string)
    |> result.replace_error(HeaderInvalid),
  )

  use header <- result.try(
    header_string
    |> json.parse(decode.dict(decode.string, decode.dynamic))
    |> result.replace_error(HeaderInvalid),
  )

  use encoded_payload <- result.try(
    list.first(parts)
    |> result.replace_error(PayloadEmpty),
  )

  let parts = list.drop(parts, 1)

  use payload_string <- result.try(
    encoded_payload
    |> bit_array.base64_url_decode()
    |> result.try(bit_array.to_string)
    |> result.replace_error(PayloadInvalid),
  )

  use payload <- result.map(
    json.parse(payload_string, decode.dict(decode.string, decode.dynamic))
    |> result.replace_error(PayloadInvalid),
  )

  let signature =
    parts
    |> list.first()
    |> option.from_result()

  #(header, payload, signature)
}
