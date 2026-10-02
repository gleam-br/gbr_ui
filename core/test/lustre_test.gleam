import gbr/ui/theme/lustre
import gleeunit/should

pub fn sort_tailwind_classes_test() {
  let tokens = [
    lustre.Class("text-sm hover:bg-red-500"),
    lustre.Class("w-full flex"),
    lustre.Class("bg-blue-500"),
    lustre.Class("text-gray-900 absolute"),
  ]

  let sorted = lustre.sort_tailwind_classes(tokens)

  sorted
  |> should.equal(
    "flex absolute w-full text-sm text-gray-900 bg-blue-500 hover:bg-red-500",
  )
}

pub fn sort_tailwind_classes_deduplication_test() {
  let tokens = [
    lustre.Class("bg-blue-500"),
    lustre.Class("flex"),
    lustre.Class("bg-red-500"),
    lustre.Class("flex"),
    lustre.Class("w-full"),
    lustre.Class("bg-green-500"),
  ]

  let sorted = lustre.sort_tailwind_classes(tokens)

  sorted
  |> should.equal("flex w-full bg-blue-500 bg-red-500 bg-green-500")
}
