:- module(
    'players', 
    [buildPlayers/1,
     killPlayersColliding/3,
     updateBotsPosition/1
    ]
).


/* XMin, XMax */
xLimits(0, 40). 
/* YMin, YMax */
yLimits(0, 20). 
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


/* X start, Y start, number of facts killed.*/
killPlayersColliding(40, 21, 0). 
killPlayersColliding(X, 21, Kills) :- 
    XAux is X + 1, 
    killPlayersColliding(XAux, 0, Kills).
killPlayersColliding(X, Y, Kills) :- 
    aggregate_all(count, player(_, X, Y), Count), 
    Count > 1 -> (
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
    random_between(0, 1, View),
    (View > 0) -> (
        player(N, X, Y),
        random_between(-1, 1, XVar), random_between(-1, 1, YVar), 
        NewX is X + XVar, NewY is Y + YVar,
        aggregate_all(count, player(_, NewX, NewY), Count),
        (Count > 0) -> (
            updateBotsPosition(N)
        );
    
        retract(player(N, _, _)),
        assertz(player(N, NewX, NewY)),
        NewN is N - 1,
        updateBotsPosition(NewN)
    );
    
    player(N, X, Y),
    random_between(-1, 1, XVar), random_between(-1, 1, YVar), 
    NewX is X + XVar, NewY is Y + YVar,
    retract(player(N, _, _)),
    assertz(player(N, NewX, NewY)),
    NewN is N - 1,
    updateBotsPosition(NewN).
