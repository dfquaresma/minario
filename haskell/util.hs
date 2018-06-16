module Util ( 
    getRandomInteger 
) where  

-- Generate a random number given a range.
import System.Random
getRandomInteger :: (Int, Int) -> IO Int
getRandomInteger (a, b) = randomRIO (a, b)
