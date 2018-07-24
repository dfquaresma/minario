:- module(
    'display', 
    [getIntroText/2]
).


getIntroText(0,
'\n\t/////////////////////////////////\t Minário \t/////////////////////////////////
\n\t\tAmanda Luna, David Ferreira, Paulo Feitosa, Renato Henriques, Thomaz Diniz
\t\t\t\t\t> Começar o jogo
\n\n\t\t\t\t\t Instruções
\n\n\t\t\tPressione [ENTER] para selecionar a opção
\n\n\t\t\tPressione [Esc] a qualquer momento para fechar o jogo
\n\n\n\t///////////////////////////////////////////////////////////////////////////////////////////').


getIntroText(1,
'\n\t/////////////////////////////////\t Minário \t/////////////////////////////////
\n\t\tAmanda Luna, David Ferreira, Paulo Feitosa, Renato Henriques, Thomaz Diniz
\t\t\t\t\t Começar o jogo
\n\n\t\t\t\t\t >Instruções
\n\n\t\t\tPressione [ENTER] para selecionar a opção
\n\n\t\t\tPressione [Esc] a qualquer momento para fechar o jogo
\n\n\n\t///////////////////////////////////////////////////////////////////////////////////////////').


getTutorialText('\n\t/////////////////////////////////\t Instruções \t/////////////////////////////////
\n\n\t\t\t\t\t\tObjetivo:
\n\n\t\tSobreviva o máximo de tempo sem bater nos limites do tabuleiro ou em outros jogadores.
\n\n\t\t\t\t\t\tComandos:
\n\n\t\t\t\tUtilize [W, A, S, D] para se movimentar
\n\n\n\t\t\t\t> Voltar').