:- module(
    'players', 
    [buildPlayer/0,
     buildBots/1,
     killPlayersColliding/2,
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
:- use_module(library(random)).

:- dynamic player/3.


/* XMin, XMax */
xLimits(2, 23). 
/* YMin, YMax */
yLimits(2, 48). 

buildPlayer() :- 
    xLimits(XMin, XMax), random_between(XMin, XMax, XCoord),
    yLimits(YMin, YMax), random_between(YMin, YMax, YCoord),
    asserta(player(1, XCoord, YCoord)).

buildBots(1).
buildBots(Size) :-
    (Size > 0) -> (
        xLimits(XMin, XMax), random_between(XMin, XMax, XCoord),
        yLimits(YMin, YMax), random_between(YMin, YMax, YCoord),
        asserta(player(Size, XCoord, YCoord)),
        aggregate_all(count, player(_, XCoord, YCoord), BotsHere), 
        (BotsHere >= 2) -> (
            retract(player(Size, _, _)),
            buildBots(Size)    
        ); 
        NewSize is (Size - 1),
        buildBots(NewSize)
    ).

getNumberOfPlayers(Count) :- 
    aggregate_all(count, player(_, _, _), Count).

/* X start, Y start, number of facts killed.*/
killPlayersColliding(100, 50). 
killPlayersColliding(X, 50) :- 
    XAux is X + 1, 
    killPlayersColliding(XAux, 0).
killPlayersColliding(X, Y) :- 
    isCollidingWithBoard(X, Y),
    retractall(player(_, X, Y)), 
    YNew is Y + 1,
    killPlayersColliding(X, YNew);

    aggregate_all(count, player(_, X, Y), PlayersAtSamePosition), 
    (PlayersAtSamePosition > 1) -> (
        retractall(player(_, X, Y)), 
        YNew is Y + 1,
        killPlayersColliding(X, YNew)
    ); 
    YNew is Y + 1,
    killPlayersColliding(X, YNew).

updateBotsPosition(1) :- 
    killPlayersColliding(0, 0).
updateBotsPosition(N) :- 
    player(N, X, Y) -> (
        random_between(-1, 1, XVar), random_between(-1, 1, YVar), 
        NewX is X + XVar, NewY is Y + YVar,
        retract(player(N, X, Y)),
        asserta(player(N, NewX, NewY)),
        NewNBotExist is N - 1,
        updateBotsPosition(NewNBotExist)
    );
    NewNBotNotExist is N - 1,
    updateBotsPosition(NewNBotNotExist).

updatePlayerPosition(XVar, YVar) :- 
    player(1, X, Y) -> (
	    NewX is (X + XVar),
	    NewY is (Y + YVar),
	    retract(player(1, X, Y)),
	    asserta(player(1, NewX, NewY)),
        killPlayersColliding(0, 0)
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
