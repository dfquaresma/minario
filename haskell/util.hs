import System.Random

getRandomInteger :: (Int, Int) -> IO Int
getRandomInteger (a, b) = randomRIO (a, b)
