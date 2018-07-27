:- module(
    'board', 
    [drawGameBoard/0,
	deleteWallSize/1,
	setWallSize/1,
	isCollidingWithBoard/2
	]
).
/*:- use_module(players, [isPlayerPosition/2, isBotPosition/2]).*/

deleteWallSize(W) :- 
	retract(wallSize(W)).

setWallSize(W) :- 
	assertz(wallSize(W)).

isCollidingWithBoard(X, Y) :- 
	wallSize(W) -> (
		X =< (W); 
		X >= (50 - W);
		Y =< (W); 
		Y >= (25 - W)
	).

drawGameBoard() :-
	wallSize(W),
	drawBoard(50, 25, 0, W).

drawBoard(Width,Height,Row,WallSize) :-
	Row =< Height,
		drawRow(Width,Height,Row,0,WallSize),nl,
		NewRow is (Row + 1),
		drawBoard(Width,Height,NewRow,WallSize)
	;	true.

drawRow(Width,Height,Row,Col,WallSize) :-
	Col =< Width,
		drawPosition(Width,Height,Row,Col,WallSize),
		NewCol is (Col + 1),
		drawRow(Width,Height,Row,NewCol,WallSize)
	;	
		true.

drawPosition(Width,Height,Row,Col,WallSize) :-
	isPlayerPosition(Row,Col),
		write('O')
	; isBotPosition(Row,Col),
		write('X')
	; isWallPosition(Width,Height,Row,Col,WallSize),
		write('#')
	;	write(' ').

isWallPosition(Width,Height,Row,Col,WallSize) :-
	Row =< WallSize,
		true
	; Row >= (Height - (WallSize) ),
		true
	; Col =< WallSize,
		true
	; Col >= (Width - (WallSize) ),
		true
	;
		false.
