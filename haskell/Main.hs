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

winner_statement = 12
loser_statement = 10

game_state_easy = 30
game_state_medium = 50
game_state_hard = 100

board_width = 70
board_height = 30
board_wall_size = 1

interval_to_update_bots = 500000
getBots :: Int -> [Player] -> [Player]
getBots time bots = if (time `mod` interval_to_update_bots) == 0 then getNewBotsState bots board_wall_size else bots

checkUserAction :: Char -> IO()
checkUserAction userAction = do
    if userAction == '\ESC' then exitSuccess
    else return ()

interval_to_reduce_board = 3000000
runGame :: Int -> [Player] -> Int -> Int -> IO()
runGame timeBoard (player:bots) height width = do
        charGame <- newEmptyMVar
        forkIO $ do
            aux <- getChar
            putMVar charGame aux 
    
        wait charGame bots 0 height width
        where wait charGame bots time b_height b_width = do
              --showPlayers (player:bots) -- should update screen here.
              drawGameBoard b_height b_width board_wall_size (player:bots)
              aux <- tryTakeMVar charGame
              if isJust aux then do
                  let newBotsState = getBots time bots
                  let userAction = fromJust aux
                  checkUserAction userAction
                  let newPlayerState = getNewPlayerState (player:bots) (getNewPlayerPosition player userAction) board_wall_size
                  if isThatPlayerAlive newPlayerState then runGame (timeBoard + 5000)(newPlayerState:newBotsState) b_height b_width
                  else 
                      putStrLn "YOU LOSE!" >>  
                      runMenu loser_statement
              else           
                  -- Non player depending logic should be implemented here.
                  if (timeBoard `mod` interval_to_reduce_board) == 0 then threadDelay 5000 >> wait charGame (getBots time bots) (time + 5000) (b_height - 1) (b_width - 1)
                  else
                      threadDelay 5000 >> wait charGame (getBots time bots) (time + 5000) b_height b_width

showScreen :: Int -> Char -> IO()
showScreen state char | state == menu_state_up && char == 's' = showGameIntroductionStaticInstructions
                      | state == menu_state_down && char == 'w' = showMainGameStaticStart
                      
                      | state == menu_state_up && char == 'e' = showGameDifficultyOptionsEasy   
                      | state == menu_state_down && char == 'e' = showGameInstructionsWithDelay
                                         
                      | state == difficulty_state_easy && char == 's' = showGameDifficultyOptionsMedium
                      | state == difficulty_state_medium && char == 'w' = showGameDifficultyOptionsEasy
                      | state == difficulty_state_medium && char == 's' = showGameDifficultyOptionsHard
                      | state == difficulty_state_hard && char == 'w' = showGameDifficultyOptionsMedium

                      | state == winner_statement && (char == 'q' || char == 'e') = showMainGameStaticStart
                      | state == loser_statement && (char == 'q' || char == 'e') = showMainGameStaticStart
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
                        
                        | oldState == winner_statement && (char == 'q' || char == 'e') = menu_state_up
                        | oldState == loser_statement && (char == 'q' || char == 'e') = menu_state_up                           
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
    else runGame 0 (createPlayers newState) board_height board_width

main :: IO()
main = do
    hSetBuffering stdin NoBuffering
    hSetEcho stdin False
    showMainGameIntroduction
    runMenu menu_state_up
