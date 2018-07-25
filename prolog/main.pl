:- use_module(display).
:- use_module(players).
:- use_module(board).
:- initialization (main).

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

:- dynamic quitGame/2.
:- dynamic endGame/2.

movement(119, -1, 0).
movement(115, 1, 0).
movement(100, 0, 1).
movement(97, 0, -1).

getUserAction() :- 
	endGame(1);
	endGame(0),
	get_single_char(UserAction),
	applyUserAction(UserAction).

applyUserAction(27) :- 
	retract(quitGame(0)), 
	asserta(quitGame(1)),
	writeln("Leaving Game...").
applyUserAction(UserAction) :-
	movement(UserAction, XVar, YVar),
	updatePlayerPosition(XVar, YVar),
	getUserAction();
	getUserAction().

numberOfPlayers(50).

gameLoop() :- 
	endGame(1);
	endGame(0),
	sleep(0.5),
	numberOfPlayers(NumberOfPlayers), updateBotsPosition(NumberOfPlayers), 
	drawGameBoard(),
	gameLoop().

gameSetup() :-
	asserta(endGame(0)),
	thread_create(getUserAction(), UserThreadId),
	numberOfPlayers(NumberOfPlayers), 
	buildPlayers(NumberOfPlayers),
	gameLoop(),
	thread_join(UserThreadId).

main :-
	introduction(0),
	gameSetup(),
	halt(0).