module Players ( 
    buildPlayer,
    createPlayers,
    getNewBotsState 
) where 

import Util

data Player = Player {xPosition :: Int, yPosition :: Int, isAlive :: Bool} deriving (Show)

xMin = 0 
xMax = 10
yMin = 0
yMax = 10
-- return a player.
buildPlayer :: Player
buildPlayer = newPlayer
                where 
                    xPosition = 1-- <- getRandomInteger (xMin, xMax)
                    yPosition = 1-- <- getRandomInteger (yMin, yMax)
                    isAlive = True
                    newPlayer = Player xPosition yPosition isAlive 
                
-- return a list of players.
createPlayers :: Int -> [Player]
createPlayers 0 = []
createPlayers n = buildPlayer : createPlayers (n - 1)

-- to be implemented yet.
getNewBotsState :: [Player] -> [Player]
getNewBotsState [] = [] 
getNewBotsState n = n
                    