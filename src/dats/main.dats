 
#include "share/atspre_staload.hats"

datatype Term =
  | Var of string

val t = Var "hello"

implement main0() = 
  println!("hello world")