module Exercise5 where

import Control.Monad
import Data.Char
import Data.Functor

-- 5.1:1
data Point3D a = Point3D a a a deriving Show

instance Functor Point3D where
    fmap f (Point3D x y z) = Point3D (f x) (f y) (f z)

-- 5.1:2
data GeomPrimitive a = Point (Point3D a) | LineSegment (Point3D a) (Point3D a)
    deriving Show

instance Functor GeomPrimitive where
    fmap f (Point x) = Point (f <$> x)
    fmap f (LineSegment x y) = LineSegment (f <$> x) (f <$> y)

-- 5.1:3
data Tree a = Leaf (Maybe a) | Branch (Tree a) (Maybe a) (Tree a)
    deriving Show

instance Functor Tree where
    fmap f (Leaf x) = Leaf (f <$> x)
    fmap f (Branch l x r) = Branch (f <$> l) (f <$> x) (f <$> r)


-- 5.1:4
data Entry k1 k2 v = Entry (k1, k2) v  deriving Show
data Map k1 k2 v = Map [Entry k1 k2 v]  deriving Show

instance Functor (Entry k1 k2) where
    fmap f (Entry k v) = Entry k (f v)

instance Functor (Map k1 k2) where
    fmap _ (Map []) = Map []
    fmap f (Map xs)= Map ((f `fmap`) <$> xs)

-- 5.2:1
data Log a = Log [String] a
    deriving Show

toLogger :: (a -> b) -> String -> a -> Log b
toLogger f msg = Log [msg] . f

execLoggers :: a -> (a -> Log b) -> (b -> Log c) -> Log c
execLoggers x f g = let {Log msg1 y = f x; Log msg2 z = g y} in Log (msg1 ++ msg2) z

-- 5.2:2
returnLog :: a -> Log a
returnLog = Log []

-- 5.2:3
bindLog :: Log a -> (a -> Log b) -> Log b
bindLog (Log msg1 x) f = let Log msg2 y = f x in Log (msg1 ++ msg2) y

-- 5.2:4
instance Functor Log where
    fmap f (Log s x) = Log s (f x)

instance Applicative Log where
    pure = Log []

instance Monad Log where
    return = returnLog
    (>>=) = bindLog

execLoggersList :: a -> [a -> Log a] -> Log a
execLoggersList x = foldl (>>=) (return x)


-- 5.3:1
-- fmap: (a -> b) -> m a -> m b
-- return : a -> m a
-- >>=: m a -> (a -> m b) -> m b
-- fmap f x = x >>= (return . f)

-- 5.4:1
data Token = Number Int | Plus | Minus | LeftBrace | RightBrace
    deriving (Eq, Show)

asToken :: String -> Maybe Token
asToken s | all isDigit s = Just $ Number (read s)
          | otherwise = case s of
                            "+" -> Just Plus
                            "-" -> Just Minus
                            "(" -> Just LeftBrace
                            ")" -> Just RightBrace
                            _ -> Nothing

tokenize :: String -> Maybe [Token]
tokenize = mapM asToken . words


-- 5.4:2
data Board = Board
    deriving Show

nextPositions :: Board -> [Board]
nextPositions x = [x, x]

nextPositionsN :: Board -> Int -> (Board -> Bool) -> [Board]
nextPositionsN b n p = do
        b' <- go n b
        guard $ p b'
        return b'
    where
        go n b | n < 0 = []
            | n == 0 = return b
            | otherwise = nextPositions b >>= go (n - 1)


-- 5.4:3
pythagoreanTriple :: Int -> [(Int, Int, Int)]
pythagoreanTriple x | x <= 0 = []
                    | otherwise = do
                        a <- [1..x]
                        b <- [1..x]
                        c <- [1..x]
                        if a < b && a^2 + b^2 == c^2 then [True] else []
                        return (a, b, c)
