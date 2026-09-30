/**
 * Módulo c/ funções utilitárias.
 */
import {
  Result$Ok,
  Result$Error,
} from "./gleam.mjs";

import {
  toBitArray as toBitArrayInner
} from "../gleam_stdlib/gleam.mjs";

import {
  Option$Some,
  Option$None,
  unwrap as opt_unwrap
} from "../gleam_stdlib/gleam/option.mjs";

import {
  Uri$Uri,
} from "../gleam_stdlib/gleam/uri.mjs";

// PRIVATE ---------------------------------------------------------------------

const initial_location = globalThis?.window?.location?.href;
const storage = globalThis?.navigator?.storage

const unwrap = opt_unwrap
const toBitArray = (array) => toBitArrayInner(array);
const newOk = Result$Ok
const newError = Result$Error
const getError = (error) => error && error.message
  ? error.message
  : `${JSON.stringify(error)}`;

function checkNull(value, errMsg) {
  if (value !== null && value !== undefined) {
    return newOk(value);
  } else {
    return newError(errMsg + " : " + "Value is null");
  }
}

function maybe(cb, errMsg) {
  try {
    return newOk(cb());
  } catch (error) {
    return newError(errMsg + " : " + getError(error));
  }
}

async function maybeAsync(cb, errMsg) {
  try {
    return newOk(await cb());
  } catch (error) {
    return newError(errMsg, ":", getError(error));
  }
}

function maybeInstanceOf(obj, whatsInstanceOf, errMsg) {
  try {
    if (!whatsInstanceOf) {
      return newError(errMsg, "not found:", whatsInstanceOf);
    }

    if (!(obj instanceof whatsInstanceOf)) {
      return newError(errMsg, typeof obj, "not is of", whatsInstanceOf)
    }

    return newOk(obj);
  } catch (error) {
    return newError(errMsg, "instance of:" + getError(error));
  }
}

const uri_from_url = (url) => {
  return Uri$Uri(
    url.protocol
      ? Option$Some(url.protocol.slice(0, -1))
      : Option$None(),
    Option$None(),
    url.hostname ? Option$Some(url.hostname) : Option$None(),
    url.port ? Option$Some(Number(url.port)) : Option$None(),
    url.pathname,
    url.search
      ? Option$Some(url.search.slice(1))
      : Option$None(),
    url.hash ? Option$Some(url.hash.slice(1)) : Option$None(),
  );
};

// EXPORTS ---------------------------------------------------------------------

//
// -- Timeout
//

export function setTimeout(delay, callback) {
  return globalThis.setTimeout(callback, delay);
}

export function clearTimeout(timer) {
  globalThis.clearTimeout(timer);
}

//
// -- Env
//

/// Recupera o import.meta.env através da chave passada
export function getEnv(key) {
  try {
    if (import.meta && import.meta.env && import.meta.env[key]) {
      return newOk(import.meta.env[key]);
    }
    // if (process && process.env && process.env[key]) {
    //   return process.env[key];
    // }

    return newOk("http://localhost:8080");
  } catch (e) {
    return newError(undefined);
  }
}

//
// -- Window location
//

/// Recupera a uri.Uri inicial
export const do_initial_uri = () => {
  if (!initial_location) {
    return newError(undefined);
  } else {
    return newOk(uri_from_url(new URL(initial_location)));
  }
};

//
// -- Darkmode
//

/// Match media darkmode
export function matchMedia(selector) {
  return window.matchMedia(selector).matches
}

/// Add class darkmode
export function add_class(selector, toggleSelector) {
  document.querySelector(selector).classList.add(toggleSelector)
}

/// Remove class darkmode
export function remove_class(selector, toggleSelector) {
  document.querySelector(selector).classList.remove(toggleSelector)
}

/// Toggle class darkmode
export function toggle_class(selector, toggleSelector, force) {
  return document.querySelector(selector).classList.toggle(toggleSelector, unwrap(force, undefined))
}

//
// -- Storage
//

export function getStorage() {
  return maybe(() => {
    if (globalThis.StorageManager && storage instanceof StorageManager) {
      return storage
    } else {
      throw new Error("No available storage manager!")
    }
  }, "Error get storage")
}

export async function estimate(storageManager) {
  return await maybeAsync(async () => {
    const { quota, usage } = await storageManager.estimate()
    return [quota, usage]
  }, "Error estimate")
}

export async function getDirectory(storageManager) {
  return await maybeAsync(storageManager.getDirectory, "Error directory")
}

export async function persist(storageManager) {
  return await maybeAsync(storageManager.persist, "Error persist")
}

export async function persisted(storageManager) {
  return await maybeAsync(storageManager.persisted, "Error persisted")
}

export function localStorage() {
  try {
    return maybeInstanceOf(globalThis.localStorage, globalThis.Storage,
      "localStorage");
  } catch (error) {
    return newError("Error localStorage: " + String.toString(error));
  }
}

export function sessionStorage() {
  try {
    return maybeInstanceOf(globalThis.sessionStorage, globalThis.Storage,
      "sessionStorage");
  } catch (error) {
    return newError("Error sessionStorage: " + String.toString(error));
  }
}

export function length(storage) {
  return storage.length;
}

export function key(storage, index) {
  return checkNull(storage.key(index), index);
}

export function getItem(storage, keyName) {
  return checkNull(storage.getItem(keyName), keyName);
}

export function setItem(storage, keyName, keyValue) {
  return maybe(() => storage.setItem(keyName, keyValue),
    "Error set item ", "key:", keyName, "value:", keyValue);
}

export function removeItem(storage, keyName) {
  return maybe(() => storage.removeItem(keyName),
    "Error remove item ", "key:", keyName);
}

export function clear(storage) {
  return maybe(() => storage.clear(),
    "Error clear", typeof storage);
}
