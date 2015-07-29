{-# OPTIONS -fno-warn-type-defaults #-}
import Prime

maxPrimeFactor :: Integer -> Integer
maxPrimeFactor n = last $ filter isPrime $ factors n

main :: IO ()
main = print $ maxPrimeFactor 600851475143
