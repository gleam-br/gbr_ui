////
//// Falcon admin security module
////

import gleam/bool
import gleam/dict
import gleam/dynamic/decode
import gleam/float
import gleam/order
import gleam/result
import gleam/time/duration
import gleam/time/timestamp

import gbr/js/jsstorage as storage
import gbr/shared/jwt

pub opaque type SecurityError {
  ErrorExpired
  LoadError(String)
  PersistError(String)
  RemoveError(String)
  PermissionTargetEmpty
  PermissionOperationEmpty
  DecodeError(jwt.JwtDecodeError)
}

type Permissions =
  dict.Dict(String, List(String))

/// Security type
///
/// Wrapper to `gbr_shared/jwt.Jwt`
///
pub opaque type Security {
  Security(jwt.Jwt)
}

/// Load token jwt from localStorage, if token is not expired.
///
pub fn load(storage_key: String) -> Result(Security, SecurityError) {
  use db <- result.try(
    storage.local()
    |> result.map_error(LoadError),
  )
  use token <- result.try(
    storage.get_item(db, storage_key)
    |> result.map_error(LoadError),
  )
  use jwt <- result.try(
    jwt.from_string(token)
    |> result.map_error(DecodeError),
  )

  let security = Security(jwt)

  use expired <- result.try(expired(security))

  case expired <= 0 {
    True -> Error(ErrorExpired)
    False -> Ok(security)
  }
}

/// Is in refresh token period
///
/// - in: Security type
/// - duration_minutes: Refresh only in period duration minutes
///
pub fn refresh(
  in: Security,
  duration_minutes: Int,
) -> Result(Bool, SecurityError) {
  use diff <- result.map(expired(in))

  let refresh =
    duration.minutes(duration_minutes)
    |> duration.to_seconds()
    |> float.truncate()

  diff > 0 && diff <= refresh
}

/// Is token expired, return in seconds when expired.
///
/// If zero or negative the token expired
///
/// - in: Security type
///
pub fn expired(in: Security) -> Result(Int, SecurityError) {
  let Security(jwt) = in

  use exp_jwt <- result.try(
    jwt.get_expiration(jwt)
    |> result.map_error(DecodeError),
  )
  let now = timestamp.system_time()
  let exp = timestamp.from_unix_seconds(exp_jwt)

  use <- bool.guard(
    timestamp.compare(now, exp) == order.Gt,
    Error(ErrorExpired),
  )

  timestamp.difference(now, exp)
  |> duration.to_seconds()
  |> float.truncate()
  |> Ok()
}

/// Persist token jwt in localStorage
///
pub fn persist(
  jwt: String,
  storage_key: String,
) -> Result(Security, SecurityError) {
  use jwt <- result.try(
    jwt.from_string(jwt)
    |> result.map_error(DecodeError),
  )

  use db <- result.try(
    storage.local()
    |> result.map_error(PersistError),
  )
  use _ <- result.map(
    storage.set_item(db, storage_key, jwt.to_string(jwt))
    |> result.map_error(PersistError),
  )

  Security(jwt)
}

/// Remove token jwt in localStorage
///
pub fn remove(storage_key: String) -> Result(Nil, SecurityError) {
  use db <- result.try(
    storage.local()
    |> result.map_error(PersistError),
  )
  use _ <- result.map(
    storage.remove_item(db, storage_key)
    |> result.map_error(PersistError),
  )

  Nil
}

// ACCESSORS
//

/// Get jwt subject
///
pub fn subject(in: Security) -> Result(String, SecurityError) {
  let Security(jwt) = in

  jwt.get_subject(jwt)
  |> result.map_error(DecodeError)
}

/// Get jwt name
///
pub fn name(in: Security) -> Result(String, SecurityError) {
  let Security(jwt) = in

  claim(jwt, "name", decode.string)
}

pub fn mail(in: Security) -> Result(String, SecurityError) {
  let Security(jwt) = in

  claim(jwt, "mail", decode.string)
}

pub fn department(in: Security) -> Result(String, SecurityError) {
  let Security(jwt) = in

  claim(jwt, "department", decode.string)
}

pub fn technologies(in: Security) -> Result(List(Int), SecurityError) {
  let Security(jwt) = in

  claim(jwt, "technologies", decode.list(of: decode.int))
}

/// Get permissions dictonary
///
/// Returns:
/// - id: Id of access
/// - list: Permissions string labeled, e.g., "ADM"
///
pub fn permissions(in: Security) -> Result(Permissions, SecurityError) {
  let Security(jwt) = in

  claim(
    jwt,
    "permissions",
    decode.dict(decode.string, decode.list(decode.string)),
  )
}

/// Is jwt subject owner matching user arg
///
pub fn is_owner(in: Security, user: String) -> Result(Bool, SecurityError) {
  let Security(jwt) = in

  use sub <- result.map(
    jwt.get_subject(jwt)
    |> result.map_error(DecodeError),
  )
  sub == user
}

/// Translate error to string
///
pub fn error(err: SecurityError) -> String {
  case err {
    DecodeError(err) -> jwt.error(err)
    LoadError(err) -> "Loading " <> err
    PersistError(err) -> "Persisting " <> err
    RemoveError(err) -> "Removing " <> err
    PermissionTargetEmpty -> "Permission target is empty or null"
    PermissionOperationEmpty -> "Permission operation is empty or null"
    ErrorExpired -> "Expired token"
  }
}

pub fn to_string(in: Security) -> String {
  let Security(jwt) = in

  jwt.to_string(jwt)
}

/// Get payload claim info
///
/// - jwt: Jwt info
/// - key: Key into claim
/// - decode: How convert value
///
pub fn claim(
  jwt: jwt.Jwt,
  key: String,
  decode: decode.Decoder(a),
) -> Result(a, SecurityError) {
  jwt
  |> jwt.get_payload_claim(key, decode)
  |> result.map_error(DecodeError)
}
