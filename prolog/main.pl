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
	shell("clear"),
	writeln(TutorialText),
	get_single_char(_),
	introduction(0).

introduction(SelectedText) :-
	(SelectedText = 3 -> 
		halt(0)
	;
		getIntroText(SelectedText,IntroductionText),
		shell("clear"),
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

updateGameScreen() :-
	shell("clear"),
	drawGameBoard(), 
	getNumberOfPlayers(PlayersAlive),  
	write("Players alive: "), writeln(PlayersAlive),
	write("Player lives? "),
	isPlayerAlive() -> (
		writeln("YES!")
	);
	writeln("YES!").

applyUserAction(27) :- 
	retract(quitGame(0)), 
	asserta(quitGame(1)),
	shell("clear"),
	writeln("Leaving Game...").
applyUserAction(UserAction) :-
	isPlayerAlive() -> (movement(UserAction, XVar, YVar),
		updatePlayerPosition(XVar, YVar),
		updateGameScreen(),
		getUserAction();
		getUserAction()
	);
	retract(quitGame(0)), 
	asserta(quitGame(1)).

boardReduction(0, _) :- 
	retract(endGame(0)), 
	asserta(endGame(1)).
boardReduction(N, W) :-
	sleep(1.4),
	deleteWallSize(W), 
	NewW is W + 1,
	setWallSize(NewW), 
	updateGameScreen(),
	NewN is N - 1,
	boardReduction(NewN, NewW).

gameLoop() :- 
	endGame(1);
	endGame(0),
	updateGameScreen(), 
	sleep(0.2),
	updateBotsPosition(30), 
	gameLoop().

gameSetup() :-
	asserta(endGame(0)),
	setWallSize(0), 
	thread_create(getUserAction(), UserThreadId),
	thread_create(boardReduction(5, 0), BoardThreadId),
	buildPlayer(),
	buildBots(29), 
	gameLoop(),
	thread_join(UserThreadId),
	thread_join(BoardThreadId).

main :-
	introduction(0),
	gameSetup(),
	halt(0).
