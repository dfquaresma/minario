import Display
import Players
import Board

import Data.IORef
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
runGameTime = 10000
updateBotsInterval = 200000
increaseWallSizeInterval = 1500000

getNewTmpBots :: Int -> Int -> Int -> [Player] -> [Player]
getNewTmpBots time lastBotUpdate wallSize bots = if ((time - lastBotUpdate) >= updateBotsInterval) 
    then getNewBotsState bots wallSize 
    else bots 

getNewWallSize :: Int -> Int -> Int -> Int
getNewWallSize time lastWallSizeUpdate wallSize = if ((time - lastWallSizeUpdate) >= increaseWallSizeInterval) 
    then wallSize + 1 
    else wallSize 

getNewBotsUpdate :: Int -> Int -> Int 
getNewBotsUpdate time lastBotsUpdate = if ((time - lastBotsUpdate) >= updateBotsInterval)
    then time + updateBotsInterval 
    else lastBotsUpdate

getNewWallSizeUpdate :: Int -> Int -> Int
getNewWallSizeUpdate time lastWallSizeUpdate = if ((time - lastWallSizeUpdate) >= increaseWallSizeInterval) 
    then time + increaseWallSizeInterval 
    else lastWallSizeUpdate

checkUserAction :: Char -> IO()
checkUserAction userAction = do
    if userAction == '\ESC' then exitSuccess
    else return ()

runGame :: IORef Char -> Int -> Int -> Int -> [Player] -> Int -> IO [Char]
runGame sharedChar time lastBotsUpdate lastBoardUpdate (player:bots) wallSize = do
    threadDelay runGameTime
    if isThatPlayerAlive player then do
        if wallSize > roundsToEndGame then return $ "Winner"
        else do
            let newBotsState = getNewTmpBots time lastBotsUpdate wallSize bots 
            let newWallSize = getNewWallSize time lastBoardUpdate wallSize

            userAction <- readIORef sharedChar
            checkUserAction userAction

            when ((time - lastBotsUpdate) >= updateBotsInterval 
                || (time - lastBoardUpdate) >= increaseWallSizeInterval 
                || userAction /= 'n') $ drawGameBoard board_height board_width wallSize (player:bots) 
            
            let newPlayerState = getNewPlayerState (player:newBotsState) (getNewPlayerPosition player userAction) newWallSize
            
            runGame sharedChar
                    (time + runGameTime)
                    (getNewBotsUpdate time lastBotsUpdate) 
                    (getNewWallSizeUpdate time lastBoardUpdate) 
                    (newPlayerState:newBotsState) 
                    newWallSize
    else return $ "Loser"
                
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
    else do 
        sharedChar <- newIORef 'n' -- do nothing
        threadId <- forkIO $ forever (do 
                            atomicWriteIORef sharedChar 'n' -- nothing
                            getUserAction sharedChar
                            threadDelay 10000) -- unlock MVar changes in getUserAction
        gameResult <- runGame sharedChar 0 0 0 (createPlayers newState) wallSize
        killThread threadId 
        if (gameResult == "Winner")
        then showWinnerWindow >>
            runMenu end_game_statement
        else showLoserWindow >>
            runMenu end_game_statement

getUserAction :: IORef Char -> IO()
getUserAction sharedChar = do 
    userAction <- getChar
    atomicWriteIORef sharedChar userAction
    return ()

main :: IO()
main = do
    hSetBuffering stdin NoBuffering
    hSetEcho stdin False
    showMainGameIntroduction
    runMenu menu_state_up
