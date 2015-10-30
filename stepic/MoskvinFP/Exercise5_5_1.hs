module Exercise5_5_1 where

main' :: IO ()
main' = do
    putStrLn "What is your name?"
    putStr "Name: "
    s <- getLine
    if s == "" then main' else putStrLn $ "Hi, " ++ s ++ "!"
