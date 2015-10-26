module MoskvinFP.Intbit where

data Bit = Zero | One deriving (Show, Eq)
data Sign = Minus | Plus deriving (Show, Eq)
data Z = Z Sign [Bit] deriving (Show, Eq)

add :: Z -> Z -> Z
add a@(Z _ as) b@(Z _ bs) = fromBits $ if length bits == width + 2 then init bits else bits
    where bits = sumBits (toBits width a) (toBits width b) Zero
          width = max (length as) (length bs) + 1

mul :: Z -> Z -> Z
mul a b@(Z Minus _) = neg $ mul a (neg b)
mul a b = iter a b (Z Plus [])
    where iter _ (Z Plus []) s = s
          iter a' b' s = iter a' (add b' (Z Minus [One])) (add s a')

sumBits :: [Bit] -> [Bit] -> Bit -> [Bit]
sumBits [] [] Zero = []
sumBits [] [] One = [One]
sumBits [] (Zero:bs) c = c:bs
sumBits [] (One:bs) Zero = One:bs
sumBits [] (One:bs) One = Zero : sumBits [] bs One
sumBits as [] c = sumBits [] as c
sumBits (Zero:as) (Zero:bs) c = c : sumBits as bs Zero
sumBits (One:as) (One:bs) c = c : sumBits as bs One
sumBits (Zero:as) (One:bs) Zero = One : sumBits as bs Zero
sumBits (Zero:as) (One:bs) One = Zero : sumBits as bs One
sumBits (One:as) (Zero:bs) Zero = One : sumBits as bs Zero
sumBits (One:as) (Zero:bs) One = Zero : sumBits as bs One

-- Переводим число в полностью битовое представление заданной ширины.
-- Для отрицательных чисел используем дополнительный код
toBits :: Int -> Z -> [Bit]
toBits width (Z Plus bits) = pad width bits ++ [Zero]
toBits width (Z Minus bits) = sumBits (reverseBits $ pad width bits ++ [Zero]) [One] Zero

-- удаляем ведущие нули
shrink :: [Bit] -> [Bit]
shrink = reverse . dropWhile (== Zero) . reverse

-- дополняем нулями справа до нужного размера
pad :: Int -> [Bit] -> [Bit]
pad 0 bs = bs
pad n [] = Zero : pad (n - 1) []
pad w (b:bs) = b : pad (w - 1) bs

fromBits :: [Bit] -> Z
fromBits [] = Z Plus []
fromBits xs | last xs == One = Z Minus (shrink  $ sumBits (reverseBits . init $ xs) [One] Zero)
            | otherwise = Z Plus (shrink . init $ xs)

reverseBits :: [Bit] -> [Bit]
reverseBits [] = []
reverseBits (One:bs) = Zero : reverseBits bs
reverseBits (Zero:bs) = One : reverseBits bs

neg :: Z -> Z
neg (Z Minus bs) = Z Plus bs
neg (Z Plus bs) = Z Minus bs

zero, one, minusOne, two, three, four, minusFour, x, y, z :: Z
zero = Z Plus []
one = Z Plus [One]
minusOne = Z Minus [One]
two = Z Plus [Zero, One]
three = Z Plus [One, One]
four = Z Plus [Zero, Zero, One]
minusFour = Z Minus [Zero, Zero, One]

-- add x y == z
x = Z Plus [Zero, One, Zero, One, One, Zero, One]
y = Z Plus [One, Zero, One, One, Zero, One, One]
z = Z Plus [One, One, One, Zero, Zero, Zero, One, One]
