{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-type-defaults #-}

import qualified Data.Char as C
import qualified Data.Text.Lazy as T

import FigNum (isTria)

solve42 :: String -> Int
solve42 = length . filter isTria . map getWordCode . splitWords
    where splitWords = T.splitOn "," . T.replace "\"" "" . T.pack
          getWordCode = sum . map (getCode . C.toLower) . T.unpack
          getCode c = fromIntegral $ C.ord c - C.ord 'a' + 1

main :: IO()
main = do
    ws <- readFile "../data/words.txt"
    print $ solve42 ws
