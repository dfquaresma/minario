:- initialization (main).

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
getInputIntro(27,3).

tutorial() :- 
	getTutorialText(TutorialText),
	writeln(TutorialText),
	get_single_char(_),
	introduction(0).

introduction(SelectedText) :-
	(SelectedText = 3 -> 
		halt(0)
	;
		getIntroText(SelectedText,IntroductionText),
		writeln(IntroductionText),
		get_single_char(Input),
		getInputIntro(Input,InputIntro),
		(( not(InputIntro = 2)  ) ->
			introduction(InputIntro)
		;
			(SelectedText = 0 ->
				true
			; SelectedText = 1 ->
				tutorial()))).

:- dynamic playerPosition/2.
:- dynamic quitGame/2.
:- dynamic endGame/2.

movement(119, -1, 0).
movement(115, 1, 0).
movement(100, 0, 1).
movement(97, 0, -1).

getUserAction() :- endGame(1).
getUserAction() :-
	endGame(0),
	get_single_char(UserAction),
	applyUserAction(UserAction).

applyUserAction(UserAction) :-
	playerPosition(X, Y),
	movement(UserAction, MovX, MovY),
	NewX is (X + MovX),
	NewY is (Y + MovY),
	retract(playerPosition(X, Y)),
	asserta(playerPosition(NewX, NewY)),
	getUserAction().

applyUserAction(27) :- 
	retract(quitGame(0)), 
	asserta(quitGame(1)),
	writeln("Leaving Game...").

applyUserAction(_) :- getUserAction().

gameSetup() :-
	asserta(endGame(0)),
	asserta(playerPosition(0, 0)),
	thread_create(getUserAction(), UserThreadId),
	gameLoop("Any"),
	thread_join(UserThreadId).

gameLoop(State) :- quitGame(1).
gameLoop(State) :-
	quitGame(0),
	sleep(1),
	playerPosition(X, Y),
	write(X), write(" "), writeln(Y),
	gameLoop(State).

main :-
	asserta(quitGame(0)),
	introduction(0),
	gameSetup(),
	halt(0).

