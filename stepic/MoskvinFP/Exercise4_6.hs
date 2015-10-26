module Exercise4_6 where

-- 4.6:3
newtype Xor = Xor { getXor :: Bool }
    deriving (Eq,Show)

instance Monoid Xor where
    mempty = Xor False
    mappend (Xor a) (Xor b) = Xor (a /= b)


-- 4.6:4
newtype Maybe' a = Maybe' { getMaybe :: Maybe a }
    deriving (Eq,Show)

instance Monoid a => Monoid (Maybe' a) where
    mempty = Maybe' $ Just mempty
    Maybe' Nothing `mappend` _ = Maybe' Nothing
    _ `mappend` Maybe' Nothing = Maybe' Nothing
    Maybe' x `mappend` Maybe' y = Maybe' (x `mappend` y)


-- 4.6:5
-- см. MapLike.hs

-- 4.6:6
-- см. MapLikeArrow.hs
