module ParsePerson where

import Data.Char

data Error = ParsingError | IncompleteDataError | IncorrectDataError String
    deriving Show

data Person = Person { firstName :: String, lastName :: String, age :: Int }
    deriving Show

parsePerson :: String -> Either Error Person
parsePerson s = case toMap $ map (getNameValue . words) $ lines s of
    Just m -> case lookup "firstName" m of
            Just firstName -> case lookup "lastName" m of
                Just lastName -> case lookup "age" m of
                    Just age -> if all isDigit age
                                then Right Person {
                                    firstName = firstName,
                                    lastName = lastName,
                                    age = read age }
                                else Left $ IncorrectDataError age
                    Nothing -> Left IncompleteDataError
                Nothing -> Left IncompleteDataError
            Nothing -> Left IncompleteDataError
    Nothing ->  Left ParsingError

getNameValue :: [String] -> Maybe (String, String)
getNameValue [x,y,z] = if y == "=" then Just (x, z) else Nothing
getNameValue _ = Nothing

toMap :: [Maybe (String, String)] -> Maybe [(String, String)]
toMap [] = Just []
toMap (x:xs) = case x of
    Just x' -> case toMap xs of
        Just xs' -> Just (x':xs')
        Nothing -> Nothing
    Nothing -> Nothing


-- examples
ex = "firstName = John\nlastName = Connor\nage = 30"
err = "firstName = John\nlastName = Connor\nfoo\nage = 30"
incom = "firstName = John\nlastName = Connor"
incor = "firstName = John\nlastName = Connor\nage = 30v"
