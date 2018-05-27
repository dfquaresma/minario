#include "display.h" // Includes util recursively.

#define BOARD_WIDTH 70
#define BOARD_HEIGHT 30
#define OFFSET_WIDTH 20
#define OFFSET_HEIGHT 0

#define GAME_BOARD_DECREASE_TIME 3

char gameBoard[BOARD_WIDTH][BOARD_HEIGHT];
int decreaseGameBoardCount = 0;

bool isCollidingWithBoard(int x, int y){
	return gameBoard[x][y]=='#';
}

void drawGameBoardBorder(){
	int topEdge = decreaseGameBoardCount;
	int bottomEdge = BOARD_HEIGHT - decreaseGameBoardCount - 1;
	int leftEdge = decreaseGameBoardCount;
	int rightEdge = BOARD_WIDTH - decreaseGameBoardCount - 1;

	if  ((bottomEdge - topEdge) > 2){
		for (int i = 0; i < BOARD_WIDTH; i++){
			drawCharWithOffset(i, topEdge, "#", OFFSET_HEIGHT, OFFSET_WIDTH);
			drawCharWithOffset(i, bottomEdge, "#", OFFSET_HEIGHT, OFFSET_WIDTH);
			if (decreaseGameBoardCount==0) {
				delay(10);
			}
		}
	}
	for (int i = 0; i < BOARD_HEIGHT; i++){
		drawCharWithOffset(leftEdge, i, "#", OFFSET_HEIGHT, OFFSET_WIDTH);
		drawCharWithOffset(rightEdge, i, "#", OFFSET_HEIGHT, OFFSET_WIDTH);
		if (decreaseGameBoardCount==0) {
			delay(10);
		}
	}
}

void decreaseGameBoardSize(){
	int topEdge = decreaseGameBoardCount;
	int bottomEdge = BOARD_HEIGHT - decreaseGameBoardCount - 1;
	int leftEdge = decreaseGameBoardCount;
	int rightEdge = BOARD_WIDTH - decreaseGameBoardCount - 1;

	if  ((bottomEdge - topEdge) > 2){
		for (int i = 0; i < BOARD_WIDTH; i++){
			gameBoard[i][topEdge] = gameBoard[i][bottomEdge] = '#';
		}
	}
	for (int i = 0; i < BOARD_HEIGHT; i++){
		gameBoard[leftEdge][i] = gameBoard[rightEdge][i] = '#';
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
	clock_t difference = (clock() - *timeSinceLastGameBoardDecrease)*100/CLOCKS_PER_SEC;
	if (difference > GAME_BOARD_DECREASE_TIME){
		drawGameBoardBorder();
		decreaseGameBoardSize();
		*timeSinceLastGameBoardDecrease = clock();
	}
	drawTimer(GAME_BOARD_DECREASE_TIME-difference);
}
