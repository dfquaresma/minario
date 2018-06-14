import System.Random

data Player = Player {xPosition :: Int
                      , yPosition :: Int
                      , isAlive :: Bool
                      } deriving (Show)

randomInt :: (Int, Int) -> IO Int
randomInt range = do 
                  randInt <- (randomRIO range)
                  return randInt
             
xMin = 0 
xMax = 10
yMin = 0
yMax = 10
buildPlayer :: Player
buildPlayer = do 
              xPosition = (randomInt (xMin, xMax))
              yPosition = (randomInt (yMin, yMax))
              iLive = True
              newPlayer = Player xPosition yPosition iLive
              return newPlayer

createPlayers :: Int -> [Player]
createPlayers 0 = []
createPlayers n = buildPlayer : createPlayers (n - 1)

