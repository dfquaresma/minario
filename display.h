#include <curses.h>
#include "util.h"

void drawTimer(int time){
	mvprintw(1,0,"Tempo:       ");
	mvprintw(1,0,"Tempo: %d", time);
}

void drawAlivePlayersNumber(int playerCount){
	mvprintw(0,0,"Alive:       ");
	mvprintw(0,0,"Alive: %d", playerCount);
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
