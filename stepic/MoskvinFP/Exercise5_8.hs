module Exercise5_8 (
)   where

import Control.Monad.Reader
import Control.Monad.State
import Control.Monad.Writer

-- 5.8:3
readerToState :: Reader r a -> State r a
readerToState m = state $ \s -> (runReader m s,s)

-- 5.8:4
writerToState :: Monoid w => Writer w a -> State w a
writerToState m = state $ \s -> let (a, w) = runWriter m in (a, s `mappend` w)

-- 5.8:5
fibStep :: State (Integer, Integer) ()
fibStep = do
    (a, b) <- get
    put (b, a + b)

execStateN :: Int -> State s a -> s -> s
execStateN n m = execState (replicateM_ n m)

-- 5.8:6
data Tree a = Leaf a | Fork (Tree a) a (Tree a)
    deriving Show

tick :: State Integer Integer
tick = do
    n <- get
    put (n + 1)
    return n

numberTree :: Tree () -> Tree Integer
numberTree tree = evalState (numberTree' tree) 1

{-# ANN numberTree' "HLint: ignore Use liftM" #-}
numberTree' (Leaf _) = tick >>= return . Leaf
numberTree' (Fork l v r) = do
    l' <- numberTree' l
    v' <- tick
    r' <- numberTree' r
    return (Fork l' v' r')

t1 = numberTree (Leaf ())  -- Leaf 1
t2 = numberTree (Fork (Leaf ()) () (Leaf ()))  -- Fork (Leaf 1) 2 (Leaf 3)
