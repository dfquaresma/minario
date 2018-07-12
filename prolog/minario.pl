introText(0,
'\n\t/////////////////////////////////\t Minário \t/////////////////////////////////
\n\t\tAmanda Luna, David Ferreira, Paulo Feitosa, Renato Henriques, Thomaz Diniz
\t\t\t\t\t> Começar o jogo
\n\n\t\t\t\t\t  Instruções
\n\n\t\t\tPressione [E] para selecionar a opção
\n\n\t\t\tPressione [Esc] a qualquer momento para fechar o jogo
\n\n\n\t///////////////////////////////////////////////////////////////////////////////////////////').

introText(1,
'\n\t/////////////////////////////////\t Minário \t/////////////////////////////////
\n\t\tAmanda Luna, David Ferreira, Paulo Feitosa, Renato Henriques, Thomaz Diniz
\t\t\t\t\t 		Começar o jogo
\n\n\t\t\t\t\t >Instruções
\n\n\t\t\tPressione [E] para selecionar a opção
\n\n\t\t\tPressione [Esc] a qualquer momento para fechar o jogo
\n\n\n\t///////////////////////////////////////////////////////////////////////////////////////////').

/*	W 		A 		S 		D 	 ENTER		ESC 	*/
/* 119 		97 	   115	   100 	  13 	 	 27		*/

getInputIntro(119,0).
getInputIntro(115,1).
getInputIntro(13,2).

introduction(SelectedText) :-
	(SelectedText = 0 ; SelectedText = 1) ->	
		textoIntro(SelectedText,IntroductionText),
		write(IntroductionText),nl,
		get_single_char(Input),
		getInputIntro(Input,InputIntro),
		introducao(InputIntro)
	; true.
 

gameLoop(State) :-
	get_single_char(Input),
	true.


:- initialization (main).
main :-
	introduction(0),
	gameLoop(0),
	halt(0).