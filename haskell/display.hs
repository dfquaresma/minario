module Display ( 
    showMainGameIntroduction,
    showMainGameStaticStart,
    showGameIntroductionStaticInstructions,
    showGameInstructions,
    showGameDifficultyOptions,
    showGameDifficultyOptionsEasy,
    showGameDifficultyOptionsMedium,
    showGameDifficultyOptionsHard 
) where  

-- cabal install ansi-terminal
-- It specifically has functions for clearing the screen ***NEED THIS***
import System.Console.ANSI
import Control.Concurrent

showMainGameIntroduction :: IO ()
showMainGameIntroduction = do 
    clearScreen    
    putStrLn "\n\t/////////////////////////////////\t Minário \t/////////////////////////////////"
    threadDelay 200000
    putStrLn "\n\t\tAmanda Luna, David Ferreira, Paulo Feitosa, Renato Henriques, Thomaz Diniz"
    putStrLn "\n\n\n"
    threadDelay 200000
    putStrLn "\t\t\t\t\t> Começar o jogo"
    threadDelay 200000
    putStrLn "\n\n\t\t\t\t\t  Instruções"
    threadDelay 200000
    putStrLn "\n\n\t\t\tPressione [Esc] a qualquer momento para fechar o jogo"
    threadDelay 200000
    putStrLn "\n\n\n\t///////////////////////////////////////////////////////////////////////////////////////////"

showMainGameStaticStart :: IO ()
showMainGameStaticStart = do 
    clearScreen    
    putStrLn "\n\t/////////////////////////////////\t Minário \t/////////////////////////////////"
    putStrLn "\n\t\tAmanda Luna, David Ferreira, Paulo Feitosa, Renato Henriques, Thomaz Diniz"
    putStrLn "\n\n\n"
    putStrLn "\t\t\t\t\t> Começar o jogo"
    putStrLn "\n\n\t\t\t\t\t  Instruções"
    putStrLn "\n\n\t\t\tPressione [Esc] a qualquer momento para fechar o jogo"
    putStrLn "\n\n\n\t///////////////////////////////////////////////////////////////////////////////////////////"

showGameIntroductionStaticInstructions :: IO ()
showGameIntroductionStaticInstructions = do 
    clearScreen      
    putStrLn "\n\t/////////////////////////////////\t Minário \t/////////////////////////////////"
    putStrLn "\n\t\tAmanda Luna, David Ferreira, Paulo Feitosa, Renato Henriques, Thomaz Diniz"
    putStrLn "\n\n\n"
    putStrLn "\t\t\t\t\t   Começar o jogo"
    putStrLn "\n\n\t\t\t\t\t>  Instruções"
    putStrLn "\n\n\t\t\tPressione [Esc] a qualquer momento para fechar o jogo"
    putStrLn "\n\n\n\t///////////////////////////////////////////////////////////////////////////////////////////"

showGameInstructions :: IO ()
showGameInstructions = do 
    clearScreen      
    putStrLn "\n\t/////////////////////////////////\t Instruções \t/////////////////////////////////"
    threadDelay 200000
    putStrLn "\n\n\t\t\t\t\t\tObjetivo:"
    threadDelay 200000
    putStrLn "\n\n\t\tSobreviva o máximo de tempo sem bater nos limites do tabuleiro ou em outros jogadores."
    threadDelay 200000
    putStrLn "\n\n\t\t\t\t\t\tComandos:"
    putStrLn "\n\n\t\t\t\tUtilize as [Setas] do teclado para se movimentar"
    threadDelay 200000
    putStrLn "\n\n\n\t\t\t\t> Voltar"
    threadDelay 200000
    putStrLn "\n\n\t///////////////////////////////////////////////////////////////////////////////////////////"
    
showGameDifficultyOptions :: IO ()
showGameDifficultyOptions = do 
    clearScreen      
    putStrLn "\n\t/////////////////////////////////\tDificuldade \t/////////////////////////////////"
    threadDelay 200000
    putStrLn "\n\n\t\t\t\t\tEscolha uma dificuldade:"
    threadDelay 200000
    putStrLn "\n\n\t\t\t\t\t\t> Fácil"
    threadDelay 100000
    putStrLn "\n\n\t\t\t\t\t\t  Médio"
    threadDelay 100000
    putStrLn "\n\n\t\t\t\t\t\t  Difícil"
    threadDelay 100000
    putStrLn "\n\n\n\t\t\t\tPressione [Esc] a qualquer momento para fechar o jogo"
    threadDelay 200000
    putStrLn "\n\n\t///////////////////////////////////////////////////////////////////////////////////////////"
    
showGameDifficultyOptionsEasy :: IO ()
showGameDifficultyOptionsEasy = do 
    clearScreen      
    putStrLn "\n\t/////////////////////////////////\tDificuldade \t/////////////////////////////////"
    putStrLn "\n\n\t\t\t\t\tEscolha uma dificuldade:"
    putStrLn "\n\n\t\t\t\t\t\t> Fácil"
    putStrLn "\n\n\t\t\t\t\t\t  Médio"
    putStrLn "\n\n\t\t\t\t\t\t  Difícil"
    putStrLn "\n\n\n\t\t\t\tPressione [Esc] a qualquer momento para fechar o jogo"
    putStrLn "\n\n\t///////////////////////////////////////////////////////////////////////////////////////////"

showGameDifficultyOptionsMedium :: IO ()
showGameDifficultyOptionsMedium = do 
    clearScreen      
    putStrLn "\n\t/////////////////////////////////\tDificuldade \t/////////////////////////////////"
    putStrLn "\n\n\t\t\t\t\tEscolha uma dificuldade:"
    putStrLn "\n\n\t\t\t\t\t\t  Fácil"
    putStrLn "\n\n\t\t\t\t\t\t> Médio"
    putStrLn "\n\n\t\t\t\t\t\t  Difícil"
    putStrLn "\n\n\n\t\t\t\tPressione [Esc] a qualquer momento para fechar o jogo"
    putStrLn "\n\n\t///////////////////////////////////////////////////////////////////////////////////////////"
    
showGameDifficultyOptionsHard:: IO ()
showGameDifficultyOptionsHard = do 
    clearScreen      
    putStrLn "\n\t/////////////////////////////////\tDificuldade \t/////////////////////////////////"
    putStrLn "\n\n\t\t\t\t\tEscolha uma dificuldade:"
    putStrLn "\n\n\t\t\t\t\t\t  Fácil"
    putStrLn "\n\n\t\t\t\t\t\t  Médio"
    putStrLn "\n\n\t\t\t\t\t\t> Difícil"
    putStrLn "\n\n\n\t\t\t\tPressione [Esc] a qualquer momento para fechar o jogo"
    putStrLn "\n\n\t///////////////////////////////////////////////////////////////////////////////////////////"
        
    


