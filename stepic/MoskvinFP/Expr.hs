module Expr where


infixl 6 :+:
infixl 7 :*:

data Expr = Val Int | Expr :+: Expr | Expr :*: Expr
    deriving (Show, Eq)

expr1 = Val 2 :+: Val 3 :*: Val 4
expr2 = (Val 2 :+: Val 3) :*: Val 4
expr3 = expr1 :*: expr2

eval :: Expr -> Int
eval (Val n) = n
eval (e1 :+: e2) = eval e1 + eval e2
eval (e1 :*: e2) = eval e1 * eval e2

-- TODO: not yet done
expand :: Expr -> Expr
expand ((e1 :+: e2) :*: e) = expand e1 :*: expand e :+: expand e2 :*: expand e
expand (e :*: (e1 :+: e2)) = expand e :*: expand e1 :+: expand e :*: expand e2
expand (e1 :+: e2) = expand e1 :+: expand e2
expand (e1 :*: e2) = expand e1 :*: expand e2
expand e = e

simplify e | e == expand e = e
           | otherwise = simplify $ expand e


e = Val 1
ee = Val 2

test1 = (e :+: ee) :*: (e :+: ee)
test2 = e :*: (e :+: e) :*: e
