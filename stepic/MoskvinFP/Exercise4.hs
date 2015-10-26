module Exercise4 where

default (Integer)

-- 4.1:2
data Color = Red | Green | Blue

instance Show Color where
    show Red = "Red"
    show Green = "Green"
    show Blue = "Blue"


-- 4.1:3
charToInt :: Char -> Int
charToInt '0' = 0
charToInt '1' = 1
charToInt '2' = 2
charToInt '3' = 3
charToInt '4' = 4
charToInt '5' = 5
charToInt '6' = 6
charToInt '7' = 7
charToInt '8' = 8
charToInt '9' = 9
charToInt _   = undefined


-- 4.1:4
stringToColor :: String -> Color
stringToColor "Red"   = Red
stringToColor "Green" = Green
stringToColor "Blue"  = Blue
stringToColor _       = undefined


-- 4.1:6
data LogLevel = Error | Warning | Info

cmp :: LogLevel -> LogLevel -> Ordering
cmp Error Error = EQ
cmp Error _ = GT
cmp Warning Error = LT
cmp Warning Warning = EQ
cmp Warning Info = GT
cmp Info Info = EQ
cmp Info _ = LT

-- 4.1:7
{-
processData :: SomeData -> String
processData d = case doSomeWork d of
    (Success, _) -> "Success"
    (Fail, result) -> "Fail: " ++ show result
-}

-- 4.2:1
data Point = Point Double Double

origin :: Point
origin = Point 0.0 0.0

distanceToOrigin :: Point -> Double
distanceToOrigin (Point x y) = sqrt (x * x + y * y)

distance :: Point -> Point -> Double
distance (Point x1 y1) (Point x2 y2) = sqrt $ (x1 - x2) ^ (2 :: Int) + (y1 - y2) ^ (2 :: Int)

-- 4.2:2
data Shape = Circle Double | Rectangle Double Double

area :: Shape -> Double
area (Circle r) = pi * r ^ (2 :: Int)
area (Rectangle a b) = a * b

-- 4.2:3
data Result' = OK | ErrorCode Int

instance Show Result' where
    show OK = "Success"
    show (ErrorCode e) = "Fail: " ++ show e

{-
doSomeWork' :: SomeData -> Result'
doSomeWork' d = case doSomeWork d of
    (Success, _) -> OK
    (Fail, result) -> ErrorCode result
-}

-- 4.2:4
square :: Double -> Shape
square a = Rectangle a a

isSquare :: Shape -> Bool
isSquare (Circle _) = False
isSquare (Rectangle a b) = a == b

-- 4.2:5
-- см. Intbit.hs

--
(***) :: (a -> b) -> (c -> d) -> (a, c) -> (b, d)
-- (***) f g p = (f $ fst p, g $ snd p)
(***) f g ~(x, y) = (f x, g y)

-- 4.3:1
-- см. Log.hs

-- 4.3:2
data Person = Person { firstName :: String, lastName :: String, age :: Int }
            deriving Show

updateLastName :: Person -> Person -> Person
updateLastName p1 p2 = p2 { lastName = lastName p1 }

-- 4.3:4
abbrFirstName :: Person -> Person
abbrFirstName p@Person{firstName = f} = if length f <= 2 then p else p {firstName = head f : "."}
