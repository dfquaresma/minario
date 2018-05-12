/*sudo apt-get install ncurses-dev*/
/*gcc <file-name>.c -lncurses -o <executable-name>*/
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <curses.h>
#include <stdbool.h>

#define KEY_ESC 27
#define L_KEY_ENTER 10

#define BOARD_WIDTH 70
#define BOARD_HEIGHT 30
#define OFFSET_WIDTH 20
#define OFFSET_HEIGHT 0

#define GAME_INTRODUCTION_STATE 0
#define MENU_STATE 1
#define START_GAME_STATE 2
#define PLAY_GAME_STATE 3

bool leftMovement = false;
bool rightMovement = false;
bool upMovement = false;
bool downMovement = false;

bool userEscAction = false;
bool userEnterAction = false;

char gameBoard[BOARD_WIDTH][BOARD_HEIGHT];

void delay(int milliseconds);
void ncursesInit();
void ncursesEnd();

void showGameIntroduction();
void drawCharWithOffset(int x, int y, char *c);
void settingBoard();

int keyboardHit();
void updateNextUserAction();
void updateUserMovement(int* xVariation, int* yVariation);
void ensureUserPositionInLimits(int* xPosition, int* yPosition);

int main() {
	ncursesInit();
	int gameState = GAME_INTRODUCTION_STATE;

	//user attributes
	int userXVariation = 0;
	int userYVariation = 0;
	int userXPosition = 4;
	int userYPosition = 4;

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
				settingBoard();
				delay(60);
				gameState = PLAY_GAME_STATE;
			break;
			
			case PLAY_GAME_STATE:
				updateUserMovement(&userXVariation, &userYVariation);
				drawCharWithOffset(userXPosition, userYPosition, "   ");
				userXPosition += userXVariation;
				userYPosition += userYVariation;
				ensureUserPositionInLimits(&userXPosition, &userYPosition);
				drawCharWithOffset(userXPosition, userYPosition, "^.^");
			break;
		}	
		delay(1);
	}

	ncursesEnd();

	printf("fim de jogo\n");
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

void ensureUserPositionInLimits(int* userXPosition, int* userYPosition) {
	int lowerBound = 1, xUpperBound = BOARD_WIDTH - 4, yUpperBound = BOARD_HEIGHT - 2;
	if (*userXPosition < lowerBound) 
		*userXPosition = lowerBound;
	if (*userXPosition > xUpperBound) 
		*userXPosition = xUpperBound;
	
	if (*userYPosition < lowerBound)
		*userYPosition = lowerBound;
	if (*userYPosition > yUpperBound)
		*userYPosition = yUpperBound;
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

void settingBoard() {
	clear();
	for (int i = 0; i < BOARD_WIDTH; ++i){
		for (int j = 0; j < BOARD_HEIGHT; ++j){
			gameBoard[i][j] = 0;
		}
	}
	for (int i = 0; i < BOARD_WIDTH; ++i){
		gameBoard[i][0] = gameBoard[i][BOARD_HEIGHT - 1] = '#';
		drawCharWithOffset(i, 0, "#");
		drawCharWithOffset(i, BOARD_HEIGHT - 1, "#");
		delay(10);
	}
	for (int i = 0; i < BOARD_HEIGHT; ++i){
		gameBoard[0][i] = gameBoard[BOARD_WIDTH - 1][i] = '#';
		drawCharWithOffset(0, i, "#");
		drawCharWithOffset(BOARD_WIDTH - 1, i, "#");
		delay(10);
	}
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
