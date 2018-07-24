:- initialization (main).

drawGameBoard() :-
	drawBoard(70,30,0,1,[],[]).

drawBoard(Width,Height,Row,WallSize,Player,Bots) :-
	Row < Height,
		drawRow(Width,Height,Row,0,WallSize,Player,Bots),nl,
		NewRow is (Row + 1),
		drawBoard(Width,Height,NewRow,WallSize,Player,Bots)
	;	true.

drawRow(Width,Height,Row,Col,WallSize,Player,Bots) :-
	Col < Width,
		drawPosition(Width,Height,Row,Col,WallSize,Player,Bots),
		NewCol is (Col + 1),
		drawRow(Width,Height,Row,NewCol,WallSize,Player,Bots)
	;	
		true.

drawPosition(Width,Height,Row,Col,WallSize,Player,Bots) :-
	isPlayerPosition(Row,Col,Player),
		write('O')
	; isBotPosition(Row,Col,Bots),
		write('X')
	; isWallPosition(Width,Height,Row,Col,WallSize),
		write('#')
	;	write(' ').

isPlayerPosition(Row,Col,Player) :-
	false.
	
isBotPosition(Row,Col,Bots) :-
	false.

isWallPosition(Width,Height,Row,Col,WallSize) :-
	Row =< WallSize,
		true
	; Row >= (Height - (WallSize + 1) ),
		true
	; Col =< WallSize,
		true
	; Col >= (Width - (WallSize + 1) ),
		true
	;
		false.



main :-
	drawGameBoard().