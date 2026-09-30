////
//// 👮🏻‍♂️ GBR: UI Security Module
////
//// Olá, aqui temos o módulo de segurança jwt p/ nossa interface visual.
////
//// ## Uso
////
//// ```gleam
//// import gleam/io
////
//// import gbr/ui/security
////
//// pub fn main() {
////   use sec <- result.try(security.load("local.storage.key"))
////   use user = result.try(security.subject(sec))
////   use name = result.try(security.name(sec))
////   use mail = result.try(security.mail(sec))
////
////   io.println("Security user " <> user)
////   io.println("Security name " <> name)
////   io.println("Security mail " <> mail)
//// }
//// ```
////

import gleam/bool
import gleam/dynamic/decode
import gleam/float
import gleam/int
import gleam/option.{type Option, None, Some}
import gleam/order
import gleam/result
import gleam/time/duration
import gleam/time/timestamp

import gbr/ui/showcase/security/jwt
import gbr/ui/showcase/storage

// -----------------------------------------------------------------------------
//
// --- Tipos
//
// -----------------------------------------------------------------------------

/// Tipo opaco que encapsula a chave p/ armazenamento e o token (jwt).
///
/// - key: Chave de persistência no `localStorage`
/// - jwt: Token jwt
/// - refresh_timeout: Tempo para atualizar por um novo token, opicional.
///
pub opaque type Security {
  Security(key: String, jwt: jwt.Jwt, refresh_timeout: Option(Int))
}

/// Tipo de erros se segurança.
///
pub type SecurityError {
  ErrorExpired
  LoadError(String)
  PersistError(String)
  RemoveError(String)
  PermissionTargetEmpty
  PermissionOperationEmpty
  DecodeError(jwt.JwtError)
}

// -----------------------------------------------------------------------------
//
// -- Api
//
// -----------------------------------------------------------------------------

pub fn empty(key) -> Security {
  let jwt = jwt.empty()

  Security(key:, jwt:, refresh_timeout: None)
}

/// Cria um novo security transiente.
///
/// - key: Chave p/ armazenamento do token.
/// - token: Valor do token a ser armazenado.
/// - keep_logged: Se é para manter o usuário logado.
///
pub fn create(key, token, refresh_timeout) -> Result(Security, SecurityError) {
  use jwt <- result.map(
    jwt.from_string(token)
    |> result.map_error(DecodeError),
  )

  Security(key:, jwt:, refresh_timeout:)
}

/// **DO AUTH (TOKEN)**
///
/// Persiste o token no localStorage.
///
/// - key: Chave p/ armazenamento do token.
/// - token: Valor do token a ser armazenado.
/// - keep_logged: Se é para manter o usuário logado.
///
pub fn authenticate(
  key,
  token,
  refresh_timeout,
) -> Result(Security, SecurityError) {
  use security <- result.try(create(key, token, refresh_timeout))
  let Security(key:, jwt:, refresh_timeout:) = security

  use Nil <- result.try(save_token(key, jwt.to_string(jwt)))
  use Nil <- result.map(
    option.map(refresh_timeout, save_refresh_timeout(key, _))
    |> option.unwrap(Ok(Nil)),
  )

  Security(key:, jwt:, refresh_timeout:)
}

/// **DO LOGOUT (TOKEN)**
///
pub fn logout(security: Security) -> Result(Security, SecurityError) {
  use security <- result.try(load(security))

  remove(security)
}

/// **DO LOGOUT (TOKEN)**
///
/// key: Pela chave
///
pub fn logout_by_key(key) {
  use security <- result.try(load_by_key(key))

  logout(security)
}

/// Carrega o token do `localStorage` através dos dados de segurança transiente.
///
/// Esta função verifica se os token são iguais, senão é proíbida esta operação
/// por segurança.
///
pub fn load(security: Security) -> Result(Security, SecurityError) {
  let Security(key:, jwt:, ..) = security

  use security_loaded <- result.try(load_by_key(key))

  case jwt.compare(jwt, security.jwt) {
    order.Eq -> Ok(security_loaded)
    _ -> Error(LoadError("Forbidden"))
  }
}

/// Carrega o token através da chave no localStorage, se o token não estiver expirado.
///
/// - key: Chave p/ armazenamento do token.
///
/// Esta função testa se o token está expirado, se estiver ele é removido.
///
pub fn load_by_key(key: String) -> Result(Security, SecurityError) {
  use token <- result.try(load_token(key))
  let refresh_timeout =
    load_refresh_timeout(key)
    |> option.from_result()

  use security <- result.try(create(key, token, refresh_timeout))
  use expired <- result.try(expired(security))

  case expired <= 0 {
    False -> Ok(Security(..security, key:, refresh_timeout:))
    True -> {
      use _ <- result.try(remove(security))

      Error(ErrorExpired)
    }
  }
}

/// Verifica se é necessário atualizar o token novamente pela chave passada.
///
pub fn refresh_by_key(key) {
  use security <- result.try(load_by_key(key))

  refresh(security)
}

/// Verifica se é necessário realizar a atualização por um novo token.
///
pub fn refresh(security) {
  use check <- result.try(check_refresh(security))

  case check {
    False -> Ok(None)
    True -> {
      use security <- result.try(remove(security))
      let Security(jwt:, ..) = security
      let jwt = jwt.to_string(jwt)

      Some(jwt)
      |> Ok()
    }
  }
}

/// Altera se é para manter o usuário logado, atualizando o token.
///
pub fn with_refresh_timeout(security, refresh_timeout) {
  Security(..security, refresh_timeout: Some(refresh_timeout))
}

/// O sujeito é igual ao usuário passado?
///
/// - in: Security type
/// - user: Usuário p/ comparar com o `jwt.claim.sub`
///
pub fn is_owner(in: Security, user: String) -> Bool {
  {
    use sub <- result.map(subject(in))

    sub == user
  }
  |> result.unwrap(False)
}

/// Get payload claim info
///
/// - jwt: Jwt info
/// - key: Key into claim
/// - decode: How convert value
///
pub fn claim(
  security: Security,
  key: String,
  decode: decode.Decoder(a),
) -> Result(a, SecurityError) {
  let Security(jwt:, ..) = security

  jwt
  |> jwt.get_by_key(key, decode)
  |> result.map_error(DecodeError)
}

// -----------------------------------------------------------------------------
// --- Claim Helpers
// -----------------------------------------------------------------------------

/// Recupera o jwt `subject`
///
/// - in: Security type
///
pub fn subject(in: Security) -> Result(String, SecurityError) {
  let Security(jwt:, ..) = in

  jwt.subject(jwt)
  |> result.map_error(DecodeError)
}

pub fn audience(in) {
  let Security(jwt:, ..) = in

  jwt.audience(jwt)
  |> result.map_error(DecodeError)
}

pub fn issuer(in) {
  let Security(jwt:, ..) = in

  jwt.issuer(jwt)
  |> result.map_error(DecodeError)
}

pub fn issued_at(in) {
  let Security(jwt:, ..) = in

  jwt.issued_at(jwt)
  |> result.map_error(DecodeError)
}

/// Recupera o jwt `name`
///
/// - in: Security type
///
pub fn name(in: Security) -> Result(String, SecurityError) {
  claim(in, "name", decode.string)
}

/// Recupera o jwt `mail`
///
/// - in: Security type
///
pub fn mail(in: Security) -> Result(String, SecurityError) {
  claim(in, "mail", decode.string)
}

// -----------------------------------------------------------------------------
// --- Helpers
// -----------------------------------------------------------------------------

/// Retorna o token (jwt) em formato string
///
/// - in: Security type
///
pub fn to_string(in: Security) -> String {
  let Security(jwt:, ..) = in

  jwt.to_string(jwt)
}

/// Translate error to string
///
/// - err: Security error
///
pub fn error(err: SecurityError) -> String {
  case err {
    DecodeError(err) -> jwt.error_to_string(err)
    LoadError(err) -> "Loading " <> err
    PersistError(err) -> "Persisting " <> err
    RemoveError(err) -> "Removing " <> err
    PermissionTargetEmpty -> "Permission target is empty or null"
    PermissionOperationEmpty -> "Permission operation is empty or null"
    ErrorExpired -> "Expired token"
  }
}

// -----------------------------------------------------------------------------
//
// --- Auxiliares (Interno)
//
// -----------------------------------------------------------------------------

/// Realiza o logout do security passado, remove o item do `localStorage`.
///
fn remove(security) {
  let Security(key:, jwt:, ..) = security

  use db <- result.try(
    storage.local()
    |> result.map_error(PersistError),
  )

  use _ <- result.try(
    storage.remove_item(db, key)
    |> result.map_error(PersistError),
  )

  use _ <- result.map(
    storage.remove_item(db, refresh_timeout_key(key))
    |> result.map_error(PersistError),
  )

  Security(..security, key:, jwt:)
}

/// Retorna erro caso o token esteja expirado ou quantos segundos faltam.
///
/// - in: Security type
///
fn expired(in: Security) -> Result(Int, SecurityError) {
  let Security(jwt:, ..) = in

  use exp_jwt <- result.try(
    jwt.expiration(jwt)
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

/// Retorna se o token está no período válido p/ realizarmos um `refresh`.
///
/// - in: Security type
/// - duration_minutes: Tempo válido p/ `refresh` do token.
///
fn check_refresh(security) -> Result(Bool, SecurityError) {
  let Security(refresh_timeout:, ..) = security

  case refresh_timeout {
    None -> Ok(False)
    Some(refresh_timeout) -> {
      use diff <- result.map(expired(security))

      let refresh =
        duration.minutes(refresh_timeout)
        |> duration.to_seconds()
        |> float.truncate()

      diff > 0 && diff <= refresh
    }
  }
}

/// Carrega o token JWT a partir da chave passada, é ligo do `localStorage`.
///
fn load_token(key) {
  use db <- result.try(
    storage.local()
    |> result.map_error(LoadError),
  )

  use token <- result.map(
    storage.get_item(db, key)
    |> result.map_error(LoadError),
  )

  token
}

/// Carrega o dado se é para manter o usuário logado através da chave passada,
/// é lido do `localStorage`.
///
fn load_refresh_timeout(key) {
  use db <- result.try(
    storage.local()
    |> result.map_error(LoadError),
  )

  use refresh_timeout <- result.try(
    storage.get_item(db, refresh_timeout_key(key))
    |> result.map_error(LoadError),
  )

  use refresh_timeout <- result.map(
    int.parse(refresh_timeout)
    |> result.replace_error(LoadError(
      "Refresh timeout invalid, should be an integer.",
    )),
  )

  refresh_timeout
}

fn save_token(key, token) {
  use db <- result.try(
    storage.local()
    |> result.map_error(PersistError),
  )

  storage.set_item(db, key, token)
  |> result.map_error(PersistError)
}

fn save_refresh_timeout(key, refresh_timeout) {
  use db <- result.try(
    storage.local()
    |> result.map_error(PersistError),
  )

  storage.set_item(db, refresh_timeout_key(key), int.to_string(refresh_timeout))
  |> result.map_error(PersistError)
}

/// Retorna a chave que armazena (persiste) o dado sobre manter o usuário logado.
///
fn refresh_timeout_key(key) {
  key <> "keeplogged"
}
