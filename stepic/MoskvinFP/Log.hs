module MoskvinFP.Log where

import Data.Time.Clock
import Data.Time.Format

timeToString :: UTCTime -> String
timeToString = formatTime defaultTimeLocale "%a %d %T"

data LogLevel = Error | Warning | Info

data LogEntry = LogEntry {
        timestamp :: UTCTime,
        logLevel :: LogLevel,
        message :: String
    }

logLevelToString :: LogLevel -> String
logLevelToString Error = "Error"
logLevelToString Warning = "Warning"
logLevelToString Info = "Info"

logEntryToString :: LogEntry -> String
logEntryToString e = concat [
    timeToString $ timestamp e
    , ": "
    , logLevelToString $ logLevel e
    , ": "
    , message e
    ]
