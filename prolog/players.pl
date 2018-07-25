:- module(
    'players', 
    [buildPlayers/1,
     killPlayersColliding/3,
     updateBotsPosition/1,
     updatePlayerPosition/2,
     isPlayerPosition/2,
     isBotPosition/2,
     getBotPosition/3,
     getPlayerPosition/2,
     getNumberOfPlayers/1,
     isPlayerAlive/0
    ]
). 
:- use_module(board).

/* XMin, XMax */
xLimits(0, 70). 
/* YMin, YMax */
yLimits(0, 30). 
/* DEFAULT PLAYER - DO NOT DELETE IT YET!*/
player("identifier", "xPosition", "yPosition").
buildPlayers(0).
buildPlayers(Size) :-
    (Size > 0) -> (
        xLimits(XMin, XMax), random_between(XMin, XMax, XCoord),
        yLimits(YMin, YMax), random_between(YMin, YMax, YCoord),
        assertz(player(Size, XCoord, YCoord)),
        killPlayersColliding(0, 0, Kills),
        NewSize is (Size - 1 + Kills),
        buildPlayers(NewSize)
    ).

getNumberOfPlayers(Count) :- 
    aggregate_all(count, player(_, _, _), Count).

/* X start, Y start, number of facts killed.*/
killPlayersColliding(70, 31, 0). 
killPlayersColliding(X, 31, Kills) :- 
    XAux is X + 1, 
    killPlayersColliding(XAux, 0, Kills).
killPlayersColliding(X, Y, Kills) :- 
    aggregate_all(count, player(_, X, Y), Count), 
    /* TODO(). Adding isCollidingWithBoard(X, Y) below, kill also players colliding with board.(Still with bugs)*/
    (Count > 1) -> (
        retractall(player(_, X, Y)), 
        YAux1 is Y + 1, writeln(YAux1),
        killPlayersColliding(X, YAux1, KillsAux),
        Kills is KillsAux + Count
    ); 
    YAux2 is Y + 1,
    killPlayersColliding(X, YAux2, Kills).

updateBotsPosition(1) :- 
    killPlayersColliding(0, 0, _).
updateBotsPosition(N) :- 
    player(N, X, Y) -> (
        random_between(-1, 1, XVar), random_between(-1, 1, YVar), 
        NewX is X + XVar, NewY is Y + YVar,
        retract(player(N, _, _)),
        assertz(player(N, NewX, NewY)),
        NewNBotExist is N - 1,
        updateBotsPosition(NewNBotExist)
    );
    NewNBotNotExist is N - 1,
    updateBotsPosition(NewNBotNotExist).

updatePlayerPosition(XVar, YVar) :- 
    player(1, X, Y) -> (
	    NewX is (X + XVar),
	    NewY is (Y + YVar),
	    retract(player(1, _, _)),
	    assertz(player(1, NewX, NewY)),
        killPlayersColliding(0, 0, _)
    ).

isBotPosition(Row, Col) :-
    player(Id, Row, Col),
    Id > 1.

isPlayerPosition(Row, Col) :-
    player(Id, Row, Col),
    Id =:= 1.

getBotPosition(Id, XPos, YPos) :-
    player(Id, XPos, YPos).

getPlayerPosition(XPos, YPos) :-
    getBotPosition(1, XPos, YPos).

isPlayerAlive() :-
    player(1, _, _).
