#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <curses.h>
#include <stdbool.h>


/*sudo apt-get install ncurses-dev*/
/*gcc a.c -lncurses*/



//Macros para reconhecer inputs
#define SETAS -32
#define ESQUERDA 75
#define DIREITA 77
#define CIMA 72
#define BAIXO 80
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


void desenhaCharOffset(int x, int y,char *c){
	mvprintw(y+OFFSET_H,x+OFFSET_W,c);
}

void desenhaChar(int x, int y,char *c){
	mvprintw(y,x,c);
}

void espera(int ms){
	usleep(ms*1000);
	refresh();
}

void init(){
	initscr();//inicializa o ncurses
	curs_set(0);//Não mostra o cursor;
	cbreak();//le os caracteres
	noecho();
	keypad(stdscr,true);//lê setas também
	timeout(10);
}

int kbhit(){
    int ch = getch();
    if (ch != ERR) {
        ungetch(ch);
        return 1;
    } else {
        return 0;
    }
}
void inicializaTabuleiro(){
	clear();
	for (int i = 0; i < TABULEIRO_W; ++i){
		for (int j = 0; i < TABULEIRO_H; ++i){
			tabuleiro[i][j] = 0;
		}
	}
	for (int i = 0; i < TABULEIRO_W; ++i){
		tabuleiro[i][0] = '#';
		tabuleiro[i][TABULEIRO_H-1] = '#';
		desenhaCharOffset(i,0,"#");
		desenhaCharOffset(i,TABULEIRO_H-1,"#");
		espera(10);
	}
	for (int i = 0; i < TABULEIRO_H; ++i){
		tabuleiro[0][i] = '#';
		tabuleiro[TABULEIRO_W-1][i] = '#';
		desenhaCharOffset(0,i,"#");
		desenhaCharOffset(TABULEIRO_W-1,i,"#");
		espera(10);
	}
}

void imprimeIntroducao(){
	clear();
	printw("\n\t/////////////////////////////////\tMinário\t/////////////////////////////////");
	printw("\n\t\t\tAmanda Luna, David, Paulo Feitosa, Renato Henrique, Thomaz Diniz");
	printw("\n\n");
	espera(60);
	printw("\n\n\n");
	espera(100);
	printw("\t\t\t\tPressione [Enter] para começar o jogo");
	espera(60);
	printw("\n\n\n\n\t\tControles:");
	espera(100);
	printw("\tUtilize as [Setas] do teclado para se movimentar");
	espera(10);
	printw("\n\t\t\t\tPressione [Esc] a qualquer momento para fechar o jogo");
	espera(70);
	printw("\n\n\n\n\n\tObjetivo: Sobreviva o máximo de tempo sem bater nos limites do tabuleiro ou em outros jogadores.");
	espera(100);
}



bool atualizaBotoes(){
	pressESQ = false;
	pressDIR = false;
	pressCIM = false;
	pressBAI = false;
	pressESC = false;
	pressENTER = false;
	int botao = 0;
	if (kbhit() != 0){
		botao = getch();
		switch(botao){
			case KEY_LEFT:	case 'a':	case 'A':	pressESQ = true;	break;
			case KEY_UP:	case 'w': 	case 'W':	pressCIM = true;	break;
			case KEY_DOWN:	case 's': 	case 'S':	pressBAI = true;	break;
			case KEY_RIGHT:	case 'd':	case 'D':	pressDIR = true;	break;
			case ESC:								pressESC = true;	break;				
			case ENTER:								pressENTER = true;	break;	
			default:
				return false;
			break;
		}
		return true;
	}	
}

int main(){
	init();//inicializa ncurses
	int estado = ESTADO_IMPRIME_MENU;

	//atributos do jogador
	int vx = 0;
	int vy = 0;
	int x = 4;
	int y = 4;
	int xPrevious = -1;
	int yPrevious = -1;

	while(1){
		atualizaBotoes();
		vx = 0;
		vy = 0;
		if (pressESQ){vx=-1;vy = 0;}
		if (pressDIR){vx=1;vy = 0;}
		if (pressCIM){vy=-1;vx = 0;}
		if (pressBAI){vy=1;vx = 0;}
		if (pressESC){break;}
		switch(estado){
			case ESTADO_IMPRIME_MENU:
				imprimeIntroducao();
				estado++;	
			break;
			case ESTADO_MENU:
				if (pressENTER){clear(); estado++;}
			break;
			case ESTADO_INICIA_JOGO:
				inicializaTabuleiro();
				espera(60);
				estado++;
			break;
			case ESTADO_JOGO:
				x+=vx;
				y+=vy;
				if (x < 1){x = 1;}
				if (y < 1){y = 1;}
				if (x > TABULEIRO_W-4){x = TABULEIRO_W-4;}
				if (y > TABULEIRO_H-2){y = TABULEIRO_H-2;}
				if (x != xPrevious || y != yPrevious){
					desenhaCharOffset(xPrevious,yPrevious,"   ");
					desenhaCharOffset(x,y,"^.^");
					xPrevious = x;
					yPrevious = y;
				}
			break;
		}	
		espera(1);
	}

	endwin();//finaliza ncurses
	printf("fim de jogo");
	return 0;
}