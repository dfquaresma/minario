module Players ( 
    buildPlayer,
    createPlayers,
    safeByView,
    checkSafeByViewPosition,
    newBotPosition,
    updateBotsPosition,
    samePosition,
    killAtPosition,
    updateDead,
    getNewBotsState,
    newPlayerPosition,
    updatePlayerPosition,
    getNewPlayerState,
    newPlayersState
) where 

import Util (getRandomInteger)

data Player = Player {
    xPosition :: Int, 
    yPosition :: Int, 
    identifier :: Int, 
    isAlive :: Bool
} deriving (Show)

data PlayerArrows = PlayerArrows {
    up :: Int, 
    down :: Int, 
    right :: Int, 
    left :: Int
} deriving (Show)

-- It returns a player.
xMin = 0 
xMax = 10
yMin = 0
yMax = 10
buildPlayer :: Int -> Player
buildPlayer id = newPlayer
                where 
                    xPosition = getRandomInteger (xMin, xMax)
                    yPosition = getRandomInteger (yMin, yMax)
                    isAlive = True
                    newPlayer = Player xPosition yPosition id isAlive 
                
-- It returns a list of players.
createPlayers :: Int -> [Player]
createPlayers 0 = []
createPlayers n = buildPlayer n : createPlayers (n - 1)

-- It checks if the given positions are safe positions considering view chance.
viewChance = 2
safeByView :: (Int, Int) -> (Int, Int) -> Bool
safeByView (x1, y1) (x2, y2) =  if viewChance == getRandomInteger (1, viewChance) 
                                    then x1 /= x2 || y1 /= y2 
                                else True

-- It checks if the given position is safe by view compared with (may) all other bots positions.
checkSafeByViewPosition :: [Player] -> (Int, Int) -> Bool 
checkSafeByViewPosition [] pos = True
checkSafeByViewPosition (headBot:tailBots) (xPos, yPos) = safeByView (xPos, yPos) (xPosition headBot, yPosition headBot) 
                                                  && checkSafeByViewPosition tailBots (xPos, yPos)

-- It gives a new positions given an old one.
botMovementRange = (-1, 1) 
newBotPosition :: (Int, Int) -> (Int, Int)
newBotPosition (xPos, yPos) = (xPos + getRandomInteger botMovementRange, yPos + getRandomInteger botMovementRange)                                                  

-- It gives a new bots distribution list. Note that it does not ensures that colliding bots are dead. 
updateBotsPosition :: [Player] -> [Player]
updateBotsPosition [] = []
updateBotsPosition (headBot:bots) =  if isAlive headBot then 
                                        if checkSafeByViewPosition bots newPos then -- TODO(Paulo): Inserts here a call to check if the bot collides with the boards.
                                            Player (fst newPos) (snd newPos) (identifier headBot) True : updateBotsPosition bots
                                        else
                                            updateBotsPosition (headBot:bots) -- try again with a newPos.

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
updateDead :: [Player] -> [Player] -> [Player]
updateDead players [] = players
updateDead players (headBot:bots) = updateDead (killAtPosition players (xHead, yHead) idHead) bots
                                        where
                                            xHead = xPosition headBot
                                            yHead = yPosition headBot
                                            idHead = identifier headBot

-- It returns a new bots state, a list with all bots after a movement.                                             
getNewBotsState :: [Player] -> [Player]
getNewBotsState bots = newBotsState
                    where
                        botAfterMovement = updateBotsPosition bots
                        newBotsState = updateDead botAfterMovement botAfterMovement


-- not implemented yet.
-- It returns the players arrows state.
-- TODO(Renato)
getPlayerArrows :: PlayerArrows
getPlayerArrows = PlayerArrows 0 0 0 0 -- example of return when no arrows were pressed.

-- It gives a new position for the player given an old one.
-- TODO(Renato)
newPlayerPosition :: (Int, Int) -> (Int, Int)
newPlayerPosition (xPos, yPos) = (xPos + rightVar + leftVar, yPos + upVar + downVar)
                                 where
                                    upVar = (up getPlayerArrows)
                                    downVar = (down getPlayerArrows)
                                    rightVar = (right getPlayerArrows)
                                    leftVar = (left getPlayerArrows)

-- It gives a new bots distribution list, but this one considers the head as  
-- the player. Note that it does not ensures that colliding bots are dead. 
updatePlayerPosition :: [Player] -> [Player]
updatePlayerPosition [] = []
updatePlayerPosition (player:bots) =  if isAlive player then 
                                        Player (fst newPos) (snd newPos) (identifier player) True : bots
                                    else 
                                        (player:bots)
                                  
                                    where newPos = newPlayerPosition (xPosition player, yPosition player)

-- It returns a list with the player and all bots.
getNewPlayerState :: [Player] -> [Player]
getNewPlayerState all = newPlayerState
                    where
                        playerAfterMovement = updatePlayerPosition all
                        newPlayerState = updateDead playerAfterMovement playerAfterMovement

-- It returns a new players state. It means a new list with player and all bots in new positions.                         
newPlayersState :: [Player] -> [Player]
newPlayersState (player:bots) = playersState
                    where
                        newBots = getNewBotsState bots
                        playersState = getNewPlayerState (player : newBots) 
                        
