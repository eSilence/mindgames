import Data.Time

isSunday :: Day -> Bool
isSunday d = (diffDays d (fromGregorian 1900 1 1) + 1) `mod` 7 == 0

firstDaysOfMonth :: Integer -> Integer -> [Day]
firstDaysOfMonth from to = [fromGregorian y m 1 | m <- [1..12], y <- [from..to]]

main :: IO()
main = print $ length $ filter isSunday (firstDaysOfMonth 1901 2000)
