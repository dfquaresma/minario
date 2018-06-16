import Util

module Players  
( buildPlayer,
createPlayers 
) where 

data Player = Player {xPosition :: Int, yPosition :: Int, isAlive :: Bool} deriving (Show)

xMin = 0 
xMax = 10
yMin = 0
yMax = 10
buildPlayer :: Player
buildPlayer = newPlayer
                where 
                    xPosition = 1-- <- getRandomInteger (xMin, xMax)
                    yPosition = 1-- <- getRandomInteger (yMin, yMax)
                    isAlive = True
                    newPlayer = Player xPosition yPosition isAlive 
                
createPlayers :: Int -> [Player]
createPlayers 0 = []
createPlayers n = buildPlayer : createPlayers (n - 1)
                    
                    