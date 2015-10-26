module Exercise4_4 where

import Data.Char(isDigit)

-- 4.4:1
data Coord a = Coord a a
    deriving Show

distance :: Coord Double -> Coord Double -> Double
distance (Coord x1 y1) (Coord x2 y2) = sqrt $ (x1 - x2) ^ (2::Int) + (y1 - y2) ^ (2::Int)

manhDistance :: Coord Int -> Coord Int -> Int
manhDistance (Coord x1 y1) (Coord x2 y2) = abs (x1 - x2) + abs (y1 - y2)


-- 4.4:2
getCenter :: Double -> Coord Int -> Coord Double
getCenter width (Coord x y) = Coord (width * (fromIntegral x - 0.5)) (width * (fromIntegral y - 0.5))

getCell :: Double -> Coord Double -> Coord Int
getCell width (Coord x y) = Coord (ceiling (x / width)) (ceiling (y / width))


-- 4.4:3
findDigit :: String -> Maybe Char
findDigit s = if null s' then Nothing else Just (head s')
    where s' = dropWhile (not . isDigit) s


-- 4.4:4
{-# ANN findDigitOrX "HLint: ignore Use fromMaybe" #-}
findDigitOrX :: String -> Char
findDigitOrX s = case findDigit s of
        Nothing -> 'X'
        Just c -> c


-- 4.4:5
maybeToList :: Maybe a -> [a]
maybeToList Nothing = []
maybeToList (Just x) = [x]

listToMaybe :: [a] -> Maybe a
listToMaybe [] = Nothing
listToMaybe (x:_) = Just x


-- 4.4:6
-- см. ParsePerson.hs
