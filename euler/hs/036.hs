import Data.Char (intToDigit)
import Numeric (showIntAtBase)

isPalindromeBoth n = (s10 == reverse s10) && (s2 == reverse s2)
    where s10 = show n
          s2 = showIntAtBase 2 intToDigit n ""

main :: IO ()
main = print $ sum $ filter isPalindromeBoth [1..1000000]
