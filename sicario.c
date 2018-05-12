/*sudo apt-get install ncurses-dev*/
/*gcc <file-name>.c -lncurses -o <executable-name>*/
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <curses.h>
#include <stdbool.h>

//Macros para reconhecer inputs
#define ESC 27
#define ENTER 10

//Macros para tamanho do tabuleiro
#define TABULEIRO_W 70
#define TABULEIRO_H 30
#define OFFSET_W 20
#define OFFSET_H 0

//Macros para reconhecer Estados do jogo
#define ESTADO_IMPRIME_MENU 0
#define ESTADO_MENU 1
#define ESTADO_INICIA_JOGO 2
#define ESTADO_JOGO 3

//Variáveis globais
bool pressESQ = false;
bool pressDIR = false;
bool pressCIM = false;
bool pressBAI = false;
bool pressESC = false;
bool pressENTER = false;
char tabuleiro[TABULEIRO_W][TABULEIRO_H];


void delay(int milliseconds);
void ncursesInit();

void showGameIntroduction();
void drawCharWithOffset(int x, int y, char *c);
void settingBoard();

int keyboardHit();
void updateNextUserAction();
void updateUserMoviment(int* xVariation, int* yVariation);
void ensureUserPositionInLimits(int* xPosition, int* yPosition);

int main() {
	ncursesInit();//inicializa ncurses
	int gameState = ESTADO_IMPRIME_MENU;

	//atributos do jogador
	int userXVariation = 0;
	int userYVariation = 0;
	int userXPosition = 4;
	int userYPosition = 4;

	while(!pressESC){
		updateNextUserAction();
		
		updateUserMoviment(&userXVariation, &userYVariation);

		switch(gameState){
			case ESTADO_IMPRIME_MENU:
				showGameIntroduction();
				gameState++;	
			break;
			case ESTADO_MENU:
				if (pressENTER) {
					clear();
					gameState++;
				}
			break;
			case ESTADO_INICIA_JOGO:
				settingBoard();
				delay(60);
				gameState++;
			break;
			case ESTADO_JOGO:
				drawCharWithOffset(userXPosition, userYPosition, "   ");
				userXPosition += userXVariation;
				userYPosition += userYVariation;
				ensureUserPositionInLimits(&userXPosition, &userYPosition);
				drawCharWithOffset(userXPosition, userYPosition, "^.^");
			break;
		}	
		delay(1);
	}

	endwin();//finaliza ncurses
	printf("fim de jogo\n");
	return 0;
}

void updateNextUserAction() {
	pressESQ = pressDIR = pressCIM = pressBAI = pressESC = pressENTER = false;

	int botao = 0;
	if (keyboardHit() != 0) {
		botao = getch();
		switch(botao){
			case KEY_LEFT:	case 'a':	case 'A':	pressESQ = true;	break;
			case KEY_UP:	case 'w': 	case 'W':	pressCIM = true;	break;
			case KEY_DOWN:	case 's': 	case 'S':	pressBAI = true;	break;
			case KEY_RIGHT:	case 'd':	case 'D':	pressDIR = true;	break;
			case ESC:								pressESC = true;	break;				
			case ENTER:								pressENTER = true;	break;
		}
	}
}

void updateUserMoviment(int* xVariation, int* yVariation) {
	if (pressESQ) {
		*xVariation = -1;
		*yVariation = 0;
	} else if (pressDIR) {	
		*xVariation = 1;
		*yVariation = 0;
	} else if (pressCIM) {
		*xVariation = 0;
		*yVariation = -1;
	} else if (pressBAI) {
		*xVariation = 0;
		*yVariation = 1;
	} else {
		*xVariation = 0;
		*yVariation = 0;
	}
}

void ensureUserPositionInLimits(int* userXPosition, int* userYPosition) {
	int lowerBound = 1, xUpperBound = TABULEIRO_W - 4, yUpperBound = TABULEIRO_H - 2;
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
	mvprintw(y + OFFSET_H,x + OFFSET_W, c);
}

void settingBoard() {
	clear();
	for (int i = 0; i < TABULEIRO_W; ++i){
		for (int j = 0; j < TABULEIRO_H; ++j){
			tabuleiro[i][j] = 0;
		}
	}
	for (int i = 0; i < TABULEIRO_W; ++i){
		tabuleiro[i][0] = '#';
		tabuleiro[i][TABULEIRO_H-1] = '#';
		drawCharWithOffset(i,0,"#");
		drawCharWithOffset(i,TABULEIRO_H-1,"#");
		delay(10);
	}
	for (int i = 0; i < TABULEIRO_H; ++i){
		tabuleiro[0][i] = '#';
		tabuleiro[TABULEIRO_W-1][i] = '#';
		drawCharWithOffset(0,i,"#");
		drawCharWithOffset(TABULEIRO_W-1,i,"#");
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
