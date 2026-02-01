/***
 * @module env_ffi
 */

import {
  Result$Ok,
  Result$Error
} from "../../../../prelude.mjs"

/**
 * Get environment var from 'import.meta.env'
 *
 * @param {String} name Environment key name
 * @returns Result(String, Nil) with Ok(env_value) or error not found.
 */
export function getMetaEnv(name) {
  const hasEnv = !!import.meta && !!import.meta.env && !!import.meta.env[name]
  const env = import.meta.env[name]

  if (
    hasEnv
    && env !== undefined
    && env != null
    && typeof env === "string"
    && env.trim() !== ""
  ) {
    return Result$Ok(env)
  }

  return Result$Error(undefined)
}
