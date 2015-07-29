-- my brute force solution
numbers = [1..100]
sumSquares = sum $ map (^2) numbers
squareSum = (^2) $ sum numbers
euler_6 = squareSum - sumSquares

-- solution inspired by overview
limit = 100
squareSum' = (^2) $ sumN limit
    where
      sumN n = truncate (n * (n + 1) / 2)
sumSquares' = truncate (limit * (2 * limit + 1) * (limit + 1) / 6)
euler_6' = squareSum' - sumSquares'