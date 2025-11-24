////
//// Gleam UI admin logo super element.
////

import gbr/ui/logo

import gbr/ui/core/model.{type UIRender}

/// Logo element admin with primary layout.
///
pub fn primary(logo: logo.UILogo) -> UIRender(a) {
  logo.class(logo, "logo")
  |> logo.class_small("logo-icon")
  |> logo.render()
}
