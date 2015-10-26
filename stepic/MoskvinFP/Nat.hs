module Nat where

data Nat = Zero | Suc Nat
    deriving Show

fromNat :: Nat -> Integer
fromNat Zero = 0
fromNat (Suc n) = fromNat n + 1

add :: Nat -> Nat -> Nat
add n Zero = n
add n (Suc k) = add (Suc n) k

mul :: Nat -> Nat -> Nat
mul k n = iter k n Zero
    where
        iter _ Zero s = s
        iter a (Suc b) s = iter a b (add s a)

fac :: Nat -> Nat
fac Zero = Suc Zero
fac k = iter k (Suc Zero)
    where iter Zero f = f
          iter k@(Suc k') f = iter k' (mul f k)


zero = Zero
one = Suc zero
two = Suc one
three = Suc two
