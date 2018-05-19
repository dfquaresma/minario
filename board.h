#include "display.h" // Includes util recursively.

#define BOARD_WIDTH 70
#define BOARD_HEIGHT 30
#define OFFSET_WIDTH 20
#define OFFSET_HEIGHT 0

#define GAME_BOARD_DECREASE_TIME 5

char gameBoard[BOARD_WIDTH][BOARD_HEIGHT];
int decreaseGameBoardCount = 0;

bool isColidingWithBoard(int x, int y){
	return gameBoard[x][y]=='#';
}

void drawGameBoardBorder(){
	for (int i = 0; i < BOARD_WIDTH; i++){
		drawCharWithOffset(i, decreaseGameBoardCount, "#");
		drawCharWithOffset(i, BOARD_HEIGHT - decreaseGameBoardCount - 1, "#");
		if (decreaseGameBoardCount==0) {
			delay(10);
		}
	}
	for (int i = 0; i < BOARD_HEIGHT; i++){
		drawCharWithOffset(decreaseGameBoardCount, i, "#");
		drawCharWithOffset(BOARD_WIDTH - decreaseGameBoardCount - 1, i, "#");
		if (decreaseGameBoardCount==0) {
			delay(10);
		}
	}
}

void decreaseGameBoardSize(){
	for (int i = 0; i < BOARD_WIDTH; i++){
		gameBoard[i][decreaseGameBoardCount] = gameBoard[i][BOARD_HEIGHT - 1 - decreaseGameBoardCount] = '#';
	}
	for (int i = 0; i < BOARD_HEIGHT; i++){
		gameBoard[decreaseGameBoardCount][i] = gameBoard[BOARD_WIDTH - 1 - decreaseGameBoardCount][i] = '#';
	}
	decreaseGameBoardCount++;
}

void settingGameBoard() {
	clear();
	decreaseGameBoardCount = 0;
	for (int i = 0; i < BOARD_WIDTH; ++i){
		for (int j = 0; j < BOARD_HEIGHT; ++j){
			gameBoard[i][j] = 0;
		}
	}
	drawGameBoardBorder();
	decreaseGameBoardSize();
}

void decreaseGameBoardByInterval(clock_t *timeSinceLastGameBoardDecrease){
	clock_t difference = (clock() - timeSinceLastGameBoardDecrease)*10/CLOCKS_PER_SEC;
	if (difference > GAME_BOARD_DECREASE_TIME){
		drawGameBoardBorder();
		decreaseGameBoardSize();
		timeSinceLastGameBoardDecrease = clock();
	}
	drawTimer(GAME_BOARD_DECREASE_TIME-difference);
}
