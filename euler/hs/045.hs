{-# OPTIONS_GHC -fno-warn-type-defaults #-}

import FigNum (isPenta, hexa)

solve45 :: [Integer]
solve45 = take 3 [t | t <- map hexa [1..], isPenta t]

main :: IO()
main = print solve45
