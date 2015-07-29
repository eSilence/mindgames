{-# OPTIONS_GHC -fno-warn-type-defaults #-}
{-# OPTIONS_GHC -fno-warn-missing-signatures #-}

import qualified Data.List as L
--import qualified Data.Map as M
--import Data.Maybe (fromMaybe)
import FigNum

--solve61 :: [Integer]
--solve61 = zipWith ($) [isTria, isPenta, isQuad] [8128, 2882, 8281]

{-
checkSolution s@(x:_) = isSolution (s ++ [x])
  where isSolution ( a:b:[] ) = snd a == fst b
        isSolution ( a:b:xs ) = snd a == fst b && isSolution (b:xs)
-}

numbers = zipWith (:) (cycle [ts]) (L.permutations [qs, ps, xs, hs, os])
  where ts = map toPairs $ take 2 $ takeWhile (<= 9999) [t | t <- map tria [1..], t > 999]
        qs = map toPairs $ take 2 $ takeWhile (<= 9999) [t | t <- map quad [1..], t > 999]
        ps = map toPairs $ take 2 $ takeWhile (<= 9999) [t | t <- map penta [1..], t > 999]
        xs = map toPairs $ take 2 $ takeWhile (<= 9999) [t | t <- map hexa [1..], t > 999]
        hs = map toPairs $ take 2 $ takeWhile (<= 9999) [t | t <- map hepta [1..], t > 999]
        os = map toPairs $ take 2 $ takeWhile (<= 9999) [t | t <- map octa [1..], t > 999]
        toPairs = splitAt 2 . show

linkTogether (ts:others) = do
    left <- ts
    right <- others
    return (if snd . left == fst . right then [left, right] else [])


main :: IO()
main = print $ linkTogether $ head numbers
  where myprint (t:ts) = print t >> print ts

{-
do
    print $ fromMaybe 0 $ M.lookup ("81", "28") mt
    print $ fromMaybe 0 $ M.lookup ("82", "81") mq
    print $ fromMaybe 0 $ M.lookup ("28", "82") mp
    print $ prefixes $ M.keys mp
    print $ filter (`elem` (suffixes $ M.keys mt)) (prefixes $ M.keys mp)
    print $ checkSolution $ map (splitAt 2 . show) [8128, 2882, 8281]
    -- print $ length $ L.nub $ map (fst . splitAt 2 . show) qs
    -- print $ length $ L.nub $ map (fst . splitAt 2 . show) ps
    -- print $ length $ L.nub $ map (fst . splitAt 2 . show) xs
    -- print $ length $ L.nub $ map (fst . splitAt 2 . show) hs
    -- print $ length $ L.nub $ map (fst . splitAt 2 . show) os
    where
          prefix = fst . splitAt 2 . show
          suffix = snd . splitAt 2 . show
          prefixes = map fst
          suffixes = map snd
          mt = M.fromList $ zip (map (splitAt 2 . show) ts) ts
          mq = M.fromList $ zip (map (splitAt 2 . show) qs) qs
          mp = M.fromList $ zip (map (splitAt 2 . show) ps) ps
-}
