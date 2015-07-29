target = 999

euler_1 = sum [x | x <- [3..target], x `mod` 3 == 0 || x `mod` 5 == 0]

-- inspired by problem overview
euler_1' = sum [x | x <- [3,6..target]] + sum [x | x <- [5,10..target]] - sum [x | x <- [15,30..target]]

euler_1'' = sumDivisibleBy 3 + sumDivisibleBy 5 - sumDivisibleBy 15
    where sumDivisibleBy n = let p = target `div` n in
                             n * (p * (p + 1)) `div` 2