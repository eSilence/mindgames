module Exercise2 where

import Data.Function

-- Задача 2.1:1
getSecondFrom :: a -> b -> c -> b
getSecondFrom _ x _ = x


-- Задача 2.1:2
multSecond :: (a, Integer) -> (a, Integer) -> Integer
multSecond = g `on` h
    where
        g = (*)
        h = snd


-- Задача 2.1:3
on3 :: (b -> b -> b -> c) -> (a -> b) -> a -> a -> a -> c
on3 op f x y z = op (f x) (f y) (f z)


-- Задача 2.2:1
doItYourself :: Double -> Double
doItYourself = f . g . h
    where
    f = logBase 2
    g = (^(3::Integer))
    h = max 42

-- Задача 2.2:2
{-
a -> (a,b) -> a -> (b,a,a)

x1 (x2, y) x3 -> (y, x1, x1)
              -> (y, x1, x2)
              -> (y, x1, x3)
              -> (y, x2, x1)
              -> (y, x2, x2)
              -> (y, x2, x3)
              -> (y, x3, x1)
              -> (y, x3, x2)
              -> (y, x3, x3)
-}

-- Задача 2.2:5
swap :: (a, b) -> (b, a)
swap = f (g h)
    where f = uncurry
          g = flip
          h = (,)


-- Задача 2.3:1
class Printable a where
    toString :: a -> String

instance Printable Bool where
    toString True = "true"
    toString False = "false"

instance Printable () where
    toString _ = "unit type"

-- Задача 2.3:2
instance (Printable a, Printable b) => Printable (a, b) where
    toString (a, b) = "(" ++ toString a ++ "," ++ toString b ++ ")"

-- Задача 2.4:1
class KnownToGork a where
    stomp :: a -> a
    doesEnrageGork :: a -> Bool

class KnownToMork a where
    stab :: a -> a
    doesEnrageMork :: a -> Bool

class (KnownToGork a, KnownToMork a) => KnownToGorkAndMork a where
    stompOrStab :: a -> a
    stompOrStab a | doesEnrageMork a && doesEnrageGork a = (stomp . stab) a
                  | doesEnrageMork a = stomp a
                  | doesEnrageGork a = stab a
                  | otherwise = a


-- Задача 2.4:2
ip :: String
ip = show a ++ show b ++ show c ++ show d
    where
        a = 127.2 :: Double
        b = 24.1 :: Double
        c = 20.1 :: Double
        d = 2 :: Integer


-- Задача 2.4:3
class (Eq a, Enum a, Bounded a) => SafeEnum a where
    ssucc :: a -> a
    ssucc a | a == maxBound = minBound
            | otherwise = succ a

    spred :: a -> a
    spred a | a == minBound = maxBound
            | otherwise = pred a

instance SafeEnum Bool

instance SafeEnum Int


-- Задача 2.4:4
avg :: Int -> Int -> Int -> Double
avg a b c = fromIntegral (a + b + c) / 3.0


-- Задача 2.5:2
{-
value = foo (3 * 10) (5 -2)
    ~> bar (3 * 10) (3 * 10) ((3 * 10) + (5 -2)) 
    ~> (3 * 10) + (3 * 10)
    ~> 30 + 3
    ~> 60
-}
