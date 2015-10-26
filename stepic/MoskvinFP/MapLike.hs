module MapLike where

import Prelude hiding (lookup)
import qualified Data.List as L

class MapLike m where
    empty :: m k v
    lookup :: Ord k => k -> m k v -> Maybe v
    insert :: Ord k => k -> v -> m k v -> m k v
    delete :: Ord k => k -> m k v -> m k v
    fromList :: Ord k => [(k,v)] -> m k v
    fromList [] = empty
    fromList ((k,v):xs) = insert k v (fromList xs)

newtype ListMap k v = ListMap { getListMap :: [(k,v)] }
    deriving (Eq,Show)


instance MapLike ListMap where
    empty = ListMap []

    delete key (ListMap []) = ListMap []
    delete key (ListMap ((k,v):xs)) = if k == key then ListMap xs else let xs' = getListMap $ delete key (ListMap xs) in ListMap ((k,v):xs')

    insert key value (ListMap []) = ListMap [(key, value)]
    insert key value lmap = case lookup key lmap of
        Just _ -> ListMap $ (:) (key, value) (getListMap $ delete key lmap)
        Nothing -> ListMap $ (:) (key, value) (getListMap lmap)

    lookup _ (ListMap []) = Nothing
    lookup key (ListMap ((k, v):xs)) = if key == k then Just v else lookup key (ListMap xs)
