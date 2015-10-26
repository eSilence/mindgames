module Exercise4_5 where

data List a = Nil | Cons a (List a)
    deriving Show

-- 4.5:1
fromList :: List a -> [a]
fromList Nil = []
fromList (Cons x xs) = x : fromList xs

{-# ANN toList "HLint: ignore Use foldr" #-}
toList :: [a] -> List a
toList [] = Nil
toList (x:xs) = Cons x (toList xs)

-- 4.5:2
-- см. Nat.hs

-- 4.5:3, 4.5:4
-- см. Tree.hs

-- 4.5:5
-- см. Expr.hs
