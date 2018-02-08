module Bool

export Bool(..), not/1, compare/2, max/2, min/2

import Order exposing Order(_)


type Bool
  = True
  | False

let not(bool) =
  match bool
  | True => False
  | False => True

let compare(a, b) =
  match (a, b)
  | (True, True) => EQ
  | (True, False) => GT
  | (False, False) => LT
  | (False, True) => GT

let max(a, b) =
  match a
  | True => True
  | False => b

let min(a, b) =
  match a
  | False => False
  | True => b