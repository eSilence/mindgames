{-# OPTIONS -fno-warn-type-defaults #-}

isPalindrome :: Integer -> Bool
isPalindrome n = s == reverse s
    where s = show n

productsReversed :: Integer -> Integer -> [Integer]
productsReversed kmin kmax = [kmax * kmax - k | k <- [1..(kmax * kmax - kmin * kmin)]]

factors :: Integer -> [(Integer, Integer)]
factors n = [(k, round $ fromInteger n / fromInteger k) | k <- [2..(round . sqrt . fromInteger) n], n `mod` k == 0]

inRange :: Integer -> Integer -> Integer -> Bool
inRange kmin kmax k = k >= kmin && k <= kmax

isProduct :: Integer -> Integer -> Integer -> Bool
isProduct kmin kmax n = any isProduct' $ factors n
    where
        isProduct' f = (inRange kmin kmax . fst) f && (inRange kmin kmax . snd) f

main :: IO ()
main = print $ head $ filter (isProduct kmin kmax) $ filter isPalindrome (productsReversed kmin kmax)
    where kmin = 100
          kmax = 999
