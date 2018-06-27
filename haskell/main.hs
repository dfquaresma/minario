import Display

import Control.Concurrent
import Control.Monad
import Data.Maybe
import System.IO

wow :: IO()
wow = do
    c <- newEmptyMVar 
    hSetBuffering stdin NoBuffering
    hSetEcho stdin False
    forkIO $ do
        a <- getChar
        putMVar c a
        case a of
            's' -> showGameIntroductionStaticInstructions
            'w' -> showMainGameStaticStart 
            otherwise -> return () 
    
    wait c
    where wait c = do
          a <- tryTakeMVar c
          if isJust a then wow
          else 
               threadDelay 500 >> wait c


main :: IO()
main = do
    showMainGameIntroduction
    wow
