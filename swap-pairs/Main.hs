module Main where

import Data.List
import Control.Monad.State
import qualified Data.Set as S
import System.Environment


type SolvingState = State (S.Set String) [[String]]


main :: IO ()
main = do
    as <- getArgs
    case length as of
        1 -> mapM_ putStrLn [fst s ++ ": " ++ (printSol . head . snd $ s) | s <- findAll (head as)]
        2 -> mapM_ (putStrLn . printSol) (snd $ getSol (last as) (head as))
        _ -> error "Wrong arguments amount"
    where
        findAll to = filter (not . null . snd) $ map (getSol to) $ filter (/= to) $ permutations to
        printSol = intercalate " -> "
        getSol to from = (from, evalState (findPath [[from]] to) (S.insert from S.empty))


findPath :: [[String]] -> String -> SolvingState
findPath from to =
        if (not . null) f
            then return f
            else do
                from' <- mapM (step to) f'
                if concat from' == f'
                    then return []
                    else findPath (concat from') to
    where
        f = filter (to `elem`) from
        f' = filter (to `notElem`) from


step :: String -> [String] -> SolvingState
step to from = do
        ns <- generate to (last from)
        return (if null ns then [from] else [from ++ [n] | n <- ns])
    where
        generate to' current = do
            clean <- unique current
            mapM_ register $ filter (/= to') clean
            return clean
        unique c = do
            m <- get
            return $ filter (`S.notMember` m) $ variants c
        register n = modify (S.insert n)


variants :: String -> [String]
variants s | length s < 4 = return s
           | otherwise = nub $ concat
            [
                map (head s:) (variants . tail $ s)
              , map (++ [last s]) (variants $ init s)
              , [rotate s]
            ]
        where
            rotate s' = concatMap ($ s') [drop (l - 2), take (l - 4) . drop 2, take 2]
            l = length s
