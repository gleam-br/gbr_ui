import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn gbr_ui_todo_test() {
  let name = "Gleam BR UI stateless"
  let greeting = "Hello, " <> name <> "!"

  assert greeting == "Hello, Gleam BR UI stateless!"
}
