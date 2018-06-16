module Players ( 
    buildPlayer,
    createPlayers,
    getNewBotsState,
    checkSafePosition,
    updatePlayerState 
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
-- TODO(David)
checkSafePosition :: [Player] -> (Int, Int) -> Bool 
checkSafePosition bots position = False

-- to be implemented yet.
-- TODO(David)
getNewBotsState :: [Player] -> [Player]
getNewBotsState bots = []
                    
-- to be implemented yet.
-- TODO(David)
updatePlayerState :: [Player] -> (Int, Int) -> [Player]
updatePlayerState playerAndBots position = []
