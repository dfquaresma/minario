module Players ( 
    buildPlayer,
    createPlayers,
    safeByView,
    checkSafeByViewPosition,
    newBotPosition,
    updateBotsPosition,
    samePosition,
    killAtPosition,
    updateDeadBots,
    getNewBotsState
) where 

import Util (getRandomInteger)

data Player = Player {xPosition :: Int, yPosition :: Int, identifier :: Int, isAlive :: Bool} deriving (Show)

xMin = 0 
xMax = 10
yMin = 0
yMax = 10
-- It returns a player.
buildPlayer :: Int -> Player
buildPlayer id = newPlayer
                where 
                    xPosition = 1-- <- getRandomInteger (xMin, xMax)
                    yPosition = 1-- <- getRandomInteger (yMin, yMax)
                    isAlive = True
                    newPlayer = Player xPosition yPosition id isAlive 
                
-- It returns a list of players.
createPlayers :: Int -> [Player]
createPlayers 0 = []
createPlayers n = buildPlayer n : createPlayers (n - 1)

-- It checks if is a safe position considering view chance.
viewChance = 2
safeByView :: (Int, Int) -> (Int, Int) -> Bool
safeByView (x1, y1) (x2, y2) =  if viewChance == viewChance -- getRandomInteger (1, viewChance) 
                                    then x1 /= x2 || y1 /= y2 
                                else True

-- It checks if the given position is safe compared with (may) all other bots positions.
checkSafeByViewPosition :: [Player] -> (Int, Int) -> Bool 
checkSafeByViewPosition [] pos = True
checkSafeByViewPosition (headBot:tailBots) (xPos, yPos) = safeByView (xPos, yPos) (xPosition headBot, yPosition headBot) 
                                                  && checkSafeByViewPosition tailBots (xPos, yPos)

-- It gives a new positions given an old one.
botMovementRange = (-1, 1) 
newBotPosition :: (Int, Int) -> (Int, Int)
newBotPosition (xPos, yPos) = (xPos + 0, yPos + 0) -- (xPos + getRandomInteger botMovementRange, yPos + getRandomInteger botMovementRange)                                                  

-- It gives a new bots distribution list. Note that it does not ensures that colliding bots are dead. 
updateBotsPosition :: [Player] -> [Player]
updateBotsPosition [] = []
updateBotsPosition (headBot:bots) =  if isAlive headBot then 
                                        if checkSafeByViewPosition bots newPos then 
                                            Player (fst newPos) (snd newPos) (identifier headBot) True : updateBotsPosition bots
                                        else
                                            updateBotsPosition (headBot:bots) -- try again a newPos.

                                    else 
                                        headBot : updateBotsPosition bots
                                  
                                    where newPos = newBotPosition (xPosition headBot, yPosition headBot)

-- Verify if two coordinates are the same.                                    
samePosition :: (Int, Int) -> (Int, Int) -> Bool
samePosition (x1, y1) (x2, y2) = x1 == x2 && y1 == y2

-- Kill all players at the given position.
killAtPosition :: [Player] -> (Int, Int) -> Int -> [Player]
killAtPosition [] x id = []
killAtPosition (head:tail) (x, y) id = if (idHead) /= id && isAlive head && samePosition (x, y) (xHead, yHead) 
                                        then Player xHead yHead idHead False : killAtPosition tail (x, y) id
                                    else head : killAtPosition tail (x, y) id
                                    where 
                                        xHead = xPosition head
                                        yHead = yPosition head
                                        idHead = identifier head

-- It verifies if there is any alive players collinding with each other or with a dead player or with the board and kill them.
updateDeadBots :: [Player] -> [Player] -> [Player]
updateDeadBots players [] = players
updateDeadBots players (headBot:bots) = updateDeadBots (killAtPosition players (xHead, yHead) idHead) bots
                                        where
                                            xHead = xPosition headBot
                                            yHead = yPosition headBot
                                            idHead = identifier headBot

getNewBotsState :: [Player] -> [Player]
getNewBotsState bots = newBotsState
                    where
                        botAfterMovement = updateBotsPosition bots
                        newBotsState = updateDeadBots botAfterMovement botAfterMovement

-- It returns a list with the player and all bots.
-- TODO(Renato)
updatePlayerState :: [Player] -> (Int, Int) -> [Player]
updatePlayerState (player:bots) (xPos, yPos) = [] 
