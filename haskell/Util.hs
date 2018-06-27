module Util ( 
    getRandomInteger 
) where  

-- Generate a random number given a range.
import System.IO.Unsafe
import System.Random
getRandomInteger :: (Int, Int) -> Int
getRandomInteger (a, b) = unsafePerformIO (randomRIO (a, b))
