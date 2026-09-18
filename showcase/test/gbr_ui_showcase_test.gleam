import gleeunit

pub fn main() {
  gleeunit.main()
}

pub fn ok_test() {
  let expected = "Ola"
  assert "Ola" == expected
}
