//// Associações ao armazenamento local e de sessão.

/// Um objeto de armazenamento (local ou de sessão).
///
/// - [https://developer.mozilla.org/en-US/docs/Web/API/Storage](https://developer.mozilla.org/en-US/docs/Web/API/Storage).
pub type Storage

/// Tenta obter o objeto de armazenamento local; falha se ele não estiver disponível.
@external(javascript, "../../../showcase_ffi.mjs", "localStorage")
pub fn local() -> Result(Storage, String)

/// Tenta obter o objeto de armazenamento da sessão; falha se ele não estiver disponível.
@external(javascript, "../../../showcase_ffi.mjs", "sessionStorage")
pub fn session() -> Result(Storage, String)

/// Retorna a quantidade de itens armazenados.
@external(javascript, "../../../showcase_ffi.mjs", "length")
pub fn length(storage: Storage) -> Int

/// /// Retorna a chave do item com o índice `index`, se existir.
@external(javascript, "../../../showcase_ffi.mjs", "key")
pub fn key(storage: Storage, index: Int) -> Result(String, String)

/// Retorna o item com a chave especificada, se ele existir.
@external(javascript, "../../../showcase_ffi.mjs", "getItem")
pub fn get_item(storage: Storage, key: String) -> Result(String, String)

/// Adiciona ou atualiza um item com a chave especificada. Se o armazenamento estiver cheio, um erro será retornado.
@external(javascript, "../../../showcase_ffi.mjs", "setItem")
pub fn set_item(
  storage: Storage,
  key: String,
  value: String,
) -> Result(Nil, String)

/// Remove um item com a chave especificada.
@external(javascript, "../../../showcase_ffi.mjs", "removeItem")
pub fn remove_item(storage: Storage, key: String) -> Result(Nil, String)

/// Limpa o armazenamento de todos os itens.
@external(javascript, "../../../showcase_ffi.mjs", "clear")
pub fn clear(storage: Storage) -> Result(Nil, String)
