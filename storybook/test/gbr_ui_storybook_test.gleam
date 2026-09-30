import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn dummy_test() {
  True
  |> should.be_true
}
