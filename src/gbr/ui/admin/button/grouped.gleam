////
////
////

import gleam/list

import lustre/attribute as a

import gbr/ui/button
import gbr/ui/core/model.{type UIRender}

// Alias
//

type Render(a) =
  button.UIButtonRender(a)

type Grouped {
  Primary
  Secondary
  Terciary
}

pub fn primary(buttons: List(Render(a))) -> UIRender(a) {
  view(buttons, Primary)
}

pub fn secondary(buttons: List(Render(a))) -> UIRender(a) {
  view(buttons, Secondary)
}

pub fn terciary(buttons: List(Render(a))) -> UIRender(a) {
  view(buttons, Terciary)
}

// PRIVATE
//

const const_primary_class = "inline-flex items-center shadow-theme-xs"

const const_secondary_class = "hidden h-11 items-center gap-0.5 rounded-lg bg-gray-100 p-0.5 lg:inline-flex dark:bg-gray-900"

/// View render buttons grouped.
///
fn view(buttons: List(Render(a)), grouped: Grouped) -> UIRender(a) {
  let class = case grouped {
    Primary -> const_primary_class
    Secondary -> const_secondary_class
    Terciary -> const_secondary_class
  }
  let length = list.length(buttons)
  let buttons = {
    use btn, i <- list.index_map(buttons)

    let attrs = case i {
      0 -> [a.class(class)]
      //TODO
      x if x == length -> []
      _ -> [a.class("-ml-px " <> class)]
    }

    #(attrs, btn)
  }

  button.grouped(buttons, [a.class(class)])
}
