-- my brute force (slow)
triplets n = [[a, b, c] | a <- [1..(n - 3) `quot` 3], b <- [a..(n -a) `quot` 2], c <- [n - (a + b)], a^2 + b^2 == c^2]

main :: IO ()
main = print $ product $ triplets 1000 !! 0