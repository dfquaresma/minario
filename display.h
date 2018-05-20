#include "util.h"

void showGameIntroductionSelectStart();
void showGameIntroductionSelectInstructions();
void showMainGameIntroduction();
void showGameInstructions();

void menu();

void drawTimer(int time){
	mvprintw(1,0,"Tempo:       ");
	mvprintw(1,0,"Tempo: %d", time);
}

void showVictoryScreen(int offset_height, int board_height, int offset_width){
	clear();
	mvprintw(offset_height + board_height / 2, offset_width, "Parabéns, você venceu! :D");
}

void showFailureScreen(int offset_height, int board_height, int offset_width){
	clear();
	mvprintw(offset_height + board_height / 2, offset_width,"Você perdeu :(");
}

void drawCharWithOffset(int x, int y, char *c, int offset_height, int offset_width) {
	mvprintw(y + offset_height, x + offset_width, c);
}


void showMainGameIntroduction() {
    clear();
    printw("\n\t/////////////////////////////////\tMinário\t/////////////////////////////////");
    printw("\n\t\t\tAmanda Luna, David Ferreira, Paulo Feitosa, Renato Henrique, Thomaz Diniz");
    printw("\n\n");
    delay(60);
    printw("\n\n\n");
    delay(100);
    printw("\t\t\t\t\t\t> Começar o jogo");
    delay(60);
    printw("\n\n\t\t\t\t\t\t  Instruções");
    delay(60);
    printw("\n\n\n\t\t\t\tPressione [Esc] a qualquer momento para fechar o jogo");
    delay(100);
    printw("\n\n\n\n\n\t///////////////////////////////////////////////////////////////////////////////////////////");
    delay(100);
}

void showGameIntroductionSelectInstructions() {

    clear();
    printw("\n\t/////////////////////////////////\tMinário\t/////////////////////////////////");
    printw("\n\t\t\tAmanda Luna, David Ferreira, Paulo Feitosa, Renato Henrique, Thomaz Diniz");
    printw("\n\n");
    printw("\n\n\n");
    printw("\t\t\t\t\t\t  Começar o jogo");
    printw("\n\n\t\t\t\t\t\t> Instruções");
    printw("\n\n\n\t\t\t\tPressione [Esc] a qualquer momento para fechar o jogo");
    printw("\n\n\n\n\n\t///////////////////////////////////////////////////////////////////////////////////////////");
}

void showGameIntroductionSelectStart() {

    clear();
    printw("\n\t/////////////////////////////////\tMinário\t/////////////////////////////////");
    printw("\n\t\t\tAmanda Luna, David Ferreira, Paulo Feitosa, Renato Henrique, Thomaz Diniz");
    printw("\n\n");
    printw("\n\n\n");
    printw("\t\t\t\t\t\t> Começar o jogo");
    printw("\n\n\t\t\t\t\t\t  Instruções");
    printw("\n\n\n\t\t\t\tPressione [Esc] a qualquer momento para fechar o jogo");
    printw("\n\n\n\n\n\t///////////////////////////////////////////////////////////////////////////////////////////");
}

void showGameInstructions() {
    clear();
    printw("\n\t/////////////////////////////////\tInstruções\t/////////////////////////////////");
    printw("\n\n");
    delay(60);
    printw("\n\n\n");
    printw("\n\n\n\n\n\tObjetivo: Sobreviva o máximo de tempo sem bater nos limites do tabuleiro ou em outros jogadores.");
    delay(100);
    printw("\t\t\t\tUtilize as [Setas] do teclado para se movimentar");
    delay(60);
    printw("\n\n\n\t\t\t\t> Voltar");
}

/*
 void showGameIntroduction() {

	bool repeat = true;
	bool chooseOption = userEnterAction;

	do{
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
	} while(repeat);
}

 */