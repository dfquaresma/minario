/*sudo apt-get install ncurses-dev*/
/*gcc <file-name>.c -lncurses -o <executable-name>*/
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <curses.h>
#include <stdbool.h>
#include <time.h>
#include "Player.h"

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
Player players[PLAYERS_NUMBER];
int playerCount = PLAYERS_NUMBER;
int decreaseGameBoardCount = 0;
clock_t timeSinceLastGameBoardDecrease;

void delay(int milliseconds);
void ncursesInit();
void ncursesEnd();

void showGameIntroduction();
void drawCharWithOffset(int x, int y, char *c);
void settingGameBoard();
void decreaseGameBoardSize();
void decreaseGameBoardByInterval();

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
void updatePlayers();
void drawPlayers();
void drawTimer(int time);

bool checkLoseCondition();
bool checkWinCondition();
void drawAlivePlayersNumber();
void showVictoryScreen();
void showFailureScreen();

int main() {
	ncursesInit();
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
				decreaseGameBoardByInterval();
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

bool isColidingWithBoard(int x, int y){
	return gameBoard[x][y]=='#';
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

int keyboardHit() {
    int ch = getch();
    if (ch != ERR) {
        ungetch(ch);
        return 1;
    } else {
        return 0;
    }
}

void drawCharWithOffset(int x, int y, char *c) {
	mvprintw(y + OFFSET_HEIGHT,x + OFFSET_WIDTH, c);
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

void decreaseGameBoardByInterval(){
	clock_t difference = (clock() - timeSinceLastGameBoardDecrease)*10/CLOCKS_PER_SEC;
	if (difference > GAME_BOARD_DECREASE_TIME){
		drawGameBoardBorder();
		decreaseGameBoardSize();
		timeSinceLastGameBoardDecrease = clock();
	}
	drawTimer(GAME_BOARD_DECREASE_TIME-difference);
}

void drawTimer(int time){
	mvprintw(1,0,"Tempo:       ");
	mvprintw(1,0,"Tempo: %d", time);
}

void showGameIntroduction() {
	clear();
	printw("\n\t/////////////////////////////////\tMinário\t/////////////////////////////////");
	printw("\n\t\t\tAmanda Luna, David Ferreira, Paulo Feitosa, Renato Henrique, Thomaz Diniz");
	printw("\n\n");
	delay(60);
	printw("\n\n\n");
	delay(100);
	printw("\t\t\t\tPressione [Enter] para começar o jogo");
	delay(60);
	printw("\n\n\n\n\t\tControles:");
	delay(100);
	printw("\tUtilize as [Setas] do teclado para se movimentar");
	delay(10);
	printw("\n\t\t\t\tPressione [Esc] a qualquer momento para fechar o jogo");
	delay(70);
	printw("\n\n\n\n\n\tObjetivo: Sobreviva o máximo de tempo sem bater nos limites do tabuleiro ou em outros jogadores.");
	delay(100);
}

void showVictoryScreen(){
	clear();
	mvprintw(OFFSET_HEIGHT+BOARD_HEIGHT/2,OFFSET_WIDTH,"Parabéns, você venceu! :D");
}
void showFailureScreen(){
	clear();
	mvprintw(OFFSET_HEIGHT+BOARD_HEIGHT/2,OFFSET_WIDTH,"Você perdeu :(");
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

void createPlayers() {
	playerCount = PLAYERS_NUMBER;
	for (int i = 0; i < PLAYERS_NUMBER; i++){
		initPlayer(player);
		players[i] = player;
		players[i].x = 1+getRandomInteger(BOARD_WIDTH-3);
		players[i].y = 1+getRandomInteger(BOARD_HEIGHT-3);
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

void drawAlivePlayersNumber(){
	mvprintw(0,0,"Alive:       ");
	mvprintw(0,0,"Alive: %d", playerCount);
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
