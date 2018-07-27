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
	clearScreen(),
	writeln(TutorialText),
	get_single_char(_),
	introduction(0).

introduction(SelectedText) :-
	(SelectedText = 3 -> 
		halt(0)
	;
		getIntroText(SelectedText,IntroductionText),
		clearScreen(),
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

:- dynamic endGame/2.

movement(119, -1, 0).
movement(115, 1, 0).
movement(100, 0, 1).
movement(97, 0, -1).

updateGameScreen() :-
	clearScreen(),
	drawGameBoard(), 
	getNumberOfPlayers(PlayersAlive),  
	write("Players alive: "), writeln(PlayersAlive).

getUserAction() :- 
	endGame(1).
getUserAction() :-
	endGame(0),
	get_single_char(UserAction),
	applyUserAction(UserAction).

applyUserAction(UserAction) :-
	movement(UserAction, XVar, YVar),
	(
	isPlayerAlive(),	
	updatePlayerPosition(XVar, YVar),
	updateGameScreen();
	retract(endGame(0)), 
	asserta(endGame(1))
	),
	getUserAction().

applyUserAction(27) :- 
	retract(endGame(0)), 
	asserta(endGame(1)),
	writeln("Leaving Game...").

applyUserAction(_) :- getUserAction().

boardReduction(0, _) :-
	endGame(1); 
	endGame(0),
	retract(endGame(0)), 
	asserta(endGame(1)).
boardReduction(N, W) :-
	endGame(1);
	endGame(0),
	sleep(1),
	deleteWallSize(W), 
	NewW is W + 1,
	setWallSize(NewW),
	NewN is N - 1,
	boardReduction(NewN, NewW).

gameLoop() :- 
	endGame(1),
	(
	isPlayerAlive(), 
	writeln("YOU SURVIVE!"); 
	writeln("YOU LOSE!")
	);
	endGame(0),
	updateGameScreen(),
	sleep(0.5),
	updateBotsPosition(30), 
	gameLoop().

gameSetup() :-
	asserta(endGame(0)),
	setWallSize(0), 
	buildPlayer(),
	buildBots(29), 
	thread_create(getUserAction(), UserThreadId),
	thread_create(boardReduction(10, 0), BoardThreadId),
	gameLoop(),
	thread_join(UserThreadId),
	thread_join(BoardThreadId).

clearScreen() :-
	shell("clear"),
	true.

main :-
	introduction(0),
	gameSetup(),
	halt(0).
