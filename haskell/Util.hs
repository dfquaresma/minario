module Util ( 
    getRandomInteger,
    clearScreen,
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
