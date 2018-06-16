import System.Random

module Util  
( getRandomInteger 
) where  


getRandomInteger :: (Int, Int) -> IO Int
getRandomInteger (a, b) = randomRIO (a, b)
