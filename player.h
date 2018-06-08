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

#define USER_PLAYER_NUMBER 0

#define BOTS_UPDATE_INTERVAL 500

bool leftMovement = false;
bool rightMovement = false;
bool upMovement = false;
bool downMovement = false;

bool userEscAction = false;
bool userEnterAction = false;

int viewChance = 3;
int players_number = 100;
int playerCount = 100;
Player players[100];

void updateDifficulty(int newNumberOfPlayers, int newViewChance) {
	viewChance = newViewChance;	
	players_number = newNumberOfPlayers;
	playerCount = newNumberOfPlayers;
	players[newNumberOfPlayers];
}

void drawPlayers(){
	for (int i = 0; i < players_number; i++){
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

Player buildPlayer(){
        initPlayer(player);
        player.x = 1+getRandomInteger(BOARD_WIDTH-3);
        player.y = 1+getRandomInteger(BOARD_HEIGHT-3);
        player.xPrevious = player.x;
        player.yPrevious = player.y;
        return player;
}

int playersCollisionWithOtherPlayers(int playerCount){
	int noCollision = -1;
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
	return noCollision;
}

int playerCollisionWithOtherPlayers(int playerCount, int playerToTest){
	int noCollision = -1;
	for (int i = 0; i < playerCount; i++){
		if (players[i].isAlive){
			if (i != playerToTest){
				if (players[i].x == players[playerToTest].x && players[i].y == players[playerToTest].y){
					return i;
				}
			}
		}
	}
	return noCollision;
}

int collisionBetweenPlayers(int playerCount, int x, int y, int xVariation, int yVariation){
	int noCollision = -1;
	for (int i = 1; i < playerCount; i++){
		if (players[i].isAlive){
			if(players[i].x == x && players[i].y == y){
				for (int j = 1; j < playerCount; j++){
					if (i != j){
						if ((players[i].x + xVariation) == players[j].x && (players[i].y + yVariation) == players[j].y){
							return i;
						}
					}
				}
			}
		}
	}
	return noCollision;
}

void createPlayers() {
	int noCollision = -1;
	playerCount = players_number;
	int createdPlayers = 0;
	players[createdPlayers] = buildPlayer();
	createdPlayers++;
	while (createdPlayers < playerCount){
		players[createdPlayers] = buildPlayer();
		if(playerCollisionWithOtherPlayers(createdPlayers,createdPlayers) == noCollision){
			createdPlayers++;
		}
	}
}

void playerDie(Player *player){
	if (player->isAlive){
		playerCount--;
		player->isAlive = false;
	}
}

void killAllBots() {
	for (int i = 1; i < players_number; i++){
		playerDie(&players[i]);
	}
}

void playersCollisionWithBoard(){
	for (int i = 0; i < players_number; i++){
		if (players[i].isAlive){
			if (isCollidingWithBoard(players[i].x,players[i].y)){
				playerDie(&players[i]);
			}
		}
	}
}

void killPlayersWithCollisions(){
	int noCollision = -1;
	int checkCollision = playersCollisionWithOtherPlayers(players_number);
	if (checkCollision != noCollision){
		playerDie(&players[checkCollision]);
	}
}

void playersCollision(){
	playersCollisionWithBoard();
	killPlayersWithCollisions();
}

bool checkSafePosition(int x, int y, int xVariation, int yVariation){
	int iMove[] = {0, 0, 0, 1, 1, 1, -1, -1, -1};
	int jMove[] = {0, 1, -1, 0, 1, -1, 0, 1, -1};
	int k = 9;
	bool isSafePosition = true;
	for(int i = 0;i < k && isSafePosition;i++) {
		if (isCollidingWithBoard(x + xVariation + iMove[i], y + yVariation + jMove[i])) {
			isSafePosition = false;
		}
		if (getRandomInteger(viewChance) != viewChance) {
			int noCollision = -1;
			if (collisionBetweenPlayers(players_number, x, y, xVariation + iMove[i], yVariation + jMove[i]) != noCollision) {
				isSafePosition = false;
			}
		}
	}
	return isSafePosition;
}

void updateBotMovement(int x, int y, int* xVariation, int* yVariation) {
	// The bot always keep a distance of at least 1 cell from the Board and any other player.
	// The bot can move to any adjacent cell.
	int iMove[] = {0, 0, 0, 1, 1, 1, -1, -1, -1};
	int jMove[] = {0, 1, -1, 0, 1, -1, 0, 1, -1};
	int movementsNumber = 9, possibleMovements = 0;
	int canMove[9] = {0};
	for(int i = 0; i < movementsNumber;i++) {
		if(checkSafePosition(x, y, iMove[i], jMove[i])) {
			canMove[possibleMovements++] = i;
		}
	}
	int movementPos = 0;
	if(possibleMovements > 0) {
		int electedMovement = rand() % possibleMovements;
		movementPos = canMove[electedMovement];
	}
	*xVariation = iMove[movementPos];
	*yVariation = jMove[movementPos];

	if (cataclysm) {
		killAllBots();
	}
}

void moveUser() {
	updateUserMovement(&players[USER_PLAYER_NUMBER].horizontalSpeed, &players[USER_PLAYER_NUMBER].verticalSpeed);
	players[USER_PLAYER_NUMBER].x += players[USER_PLAYER_NUMBER].horizontalSpeed;
	players[USER_PLAYER_NUMBER].y += players[USER_PLAYER_NUMBER].verticalSpeed;
}

void moveBots(long long int* lastBotsPositionUpdateTime) {
	long long int interval = getCurrentTimestamp() - *lastBotsPositionUpdateTime;
	if(interval > BOTS_UPDATE_INTERVAL) {
		for (int i = 1; i < players_number; i++) {
			if (players[i].isAlive) { 
				updateBotMovement(players[i].x, players[i].y, &players[i].horizontalSpeed, &players[i].verticalSpeed);
				players[i].x += players[i].horizontalSpeed;
				players[i].y += players[i].verticalSpeed;
			}
		}
		*lastBotsPositionUpdateTime = getCurrentTimestamp();
	}
}


