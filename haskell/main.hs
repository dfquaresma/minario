import Display

import Control.Concurrent
import Control.Monad
import Data.Maybe
import System.IO

menu_state_up = 1
menu_state_down = 2
difficulty_state_easy = 3
difficulty_state_medium = 4
difficulty_state_hard = 5
instruction_state = 6

showScreen :: Int -> Char -> IO()
showScreen state char | state == menu_state_up && char == 's' = showGameIntroductionStaticInstructions
                      | state == menu_state_down && char == 'w' = showMainGameStaticStart
                      
                      | state == menu_state_up && char == 'e' = showGameDifficultyOptionsEasy   
                      | state == menu_state_down && char == 'e' = showGameInstructions
                                         
                      | state == difficulty_state_easy && char == 's' = showGameDifficultyOptionsMedium
                      | state == difficulty_state_medium && char == 'w' = showGameDifficultyOptionsEasy
                      | state == difficulty_state_medium && char == 's' = showGameDifficultyOptionsHard
                      | state == difficulty_state_hard && char == 'w' = showGameDifficultyOptionsMedium
                     
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
                                                
                        | oldState == instruction_state && (char == 'q' || char == 'e') = menu_state_up
                        | (oldState == difficulty_state_easy || oldState == difficulty_state_medium || oldState == difficulty_state_hard)  && char == 'q' = menu_state_up
                         
                        | otherwise = oldState

run :: Int -> IO()
run state = do
    char <- newEmptyMVar 
    hSetBuffering stdin NoBuffering
    hSetEcho stdin False
    forkIO $ do
        aux <- getChar
        putMVar char aux 
    
    wait char
    where wait char = do
          aux <- tryTakeMVar char
          if isJust aux then do 
              showScreen state (fromJust aux)
              let newState = nextState state (fromJust aux)
              run newState
          else 
              threadDelay 500 >> wait char

main :: IO()
main = do
    showMainGameStaticStart
    run menu_state_up
