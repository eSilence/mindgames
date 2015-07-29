import Data.Bits

xored :: [Int] -> Int
xored (x:xs) = foldl xor x xs

findBit :: Int -> Int
findBit n = head [b | b <- [1..], testBit n b]

main :: IO ()
main = do
        putStr $ show arr2
        putStr " ==> "
        print [num1, num2]
    where
        arr2 = [4, 5, 23, 7, 7, 23, 4, 9, 11, 5]
        -- XOR сумма всех элементов
        ans = xored arr2
        -- первый единичный бит
        bit1 = findBit ans
        -- первое непарное число как результат XOR суммы чисел с единичным
        -- битом в ожидаемом месте
        num1 = xored $ filter (`testBit` bit1) arr2
        -- второе непарное число
        num2 = num1 `xor` ans

