-- infinite list
fibonacci = 0:1:zipWith (+) fibonacci (tail fibonacci)

euler_2 = sum [x | x <- take 50 $ fibonacci, x <= 4000000, even x]

-- naive implementation
fibonacci' 0 = 0
fibonacci' 1 = 1
fibonacci' n = fibonacci' (n - 1) + fibonacci' (n - 2)

-- inspired by overview (sum every third number which is even)
-- VERY SLOW!!
euler_2' = sum [x | x <- map fibonacci' [3,6..33], x <= 4000000]

-- implementaion with accumulator
fibonacci'' n = fibs n (0, 1)
    where
      fibs 0 (a, b) = a
      fibs n (a, b) = fibs (n-1) (b, a + b)

-- again sum every third number
euler_2'' = sum [x | x <- map fibonacci'' [3,6..50], x <= 4000000]


