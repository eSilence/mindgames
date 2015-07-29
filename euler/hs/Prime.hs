module Prime
where

import Data.List (sort)

isFactor :: Integer -> Integer -> Bool
isFactor n m = n `mod` m == 0

isPrime :: Integer -> Bool
isPrime n | n > 1 = factors n == [n]
          | otherwise = False

factors :: Integer -> [Integer]
factors n = sort $ low ++ high
    where
        low = filter (isFactor n) [1..(round . sqrt . fromInteger) n]
        high = [round $ fromInteger n / fromInteger k | k <- low]
