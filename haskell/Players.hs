module Players ( 
    Player,
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
    updatePlayerPosition,
    getNewPlayerState,
    getNewPlayerPosition,
    isThatPlayerAlive,
    getXPositionOfPlayer,
    getYPositionOfPlayer,
    getBotInBoardCell
) where 

import Util (getRandomInteger)

data Player = Player {
    xPosition :: Int, 
    yPosition :: Int, 
    identifier :: Int, 
    isAlive :: Bool
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

-- It returns a list of players with no players collisions.
createPlayersEnsuringNoCollisions :: Int ->  Int -> [(Int, Int)] -> [Player]
createPlayersEnsuringNoCollisions totalOfPlayers 0 usedPositions = []
createPlayersEnsuringNoCollisions totalOfPlayers numberOfPlayersToCreate usedPositions = if not (elem (xPos, yPos) usedPositions) then 
                                                        newPlayer : (createPlayersEnsuringNoCollisions totalOfPlayers (numberOfPlayersToCreate - 1) ((xPos, yPos) : usedPositions))
                                                    else
                                                        createPlayersEnsuringNoCollisions totalOfPlayers numberOfPlayersToCreate usedPositions
                                                             
                                                    where 
                                                        newPlayer = buildPlayer (totalOfPlayers - numberOfPlayersToCreate)
                                                        xPos = xPosition newPlayer 
                                                        yPos = yPosition newPlayer 
                        
-- It returns a list of players.
createPlayers :: Int -> [Player]
createPlayers numberOfPlayers = createPlayersEnsuringNoCollisions numberOfPlayers numberOfPlayers []

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

-- It gives a new bots distribution list, but this one considers the head as  
-- the player. Note that it does not ensures that colliding bots are dead. 
updatePlayerPosition :: Player -> (Int, Int) -> Player
updatePlayerPosition player newPos =  if isAlive player then Player (fst newPos) (snd newPos) (identifier player) True else player
                                  
-- It returns a list with the player and all bots.
getNewPlayerState :: [Player] -> (Int, Int) -> Player
getNewPlayerState (player:bots) newPos = newPlayerState
                    where
                        playerAfterMovement = updatePlayerPosition player newPos
                        newPlayerState = (head (updateDead (playerAfterMovement:bots) (playerAfterMovement:bots)))

getNewPlayerPosition :: Player -> Char -> (Int, Int)
getNewPlayerPosition player char | char == 'w' = (xPos - 1, yPos)
                                 | char == 'a' = (xPos, yPos - 1) 
                                 | char == 's' = (xPos + 1, yPos)
                                 | char == 'd' = (xPos, yPos + 1)
                                 | otherwise = (xPos, yPos)
                      
                                 where 
                                     xPos = xPosition player
                                     yPos = yPosition player

isThatPlayerAlive :: Player -> Bool
isThatPlayerAlive player = isAlive player

getXPositionOfPlayer :: Player -> Int
getXPositionOfPlayer player = xPosition player

getYPositionOfPlayer :: Player -> Int
getYPositionOfPlayer player = yPosition player

getBotInBoardCell :: [Player] -> Int -> Int -> [Player]
getBotInBoardCell [] row col = []
getBotInBoardCell (headBot:bots) row col = if samePosition (xPosition headBot, yPosition headBot) (row, col) then [headBot]
    else getBotInBoardCell bots row col
