/*sudo apt-get install ncurses-dev*/
/*gcc <file-name>.c -lncurses -o <executable-name>*/
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <curses.h>
#include <stdbool.h>
#include <time.h>
#include "player.h"

#define KEY_ESC 27
#define L_KEY_ENTER 10

#define BOARD_WIDTH 70
#define BOARD_HEIGHT 30
#define OFFSET_WIDTH 20
#define OFFSET_HEIGHT 0
#define GAME_BOARD_DECREASE_TIME 5
#define PLAYERS_NUMBER 10

#define GAME_INTRODUCTION_STATE 0
#define MENU_STATE 1
#define START_GAME_STATE 2
#define PLAY_GAME_STATE 3
#define WIN_STATE 4
#define LOSE_STATE 5

bool leftMovement = false;
bool rightMovement = false;
bool upMovement = false;
bool downMovement = false;

bool userEscAction = false;
bool userEnterAction = false;

char gameBoard[BOARD_WIDTH][BOARD_HEIGHT];
int decreaseGameBoardCount = 0;

void delay(int milliseconds);
void ncursesInit();
void ncursesEnd();

void showGameIntroduction();
void drawCharWithOffset(int x, int y, char *c);
void settingGameBoard();
void decreaseGameBoardSize();
void decreaseGameBoardByInterval(clock_t timeSinceLastGameBoardDecrease);

int keyboardHit();
void updateNextUserAction();
void updateUserMovement(int* xVariation, int* yVariation);
void updateBotMovement(int x, int y,int* xVariation, int* yVariation);
void ensureUserPositionInLimits(int* xPosition, int* yPosition);

int getRandomInteger(int i);
int getRandomIntegerInRange(int min,int max);
bool chance(int i);

void createPlayers();
void updatePlayers();
void playersCollisionWithBoard();
void playersCollisionWithOtherPlayers();
void playersCollision();
void playersDie(Player player);
void drawPlayers();
void drawTimer(int time);

bool checkLoseCondition();
bool checkWinCondition();
void drawAlivePlayersNumber();
void showVictoryScreen();
void showFailureScreen();

int main() {
	ncursesInit();
	clock_t timeSinceLastGameBoardDecrease;
	int gameState = GAME_INTRODUCTION_STATE;

	while(!userEscAction){
		updateNextUserAction();

		switch(gameState) {
			case GAME_INTRODUCTION_STATE:
				showGameIntroduction();
				gameState = MENU_STATE;
			break;

			case MENU_STATE:
				if (userEnterAction) {
					clear();
					gameState = START_GAME_STATE;
				}
			break;

			case START_GAME_STATE:
				createPlayers();
				settingGameBoard();
				delay(60);
				gameState = PLAY_GAME_STATE;
			break;

			case PLAY_GAME_STATE:
				updatePlayers();
				playersCollision();
				drawAlivePlayersNumber();
				drawPlayers();
				decreaseGameBoardByInterval(&timeSinceLastGameBoardDecrease);
				if (checkWinCondition())
					gameState = WIN_STATE;
				if (checkLoseCondition())
					gameState = LOSE_STATE;

			break;

			case WIN_STATE:
				showVictoryScreen();
				if (userEnterAction) {
					clear();
					gameState = GAME_INTRODUCTION_STATE;
				}
			break;

			case LOSE_STATE:
				showFailureScreen();
				if (userEnterAction) {
					clear();
					gameState = GAME_INTRODUCTION_STATE;
				}
			break;
		}
		delay(1);
	}

	ncursesEnd();
	return 0;
}

void delay(int milliseconds) {
	usleep(milliseconds*1000);
	refresh();
}

void ncursesInit() {
	initscr();
	curs_set(0);
	cbreak();
	noecho();
	keypad(stdscr,true);
	timeout(10);
}

void ncursesEnd() {
	endwin();
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

void decreaseGameBoardSize(){
	for (int i = 0; i < BOARD_WIDTH; i++){
		gameBoard[i][decreaseGameBoardCount] = gameBoard[i][BOARD_HEIGHT - 1 - decreaseGameBoardCount] = '#';
	}
	for (int i = 0; i < BOARD_HEIGHT; i++){
		gameBoard[decreaseGameBoardCount][i] = gameBoard[BOARD_WIDTH - 1 - decreaseGameBoardCount][i] = '#';
	}
	decreaseGameBoardCount++;
}

void decreaseGameBoardByInterval(clock_t timeSinceLastGameBoardDecrease){
	clock_t difference = (clock() - timeSinceLastGameBoardDecrease)*10/CLOCKS_PER_SEC;
	if (difference > GAME_BOARD_DECREASE_TIME){
		drawGameBoardBorder();
		decreaseGameBoardSize();
		timeSinceLastGameBoardDecrease = clock();
	}
	drawTimer(GAME_BOARD_DECREASE_TIME-difference);
}

int keyboardHit() {
    int ch = getch();
    if (ch != ERR) {
        ungetch(ch);
        return 1;
    } else {
        return 0;
    }
}

int getRandomInteger(int i){
	return rand() % i+1;
}

int getRandomIntegerInRange(int min,int max){
	return  min + getRandomInteger(max-min);
}

bool chance(int i){
	//Returns true if a given chance has happened.
	//A chance is determined by the first parameter, so for exemple chance(2) has a 50% of returning true
	//chance(3) has a 33.3% of returning true and so on.
	return getRandomInteger(i) == i;
}

bool checkLoseCondition(){
	return !players[0].isAlive;
}

bool checkWinCondition(){
	for (int i = 1; i < PLAYERS_NUMBER; i++){
		if (players[i].isAlive) {
			return false;
		}
	}
	return !checkLoseCondition();
}

bool isColidingWithBoard(int x, int y){
	return gameBoard[x][y]=='#';
}
