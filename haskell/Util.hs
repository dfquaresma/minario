module Util ( 
    getRandomInteger,
    clearScreen,
    getMaxXCoord,
    getMaxYCoord,
    putAsShell
) where  

-- Generate a random number given a range.
import System.IO.Unsafe
import System.Random
import System.Process as SP

getRandomInteger :: (Int, Int) -> Int
getRandomInteger (a, b) = unsafePerformIO (randomRIO (a, b))

clearScreen :: IO ()
clearScreen = do
  SP.system "clear"
  return ()

putAsShell :: String -> IO()
putAsShell str = do
  SP.system ("echo '" ++ str ++ "'")
  return ()

getMaxXCoord :: Int
getMaxXCoord = 40

getMaxYCoord :: Int
getMaxYCoord = 20
