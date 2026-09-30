////
//// GBR: UI Showcase Log
////

import gleam/io

const const_log_prefix = "Showcase: "

pub opaque type Log {
  Log(level: Level)
}

pub type Level {
  Debug
  Info
  Warn
  Error
}

pub fn new(level) {
  Log(level:)
}

pub fn debug(log, msg) {
  let Log(level:) = log
  case level {
    Debug -> format_consume(msg, io.println)
    _ -> Nil
  }
}

pub fn info(log, msg) {
  let Log(level:) = log
  case level {
    Info -> format_consume(msg, io.println)
    _ -> Nil
  }
}

pub fn warn(log, msg) {
  let Log(level:) = log
  case level {
    Warn -> format_consume("[WARN] " <> msg, io.println)
    _ -> Nil
  }
}

pub fn error(log, msg) {
  let Log(level:) = log
  case level {
    Error -> format_consume(msg, io.println_error)
    _ -> Nil
  }
}

fn format_consume(msg, consume: fn(String) -> Nil) {
  consume(const_log_prefix <> msg)
}
