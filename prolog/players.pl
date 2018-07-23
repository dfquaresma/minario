:- use_module(library(random)).
/* random(A, B, Entrada). Entrada is an any int in [A, B) since A and B are ints.*/

xMin(0).
xMax(20).
yMin(0).
yMax(40).
/* DEFAULT PLAYER - DO NOT DELETE IT YET!*/
player("identifier", "xPosition", "yPosition", "isAlive").

buildPlayers(0).
buildPlayers(Size) :-
    Size > 0,
    xMin(XMin), xMax(XMax), random(XMin, XMax, XCoord),
    yMin(YMin), yMax(YMax), random(YMin, YMax, YCoord),
    call(player(_, XCoord, YCoord, _)),
    buildPlayers(Size);

    Size > 0,
    assertz(player(Size, XCoord, YCoord, "isAlive")),
    NewSize is (Size - 1),
    buildPlayers(NewSize).




