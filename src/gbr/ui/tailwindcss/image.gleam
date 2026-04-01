////
//// UI tailwindcss image module
////

import gleam/function
import gleam/option.{type Option, None, Some}

import lustre/element as el

import gbr/ui/image

// Alias

pub const new = image.new

pub const with_alt = image.with_alt

///
///
pub fn view(src: String, alt: Option(String)) -> el.Element(msg) {
  image.new(src)
  |> case alt {
    Some(alt) -> image.with_alt(_, alt)
    None -> function.identity
  }
  |> image.to_element([])
}
