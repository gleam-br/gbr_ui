//// Internal Tailwind class bucket-sorting helper for `gbr/ui/lustre`.

import gleam/list
import gleam/string

type Buckets {
  Buckets(
    layout: List(String),
    sizing: List(String),
    typography: List(String),
    colors: List(String),
    states: List(String),
    other: List(String),
  )
}

pub fn sort_class_strings(all_classes: List(String)) -> String {
  let unique_classes =
    all_classes
    |> list.unique()
    |> list.reverse()

  let empty = Buckets([], [], [], [], [], [])
  bucket_sort(unique_classes, empty)
}

pub fn push_classes(classes: List(String), acc: List(String)) -> List(String) {
  case classes {
    [] -> acc
    ["", ..rest] -> push_classes(rest, acc)
    [class, ..rest] -> push_classes(rest, [string.trim(class), ..acc])
  }
}

fn bucket_sort(classes: List(String), acc: Buckets) -> String {
  case classes {
    [] -> format_buckets(acc)
    [class, ..rest] -> bucket_sort(rest, classify_and_add(class, acc))
  }
}

fn format_buckets(buckets: Buckets) -> String {
  list.flatten([
    list.reverse(buckets.layout),
    list.reverse(buckets.sizing),
    list.reverse(buckets.typography),
    list.reverse(buckets.colors),
    list.reverse(buckets.other),
    list.reverse(buckets.states),
  ])
  |> string.join(" ")
}

fn classify_and_add(class: String, buckets: Buckets) -> Buckets {
  case string.contains(class, ":") {
    True -> Buckets(..buckets, states: [class, ..buckets.states])
    False -> classify_base_class(class, buckets)
  }
}

fn classify_base_class(class: String, buckets: Buckets) -> Buckets {
  case is_layout_class(class) {
    True -> Buckets(..buckets, layout: [class, ..buckets.layout])
    False ->
      case is_sizing_class(class) {
        True -> Buckets(..buckets, sizing: [class, ..buckets.sizing])
        False -> classify_visual_class(class, buckets)
      }
  }
}

fn classify_visual_class(class: String, buckets: Buckets) -> Buckets {
  case is_typography_class(class) {
    True -> Buckets(..buckets, typography: [class, ..buckets.typography])
    False ->
      case is_color_class(class) {
        True -> Buckets(..buckets, colors: [class, ..buckets.colors])
        False -> Buckets(..buckets, other: [class, ..buckets.other])
      }
  }
}

fn has_any_prefix(class: String, prefixes: List(String)) -> Bool {
  list.any(prefixes, fn(prefix) { string.starts_with(class, prefix) })
}

fn is_layout_class(class: String) -> Bool {
  has_any_prefix(class, [
    "flex", "grid", "block", "hidden", "absolute", "relative", "fixed",
  ])
}

fn is_sizing_class(class: String) -> Bool {
  has_any_prefix(class, [
    "w-", "h-", "size-", "m-", "p-", "gap-", "min-", "max-",
  ])
}

fn is_typography_class(class: String) -> Bool {
  has_any_prefix(class, ["text-", "font-", "leading-", "tracking-"])
}

fn is_color_class(class: String) -> Bool {
  has_any_prefix(class, ["bg-", "border", "shadow-", "ring-"])
}
