import Display
import Players
import Board
import Util

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

end_game_statement = 7

game_state_easy = 10
game_state_medium = 20
game_state_hard = 40

board_width = getMaxXCoord
board_height = getMaxYCoord
board_wall_size = 1

roundsToEndGame = (getMaxYCoord `div` 2) - 2
waitingTime = 20000
interval_to_update_bots = (3 * waitingTime)
interval_to_increase_board_wall_size = (10 * waitingTime)

getNewTmpBots :: Int -> [Player] -> [Player]
getNewTmpBots time bots = if (time >= interval_to_update_bots) then getNewBotsState bots board_wall_size else bots

getNewBoard_wall_size :: Int -> Int -> Int
getNewBoard_wall_size time board_wall_size = if (time == interval_to_increase_board_wall_size) then board_wall_size + 1 else board_wall_size

getNewTimeToUpdateBots :: Int -> Int -> Int 
getNewTimeToUpdateBots timeToUpdateBots waitingTime= if timeToUpdateBots <= interval_to_update_bots then timeToUpdateBots + waitingTime else waitingTime

getNewTimeToUpdateBoard :: Int -> Int -> Int
getNewTimeToUpdateBoard timeToUpdateBoard waitingTime= if timeToUpdateBoard <= interval_to_increase_board_wall_size then timeToUpdateBoard + waitingTime else waitingTime

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
        where wait charGame (tmpPlayer:tmpBots) timeToUpdateBots timeToUpdateBoard currBoard_wall_size = do
                if isThatPlayerAlive tmpPlayer then do
                    drawGameBoard board_height board_width currBoard_wall_size (player:tmpBots) 
                    let newBotsState = getNewTmpBots timeToUpdateBots tmpBots
                    let newBoard_wall_size = getNewBoard_wall_size (timeToUpdateBoard + waitingTime) currBoard_wall_size
                    let newTimeToUpdateBots = getNewTimeToUpdateBots timeToUpdateBots waitingTime
                    let newTimeToUpdateBoard = getNewTimeToUpdateBoard timeToUpdateBoard waitingTime
                    threadDelay waitingTime
                    aux <- tryTakeMVar charGame
                    if currBoard_wall_size > roundsToEndGame then 
                        showWinnerWindow >>
                        runMenu end_game_statement

                    else if isJust aux then do
                        let userAction = fromJust aux
                        checkUserAction userAction
                        let newPlayerState = getNewPlayerState (player:newBotsState) (getNewPlayerPosition player userAction) newBoard_wall_size
                        runGame newTimeToUpdateBots newTimeToUpdateBoard (newPlayerState:newBotsState) newBoard_wall_size

                    else                                                       
                        threadDelay waitingTime >>
                        wait charGame (updateDead (tmpPlayer:newBotsState) (tmpPlayer:newBotsState) currBoard_wall_size) newTimeToUpdateBots newTimeToUpdateBoard newBoard_wall_size
        
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
    userAction <- getChar
    checkUserAction userAction
    showScreen state userAction
    let newState = nextState state userAction
    if newState /= game_state_easy && newState /= game_state_medium && newState /= game_state_hard then runMenu newState
    else runGame 0 0 (createPlayers newState) board_wall_size

main :: IO()
main = do
    hSetBuffering stdin NoBuffering
    hSetEcho stdin False
    showMainGameIntroduction
    runMenu menu_state_up
