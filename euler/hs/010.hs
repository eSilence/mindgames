import Prime

primesBelow :: Integer -> [Integer]
primesBelow n = 2 : filter isPrime (filter odd [3..n])

main :: IO ()
main = print $ sum $ primesBelow 2000000
