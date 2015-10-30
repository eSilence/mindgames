module Exercise5_6_2 (
)   where

import Control.Monad.Reader

type User = String
type Password = String
type UsersTable = [(User, Password)]

usersWithBadPasswords :: Reader UsersTable [User]
usersWithBadPasswords = do
    pwds <- ask
    if null pwds
        then return []
        else let
            (user, pass) = head pwds in do
            users <- local tail usersWithBadPasswords
            if pass == "123456"
                then return $ user : users
                else return users
