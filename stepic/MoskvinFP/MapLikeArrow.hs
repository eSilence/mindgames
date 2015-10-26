module MapLikeArrow where

import Prelude hiding (lookup)

class MapLike m where
    empty :: m k v
    lookup :: Ord k => k -> m k v -> Maybe v
    insert :: Ord k => k -> v -> m k v -> m k v
    delete :: Ord k => k -> m k v -> m k v
    fromList :: Ord k => [(k,v)] -> m k v

newtype ArrowMap k v = ArrowMap { getArrowMap :: k -> Maybe v }

instance MapLike ArrowMap where
    empty = ArrowMap (const Nothing)

    lookup key (ArrowMap f) = f key

    fromList [] = empty
    fromList ((k,v):xs) = insert k v (fromList xs)

    insert key value (ArrowMap f) = ArrowMap (\k -> if k == key then Just value else f k)

    delete key (ArrowMap f) = ArrowMap  (\k -> if k == key then Nothing else f k)
