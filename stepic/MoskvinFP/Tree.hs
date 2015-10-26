module Tree where

data Tree a = Leaf a | Node (Tree a) (Tree a)
    deriving Show

height :: Tree a -> Int
height (Leaf _) = 0
height (Node left right) = 1 + max (height left) (height right)

size :: Tree a -> Int
size (Leaf _) = 1
size (Node left right) = 1 + size left + size right

{-# ANN avg "HLint: ignore Use ***" #-}
avg :: Tree Int -> Int
avg t =
    let (c,s) = go t
    in s `div` c
  where
    go :: Tree Int -> (Int,Int)
    go (Leaf v) = (1, v)
    go (Node left right) = let {l' = go left; r' = go right} in
        (fst l' + fst r', snd l' + snd r')
