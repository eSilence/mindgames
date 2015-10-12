module Exercise3 where

import Data.Char
import Data.List

-- 3.1:1
addTwoElements :: a -> a -> [a] -> [a]
addTwoElements a b lst = a : b : lst

-- 3.1:2
nTimes:: a -> Int -> [a]
nTimes _ 0 = []
nTimes e count = e : nTimes e (count - 1)

-- 3.1:3
oddsOnly :: Integral a => [a] -> [a]
oddsOnly [] = []
oddsOnly (x:xs) = if odd x then x : oddsOnly xs else oddsOnly xs


reverse' :: [a] -> [a]
reverse' l = rev l []
    where
        rev [] xs = xs
        rev (x:xs) ys = rev xs (x:ys)


-- 3.1:4
isPalindrome :: Eq a => [a] -> Bool
isPalindrome a =  a == reverse' a


-- 3.1:5
sum3 :: Num a => [a] -> [a] -> [a] -> [a]
sum3 (a:as) (b:bs) (c:cs) = (a + b + c) : sum3 as bs cs
sum3 [] (b:bs) (c:cs) = (b + c) : sum3 [] bs cs
sum3 (a:as) [] (c:cs) = (a + c) : sum3 as [] cs
sum3 (a:as) (b:bs) [] = (a + b) : sum3 as bs []
sum3 as [] [] = as
sum3 [] bs [] = bs
sum3 [] [] cs = cs


-- 3.1:6
groupElems :: Eq a => [a] -> [[a]]
groupElems [] = []
groupElems (x:xs) = group x [x] xs
    where group a as (b:bs) = if a == b then group a (b:as) bs else as : group b [b] bs
          group _ as [] = [as]

-- 3.2:1
readDigits :: String -> (String, String)
readDigits = span isDigit

-- 3.2:2
filterDisj :: (a -> Bool) -> (a -> Bool) -> [a] -> [a]
filterDisj _ _ [] = []
filterDisj p1 p2 (x:xs) | p1 x || p2 x = x : filterDisj p1 p2 xs
                        | otherwise = filterDisj p1 p2 xs

-- 3.2:3
qsort :: Ord a => [a] -> [a]
qsort [] = []
qsort (x:xs) = qsort (filter (<= x) xs) ++ [x] ++ qsort (filter (> x) xs)

-- 3.2:4
{-# ANN squares'n'cubes "HLint: ignore Use camelCase" #-}
squares'n'cubes :: Num a => [a] -> [a]
squares'n'cubes = concatMap (\x -> [x^(2::Integer), x^(3::Integer)])

-- 3.2:5
perms :: Eq a => [a] -> [[a]]
perms [] = [[]]
perms xs = concatMap (\x -> map (x:) (perms $ filter (/= x) xs)) xs

-- 3.2:6
delAllUpper :: String -> String
delAllUpper = unwords . filter (not . all isUpper) . words

-- 3.2:7
max3 :: Ord a => [a] -> [a] -> [a] -> [a]
max3 = zipWith3 maximum3
    where maximum3 a b c = maximum [a, b, c]

-- 3.3:1
fibStream :: [Integer]
fibStream = 0 : 1 : zipWith (+) fibStream (tail fibStream)


-- 3.3:2
repeatHelper :: a -> a
repeatHelper = id

-- 3.3:3
data Odd = Odd Integer deriving (Eq,Show)

instance Enum Odd where
    succ (Odd x) = Odd (x + 2)
    pred (Odd x) = Odd (x - 2)
    fromEnum (Odd x) = fromIntegral x
    toEnum = Odd . fromIntegral
    enumFrom (Odd x) = map Odd [x,x+2..]
    enumFromTo (Odd x1) (Odd x2) = map Odd [x1,x1+2..x2]
    enumFromThen (Odd x1) (Odd x2) = let step = x2 - x1 in map Odd [x1,x1+step..]
    enumFromThenTo (Odd x1) (Odd x2) (Odd x3) = let step = x2 - x1 in map Odd [x1,x1+step..x3]

-- 3.3:4
coins :: (Ord a, Num a) => [a]
coins = [2, 3, 7]

change :: (Ord a, Num a) => a -> [[a]]
change value = if value <= 0
                then [[]]
                else [x:xs | x <- coins, xs <- change (value - x), sum (x:xs) == value]

-- 3.4:1
{-# ANN concatList "HLint: ignore Use concat" #-}
concatList :: [[a]] -> [a]
concatList = foldr (++) []

-- 3.4:2
lengthList :: [a] -> Int
lengthList = foldr (\_ s -> 1 + s) 0

-- 3.4:3
sumOdd :: [Integer] -> Integer
sumOdd = foldr (\x s -> if odd x then x + s else s) 0


-- 3.4:4
-- foldr (:) [] -> id

-- 3.4:5
-- foldr const undefined -> head

-- 3.5:1
-- x = 7: foldr (-) 7 [2,1,5] == foldl (-) 7 [2,1,5]

-- 3.5:2
meanList :: [Double] -> Double
meanList as = foldl (\s (v, amount) -> (s * amount + v) / (amount + 1)) 0 $ zip as [0..]

-- 3.5:3,4
evenOnly :: [a] -> [a]
evenOnly as = foldr (\(x, b) xs -> if b then x:xs else xs) [] $ zip as (cycle [False, True])


-- 3.6:1
lastElem :: [a] -> a
lastElem = foldl1 (flip const)

-- 3.6:2
{-# ANN revRange "HLint: ignore Use String" #-}
revRange :: (Char,Char) -> [Char]
revRange (a, b) | a == b = [a]
                | otherwise = unfoldr g b
  where g x = if a <= x && x <= b then Just (x, pred x) else Nothing
