module Exercise5_5_2 where

import Data.List
import System.Directory

removeFileVerbose file = do
        putStrLn $ "Removing file: " ++ file
        removeFile file

removeFiles s = do
    files <- getDirectoryContents "."
    mapM_ removeFileVerbose $ filter (s `isInfixOf`) files

main' :: IO ()
main' = do
    putStr "Substring: "
    substr <- getLine
    if substr == "" then putStrLn "Canceled" else removeFiles substr
