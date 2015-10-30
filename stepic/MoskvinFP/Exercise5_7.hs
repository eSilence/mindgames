module Exercise5_7 (
)   where

import Control.Monad.Writer

-- 5.7:2
type Shopping = Writer ([String], Sum Integer) ()

shopping1 :: Shopping
shopping1 = do
  purchase "Jeans"   19200
  purchase "Water"     180
  purchase "Lettuce"   328

purchase :: String -> Integer -> Shopping
purchase item cost = tell ([item] , Sum cost)

total :: Shopping -> Integer
total = getSum . snd . execWriter

items :: Shopping -> [String]
items = fst . execWriter
