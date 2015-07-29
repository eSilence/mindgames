{-# OPTIONS_GHC -fno-warn-type-defaults #-}
module FigNum where

fignum :: Integer -> Integer -> Integer
fignum k n = n * ((k - 2) * (n - 1) + 2) `div` 2

tria, quad, penta, hexa, hepta, octa :: Integer -> Integer
tria = fignum 3
quad = fignum 4
penta = fignum 5
hexa = fignum 6
hepta = fignum 7
octa = fignum 8


isTria, isQuad, isPenta, isHexa :: Integer -> Bool
isTria t = isInt $ (-1 + sqrt (1 + 8 * fromIntegral t)) / 2
isQuad q = isInt $ (sqrt . fromInteger) q
isPenta p = isInt $ (1 + sqrt (1 + 24 * fromInteger p)) / 6
isHexa h = isInt $ (1 + sqrt (1 + 8 * fromInteger h)) / 4

isInt :: RealFrac a => a -> Bool
isInt x = (fromInteger . round) x == x
