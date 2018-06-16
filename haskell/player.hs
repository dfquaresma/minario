module Players ( 
    buildPlayer,
    createPlayers,
    safeByView,
    checkSafeByViewPosition,
    newBotPosition,
    updateBotsPosition
) where 

import Util (getRandomInteger)

data Player = Player {xPosition :: Int, yPosition :: Int, isAlive :: Bool} deriving (Show)

xMin = 0 
xMax = 10
yMin = 0
yMax = 10
-- It returns a player.
buildPlayer :: Player
buildPlayer = newPlayer
                where 
                    xPosition = 1-- <- getRandomInteger (xMin, xMax)
                    yPosition = 1-- <- getRandomInteger (yMin, yMax)
                    isAlive = True
                    newPlayer = Player xPosition yPosition isAlive 
                
-- It returns a list of players.
createPlayers :: Int -> [Player]
createPlayers 0 = []
createPlayers n = buildPlayer : createPlayers (n - 1)

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
                                            Player (fst newPos) (snd newPos) True : updateBotsPosition bots
                                        else
                                            updateBotsPosition (headBot:bots) -- try again a newPos.

                                    else 
                                        headBot : updateBotsPosition bots
                                  
                                    where newPos = newBotPosition (xPosition headBot, yPosition headBot)
               
-- It verifies if there is any alive players collinding with each other or with a dead player or with the board and kill them.
-- TODO (David)                                         
updateDeadBots :: [Player] -> [Player]
updateDeadBots [] = []
updateDeadBots (headBot:bots) = updateDeadBots bots
                                    
-- It returns a list with the player and all bots.
-- TODO(Renato)
updatePlayerState :: [Player] -> (Int, Int) -> [Player]
updatePlayerState (player:bots) (xPos, yPos) = [] 
