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

/*	W 		A 		S 		D 	 ENTER		ESC 	*/
/* 119 		97 	   115	   100 	  13 	 	 27		*/

getInputIntro(119,0).
getInputIntro(115,1).
getInputIntro(13,2).

tutorial() :- 
	getTutorialText(TutorialText),
	write(TutorialText),nl,
	get_single_char(Input),
	introduction(0).


introduction(SelectedText) :-
	getIntroText(SelectedText,IntroductionText),
	write(IntroductionText),nl,
	get_single_char(Input),
	getInputIntro(Input,InputIntro),
	(( not(InputIntro = 2) ) ->
		introduction(InputIntro)
	;
		(SelectedText = 0 ->
			true
		; SelectedText = 1 ->
			tutorial())).
	

gameLoop(State) :-
	get_single_char(Input),
	true.


:- initialization (main).
main :-
	introduction(0),
	gameLoop(0),
	halt(0).