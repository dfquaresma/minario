#include "board.h" // Also includes display and util recursively.

typedef struct {
	int x;
	int y;
	int xPrevious;
	int yPrevious;
	int horizontalSpeed;
	int verticalSpeed;
	bool isAlive;
} Player;

#define initPlayer(player) Player player = {.x=0, .y=0, .xPrevious=0,.yPrevious=0,.horizontalSpeed=0,.verticalSpeed=0,.isAlive=true}

#define KEY_ESC 27
#define L_KEY_ENTER 10

#define PLAYERS_NUMBER 10

bool leftMovement = false;
bool rightMovement = false;
bool upMovement = false;
bool downMovement = false;

bool userEscAction = false;
bool userEnterAction = false;

int playerCount = PLAYERS_NUMBER;
Player players[PLAYERS_NUMBER];

void drawPlayers(){
	for (int i = 0; i < PLAYERS_NUMBER; i++){
			drawCharWithOffset(players[i].xPrevious, players[i].yPrevious, " ");

			players[i].xPrevious = players[i].x;
			players[i].yPrevious = players[i].y;

		if (players[i].isAlive) {
			if (i == 0) {
				drawCharWithOffset(players[i].x, players[i].y, "O");
			}
			else {
				drawCharWithOffset(players[i].x, players[i].y, "X");
			}
		}
		else {
			drawCharWithOffset(players[i].x, players[i].y, "=");
		}
	}
}

void updateNextUserAction() {
	leftMovement = rightMovement = upMovement = downMovement = false;
	userEscAction = userEnterAction = false;

	int key = 0;
	if (keyboardHit() != 0) {
		key = getch();
		switch(key) {
			case KEY_LEFT:	case 'a':	case 'A':	leftMovement = true;	break;
			case KEY_UP:	case 'w': 	case 'W':	upMovement = true;		break;
			case KEY_DOWN:	case 's': 	case 'S':	downMovement = true;	break;
			case KEY_RIGHT:	case 'd':	case 'D':	rightMovement = true;	break;
			case KEY_ESC:							userEscAction = true;	break;
			case L_KEY_ENTER:						userEnterAction = true;	break;
		}
	}
}

void updateUserMovement(int* xVariation, int* yVariation) {
	if (leftMovement) {
		*xVariation = -1;
		*yVariation = 0;
	} else if (rightMovement) {
		*xVariation = 1;
		*yVariation = 0;
	} else if (upMovement) {
		*xVariation = 0;
		*yVariation = -1;
	} else if (downMovement) {
		*xVariation = 0;
		*yVariation = 1;
	} else {
		*xVariation = 0;
		*yVariation = 0;
	}
}

void updateBotMovement(int x, int y, int* xVariation, int* yVariation) {//Here's where I would put the AI logic
	if (!chance(100)) {
		*xVariation = 0;
		*yVariation = 0;
	} else if (chance(5)){
		*xVariation = -1;
		*yVariation = 0;
	} else if (chance(5)) {
		*xVariation = 1;
		*yVariation = 0;
	} else if (chance(5)){
		*xVariation = 0;
		*yVariation = 1;
	} else {
		*xVariation = 0;
		*yVariation = -1;
	}
	if (isColidingWithBoard(x+*xVariation,y+*yVariation)){
		*xVariation=0;
		*yVariation=0;
	}
}

void ensureUserPositionInLimits(int* userXPosition, int* userYPosition, int board_width, int board_height) {
	int lowerBound = 1, xUpperBound = board_width - 4, yUpperBound = board_height - 2;
	if (*userXPosition < lowerBound) {
		*userXPosition = lowerBound;
	}
	if (*userXPosition > xUpperBound) {
		*userXPosition = xUpperBound;
	}
	if (*userYPosition < lowerBound) {
		*userYPosition = lowerBound;
	}
	if (*userYPosition > yUpperBound) {
		*userYPosition = yUpperBound;
	}
}

void createPlayers(int board_width, int board_height) {
	playerCount = PLAYERS_NUMBER;
	for (int i = 0; i < PLAYERS_NUMBER; i++){
		initPlayer(player);
		players[i] = player;
		players[i].x = 1+getRandomInteger(board_width-3);
		players[i].y = 1+getRandomInteger(board_height-3);
		players[i].xPrevious = players[i].x;
		players[i].yPrevious = players[i].y;
	}
}

void updatePlayers(){
	for (int i = 0; i < PLAYERS_NUMBER; i++){
		if (players[i].isAlive){
			if (i==0) {
				updateUserMovement(&players[i].horizontalSpeed, &players[i].verticalSpeed);
			}
			else {
				updateBotMovement(players[i].x,players[i].y,&players[i].horizontalSpeed, &players[i].verticalSpeed);
			}

			players[i].x += players[i].horizontalSpeed;
			players[i].y += players[i].verticalSpeed;
		}
	}
}

void playersCollisionWithBoard(){
	for (int i = 0; i < PLAYERS_NUMBER; i++){
		if (players[i].isAlive){
			if (isColidingWithBoard(players[i].x,players[i].y)){
				playerDie(&players[i]);
			}
		}
	}
}

void playersCollisionWithOtherPlayers(){
	for (int i = 0; i < PLAYERS_NUMBER; i++){
		if (players[i].isAlive){
			for (int j = 0; j < PLAYERS_NUMBER; j++){
				if (i != j){
					if (players[i].x == players[j].x && players[i].y == players[j].y){
						playerDie(&players[i]);
					}
				}
			}
		}
	}
}

void playersCollision(){
	playersCollisionWithBoard();
	playersCollisionWithOtherPlayers();
}

void playerDie(Player *player){
	if (player->isAlive){
		playerCount--;
		player->isAlive = false;
	}
}
