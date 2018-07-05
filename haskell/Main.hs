import Display
import Players
import Board

import Control.Concurrent
import Control.Monad
import Data.Maybe
import System.IO
import System.Exit

menu_state_up = 1
menu_state_down = 2
difficulty_state_easy = 3
difficulty_state_medium = 4
difficulty_state_hard = 5
instruction_state = 6

end_game_statement = 10

board_width = 70
board_height = 30

game_state_easy = 30
game_state_medium = 50
game_state_hard = 100

roundsToEndGame = 12
waitingTime = 100000
updateBotsInterval = 300000
increaseWallSizeInterval = 3000000

getNewTmpBots :: Int -> [Player] -> Int -> [Player]
getNewTmpBots time bots wallSize = if (time >= updateBotsInterval) then getNewBotsState bots wallSize else bots

getNewWallSize :: Int -> Int -> Int
getNewWallSize time wallSize = if (time >= increaseWallSizeInterval) then wallSize + 1 else wallSize

getNewTimeToUpdateBots :: Int -> Int -> Int 
getNewTimeToUpdateBots timeToUpdateBots waitingTime = if timeToUpdateBots <= updateBotsInterval 
    then timeToUpdateBots + waitingTime 
    else waitingTime

getNewTimeToUpdateBoard :: Int -> Int -> Int
getNewTimeToUpdateBoard timeToUpdateBoard waitingTime = if timeToUpdateBoard <= increaseWallSizeInterval 
    then timeToUpdateBoard + waitingTime 
    else waitingTime

checkUserAction :: Char -> IO()
checkUserAction userAction = do
    if userAction == '\ESC' then exitSuccess
    else return ()

runGame :: Int -> Int -> [Player] -> Int -> IO()
runGame botsTime boardTime (player:bots) gameBoard_wall_size = do
        charGame <- newEmptyMVar
        forkIO $ do
            aux <- getChar
            putMVar charGame aux 

        wait charGame (player:bots) botsTime boardTime gameBoard_wall_size
        where wait charGame (tmpPlayer:tmpBots) timeToUpdateBots timeToUpdateBoard currentWallSize = do
                if isThatPlayerAlive tmpPlayer then do
                    drawGameBoard board_height board_width currentWallSize (player:tmpBots) 
                    let newBotsState = getNewTmpBots timeToUpdateBots tmpBots currentWallSize
                    let newBoard_wall_size = getNewWallSize (timeToUpdateBoard + waitingTime) currentWallSize
                    threadDelay waitingTime
                    aux <- tryTakeMVar charGame
                    if currentWallSize > roundsToEndGame then 
                        showWinnerWindow >>
                        runMenu end_game_statement

                    else if isJust aux then do
                        let userAction = fromJust aux
                        checkUserAction userAction
                        let newPlayerState = getNewPlayerState (player:newBotsState) (getNewPlayerPosition player userAction) newBoard_wall_size
                        runGame (getNewTimeToUpdateBots timeToUpdateBots waitingTime) (getNewTimeToUpdateBoard timeToUpdateBoard waitingTime) (newPlayerState:newBotsState) newBoard_wall_size

                    else                                                       
                        threadDelay waitingTime >>
                        wait charGame (updateDead (tmpPlayer:newBotsState) (tmpPlayer:newBotsState) currentWallSize) (getNewTimeToUpdateBots timeToUpdateBots waitingTime) (getNewTimeToUpdateBoard timeToUpdateBoard waitingTime) newBoard_wall_size
        
                else 
                    showLoserWindow >>
                    runMenu end_game_statement

showScreen :: Int -> Char -> IO()
showScreen state char | state == menu_state_up && char == 's' = showGameIntroductionStaticInstructions
                      | state == menu_state_down && char == 'w' = showMainGameStaticStart
                      
                      | state == menu_state_up && char == 'e' = showGameDifficultyOptionsEasy   
                      | state == menu_state_down && char == 'e' = showGameInstructionsWithDelay
                                         
                      | state == difficulty_state_easy && char == 's' = showGameDifficultyOptionsMedium
                      | state == difficulty_state_medium && char == 'w' = showGameDifficultyOptionsEasy
                      | state == difficulty_state_medium && char == 's' = showGameDifficultyOptionsHard
                      | state == difficulty_state_hard && char == 'w' = showGameDifficultyOptionsMedium

                      | state == end_game_statement && (char == 'q' || char == 'e') = showMainGameStaticStart
                      | state == instruction_state && (char == 'q' || char == 'e') = showMainGameStaticStart
                      | (state == difficulty_state_easy || state == difficulty_state_medium || state == difficulty_state_hard)  && char == 'q' = showMainGameStaticStart
                      
                      | otherwise = return () 

nextState :: Int -> Char -> Int
nextState oldState char | oldState == menu_state_up && char == 's' = menu_state_down
                        | oldState == menu_state_down && char == 'w' = menu_state_up    
                                          
                        | oldState == menu_state_up && char == 'e' = difficulty_state_easy
                        | oldState == menu_state_down && char == 'e' = instruction_state

                        | oldState == difficulty_state_easy && char == 's' = difficulty_state_medium
                        | oldState == difficulty_state_medium && char == 'w' = difficulty_state_easy
                        | oldState == difficulty_state_medium && char == 's' = difficulty_state_hard
                        | oldState == difficulty_state_hard && char == 'w' = difficulty_state_medium
                                                
                        | oldState == difficulty_state_easy && char == 'e' = game_state_easy
                        | oldState == difficulty_state_medium && char == 'e' = game_state_medium
                        | oldState == difficulty_state_hard && char == 'e' = game_state_hard 
                        
                        | oldState == end_game_statement && (char == 'q' || char == 'e') = menu_state_up                           
                        | oldState == instruction_state && (char == 'q' || char == 'e') = menu_state_up
                        | (oldState == difficulty_state_easy || oldState == difficulty_state_medium || oldState == difficulty_state_hard)  && char == 'q' = menu_state_up
                         
                        | otherwise = oldState

runMenu :: Int -> IO()
runMenu state = do
    let wallSize = 1
    userAction <- getChar
    checkUserAction userAction
    showScreen state userAction
    let newState = nextState state userAction
    if newState < game_state_easy then runMenu newState
    else runGame 0 0 (createPlayers newState) wallSize

main :: IO()
main = do
    hSetBuffering stdin NoBuffering
    hSetEcho stdin False
    showMainGameIntroduction
    runMenu menu_state_up
