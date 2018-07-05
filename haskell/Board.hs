module Board ( 
    drawGameBoard,
    buildGameBoard,
    buildBoard,
    buildRow
) where  
import Players
import Util
import Control.Concurrent

--It draws the game board given a width, height, boardState (how many walls there is), Player list
drawGameBoard :: Int -> Int -> Int -> [Player] -> IO()
drawGameBoard height width wallSize (player:bots) = do 
    clearScreen 
    putAsShell (unlines (buildGameBoard height width wallSize (player:bots))) 

--builds the board as a list of chars
buildGameBoard :: Int -> Int -> Int -> [Player] -> [[Char]]
buildGameBoard height width wallSize (player:bots) = buildBoard height width height width wallSize (player:bots)

--builds the board
buildBoard :: Int -> Int -> Int -> Int -> Int -> [Player] -> [[Char]]
buildBoard 0 _ _ _ _ _ = []
buildBoard row col height width wallSize (player:bots) = 
    buildBoard (row - 1) col height width wallSize (player:bots) ++ [buildRow row col height width wallSize (player:bots)]

--builds each row of the board
buildRow :: Int -> Int -> Int -> Int -> Int -> [Player] -> [Char]
buildRow _ 0 _ _ _ _ = [] 
buildRow row col height width wallSize (player:bots) = if ((getXPositionOfPlayer player, getYPositionOfPlayer player) == (row, col)) 
        then buildRow row (col - 1) height width wallSize (player:bots) ++ [getPlayerDraw ] 
    else if (length (getBotInBoardCell bots row col) > 0) 
        then buildRow row (col - 1) height width wallSize (player:bots) ++ [getBotDraw ((getBotInBoardCell bots row col) !! 0)] 
    else if (row <= wallSize || row >= (height - wallSize + 1) || col <= wallSize || col >= (width - wallSize + 1)) 
        then buildRow row (col - 1) height width wallSize (player:bots) ++ ['#']
    else buildRow row (col - 1) height width wallSize (player:bots) ++ [' '] 

--Draws the bot list on top of the board
getBotDraw :: Player -> Char
getBotDraw bot = if isThatPlayerAlive bot then 'X' else '='

getPlayerDraw :: Char
getPlayerDraw = 'O'
