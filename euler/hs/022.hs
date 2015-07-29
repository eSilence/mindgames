{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-type-defaults #-}

import qualified Data.Char as C
import qualified Data.Text.Lazy as T
import Data.List (sort)

solve22 :: String -> Integer
solve22 ws = sum $ zipWith(*) [1..] $ (map getWordCode . sort . splitWords) ws
    where splitWords = T.splitOn "," . T.replace "\"" "" . T.pack
          getWordCode = sum . map getCode . T.unpack
          getCode c = fromIntegral $ C.ord c - C.ord 'A' + 1

main :: IO()
main = do
    ws <- readFile "../data/names.txt"
    print $ solve22 ws
