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

game_state_easy = 30
game_state_medium = 50
game_state_hard = 100

board_width = 30
board_height = 70
board_wall_size = 1

interval_to_update_bots = 1000000
getNewTmpBots :: Int -> [Player] -> [Player]
getNewTmpBots time bots = if (time `mod` interval_to_update_bots) == 0 then getNewBotsState bots board_wall_size else bots

interval_to_increase_board_wall_size = 3000000
getNewBoard_wall_size :: Int -> Int -> Int
getNewBoard_wall_size time board_wall_size = if (time `mod` interval_to_increase_board_wall_size) == 0 then board_wall_size + 1 else board_wall_size

checkUserAction :: Char -> IO()
checkUserAction userAction = do
    if userAction == '\ESC' then exitSuccess
    else return ()

waitingTime = 500
runGame :: Int -> [Player] -> Int -> IO()
runGame gameTime (player:bots) gameBoard_wall_size = do
        charGame <- newEmptyMVar
        forkIO $ do
            aux <- getChar
            putMVar charGame aux 

        wait charGame bots gameTime gameBoard_wall_size
        where wait charGame tmpBots time currBoard_wall_size = do
                if isThatPlayerAlive player then do
                    drawGameBoard board_width board_height currBoard_wall_size (player:tmpBots) 
                    let newBoard_wall_size = getNewBoard_wall_size time currBoard_wall_size
                    let newBotsState = getNewTmpBots time tmpBots
                    aux <- tryTakeMVar charGame
                    if newBoard_wall_size >= 14 then 
                        showWinnerWindow >>
                        runMenu end_game_statement

                    else if isJust aux then do
                        let userAction = fromJust aux
                        checkUserAction userAction
                        let newPlayerState = getNewPlayerState (player:newBotsState) (getNewPlayerPosition player userAction) newBoard_wall_size
                        runGame time (newPlayerState:newBotsState) newBoard_wall_size

                    else           
                        threadDelay waitingTime >>
                        wait charGame newBotsState (time + waitingTime) newBoard_wall_size
    
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
    if newState < game_state_easy then runMenu newState
    else runGame 0 (createPlayers newState) board_wall_size

main :: IO()
main = do
    hSetBuffering stdin NoBuffering
    hSetEcho stdin False
    showMainGameIntroduction
    runMenu menu_state_up
