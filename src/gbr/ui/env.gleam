////
//// Manager from import.meta.env vars
////

import gleam/option.{type Option}

/// Get import.meta.env[name]
///
/// - name: Env name
///
pub fn get_meta_env(name: String) -> Option(String) {
  get_meta_env_ffi(name)
  |> option.from_result()
}

// PRIVATE
//

@external(javascript, "./env/env_ffi.mjs", "getMetaEnv")
fn get_meta_env_ffi(name: String) -> Result(String, Nil)
