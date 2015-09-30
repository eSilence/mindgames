module Exercise1 where

import Data.Char

-- Задача 1.2:1
lenVec3 x y z =  sqrt (x ^ 2 + y ^ 2 + z ^ 2)

-- Задача 1.2:2
sign x = if x == 0 then 0 else (if x > 0 then 1 else -1)

-- Задача 1.4:3
twoDigits2Int :: Char -> Char -> Int
twoDigits2Int a b = if isDigit a && isDigit b then digitToInt a  * 10 + digitToInt b else 100

-- Задача 1.4:4
dist :: (Double, Double) -> (Double, Double) -> Double
dist x y = sqrt $ (fst x - fst y) ^ 2 + (snd x - snd y) ^ 2

-- Задача 1.5:1
doubleFact :: Integer -> Integer
doubleFact 0 = 1
doubleFact 1 = 1
doubleFact n = n * doubleFact (n - 2)

-- Задача 1.5:3
fibonacci :: Integer -> Integer
fibonacci 0 = 0
fibonacci 1 = 1
fibonacci n | n > 1 = fibonacci (n - 1) + fibonacci (n - 2)
            | n < 0 = fibonacci (n + 2) - fibonacci (n + 1)


-- Задача 1.5:4
fibonacci' :: Integer -> Integer
fibonacci' n | n >= 0 = fibonacciIterPlus 1 0 n
fibonacci' n         = fibonacciIterMinus 1 0 n

fibonacciIterPlus :: Integer -> Integer -> Integer -> Integer
fibonacciIterPlus _ b 0 = b
fibonacciIterPlus a b n = fibonacciIterPlus (a + b) a (n - 1)

fibonacciIterMinus :: Integer -> Integer -> Integer -> Integer
fibonacciIterMinus _ b 0 = b
fibonacciIterMinus a b n = fibonacciIterMinus (b - a) a (n + 1)

-- Задача 1.6:2
seqA :: Integer -> Integer
seqA 0 = 1
seqA 1 = 2
seqA 2 = 3
seqA n =
    let
        seqAIter a b c count | count == n = c
                             | otherwise = seqAIter b c (c + b - 2 * a) (count + 1)
    in seqAIter 1 2 3 2


-- Задача 1.6:3
strToDigits :: String -> String
strToDigits [] = []
strToDigits (x:xs) = if isDigit x then x : strToDigits xs else strToDigits xs

countDigits :: String -> Integer
countDigits [] = 0
countDigits (_:xs) = 1 + countDigits xs

sumDigits :: String -> Integer
sumDigits = foldr ((+) . toInteger . digitToInt) 0
-- sumDigits [] = 0
-- sumDigits (x:xs) = (toInteger . digitToInt) x + sumDigits xs

sumNCount :: Integer -> (Integer, Integer)
sumNCount n = (sumDigits numStr, countDigits numStr)
    where
        numStr = strToDigits $ show n


-- Задача 1.6:4
trapezoidMethod :: (Double -> Double) -> Double -> Double -> Integer -> Double
trapezoidMethod f a b n = sum $ trapezoids a
    where
        trapezoids x | x >= b = []
                     | x + h > b = [trapezoid x b]
                     | otherwise = trapezoid x (x + h): trapezoids (x + h)
        trapezoid a' b' = 0.5 * (f a' + f b') * (b' - a')
        h = (b - a) / fromIntegral n

integration :: (Double -> Double) -> Double -> Double -> Double
integration f a b | a > b = - integration f b a
                  | otherwise = trapezoidMethod f a b 1000
