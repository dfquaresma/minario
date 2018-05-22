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

#define PLAYERS_NUMBER 30

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
			drawCharWithOffset(players[i].xPrevious, players[i].yPrevious, " ", OFFSET_HEIGHT, OFFSET_WIDTH);

			players[i].xPrevious = players[i].x;
			players[i].yPrevious = players[i].y;

		if (players[i].isAlive) {
			if (i == 0) {
				drawCharWithOffset(players[i].x, players[i].y, "O", OFFSET_HEIGHT, OFFSET_WIDTH);
			}
			else {
				drawCharWithOffset(players[i].x, players[i].y, "X", OFFSET_HEIGHT, OFFSET_WIDTH);
			}
		}
		else {
			drawCharWithOffset(players[i].x, players[i].y, "=", OFFSET_HEIGHT, OFFSET_WIDTH);
		}
	}
}

void drawAlivePlayersNumber(){
	mvprintw(0,0,"Alive:       ");
	mvprintw(0,0,"Alive: %d", playerCount);
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
}

void ensureUserPositionInLimits(int* userXPosition, int* userYPosition) {
	int lowerBound = 1, xUpperBound = BOARD_WIDTH - 4, yUpperBound = BOARD_HEIGHT - 2;
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

Player buildPlayer(){
        initPlayer(player);
        player.x = 1+getRandomInteger(BOARD_WIDTH-3);
        player.y = 1+getRandomInteger(BOARD_HEIGHT-3);
        player.xPrevious = player.x;
        player.yPrevious = player.y;
        return player;
}

int playersCollisionWithOtherPlayers(int playerCount){
	for (int i = 0; i < playerCount; i++){
		if (players[i].isAlive){
			for (int j = 0; j < playerCount; j++){
				if (i != j){
					if (players[i].x == players[j].x && players[i].y == players[j].y){
						return i;
					}
				}
			}
		}
	}
	return -1;
}

void createPlayers() {
	playerCount = PLAYERS_NUMBER;
	int createdPlayers = 0;
	players[createdPlayers] = buildPlayer();
	createdPlayers++;
	while (createdPlayers < playerCount){
		players[createdPlayers] = buildPlayer();
		if(playersCollisionWithOtherPlayers(createdPlayers) == -1){
			createdPlayers++;		
		}
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

void playerDie(Player *player){
	if (player->isAlive){
		playerCount--;
		player->isAlive = false;
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

void killPlayersWithCollisions(){
	int checkCollision = playersCollisionWithOtherPlayers(PLAYERS_NUMBER);
	if (checkCollision != -1){
		playerDie(&players[checkCollision]);
	}
}

void playersCollision(){
	playersCollisionWithBoard();
	killPlayersWithCollisions();
}
