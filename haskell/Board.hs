module Board ( 
    drawGameBoard,
    buildGameBoard,
    buildBoard,
    buildRow
) where  
import Players
import System.Console.ANSI
import Control.Concurrent


drawGameBoard :: Int -> Int -> Int -> [Player] -> IO()
drawGameBoard width height state (player:bots) = do 
 clearScreen
 putStr (unlines (buildGameBoard width height state))
 boardDrawPlayer player
 boardDrawPlayers bots
 threadDelay 300000

buildGameBoard :: Int -> Int -> Int -> [[Char]]
buildGameBoard width height state = buildBoard width height width height state

boardDrawPlayers :: [Player] -> IO()
boardDrawPlayers [] = return ()
boardDrawPlayers (bot:bots) = do
 setCursorPosition (getYPositionOfPlayer bot) (getXPositionOfPlayer bot)
 if isThatPlayerAlive bot then putStr "X"
 else putStr "="
 boardDrawPlayers (bots)

boardDrawPlayer :: Player -> IO()
boardDrawPlayer player = do
 setCursorPosition (getYPositionOfPlayer player) (getXPositionOfPlayer player)
 putStr "O"

buildBoard :: Int -> Int -> Int -> Int -> Int -> [[Char]]
buildBoard _ (-1) _ _ _ = []
buildBoard x y width height state = buildBoard x (y-1) width height state ++ [buildRow x y width height state]

buildRow :: Int -> Int -> Int -> Int -> Int -> [Char]
buildRow 0 _ _ _ _ = []
buildRow x y width height state | x <= state || y < state || x > (width-state) || y > (height-state) = ['#'] ++ buildRow (x-1) (y) width height state
                                | otherwise = [' '] ++ buildRow (x-1) (y) width height state