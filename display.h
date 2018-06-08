#include "util.h"

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
    printw("\n\t\tAmanda Luna, David Ferreira, Paulo Feitosa, Renato Henriques, Thomaz Diniz");
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

void showGameIntroductionStaticInstructions() {
    clear();
    printw("\n\t/////////////////////////////////\tMinário\t/////////////////////////////////");
    printw("\n\t\tAmanda Luna, David Ferreira, Paulo Feitosa, Renato Henriques, Thomaz Diniz");
    printw("\n\n");
    printw("\n\n\n");
    printw("\t\t\t\t\t\t  Começar o jogo");
    printw("\n\n\t\t\t\t\t\t> Instruções");
    printw("\n\n\n\t\t\t\tPressione [Esc] a qualquer momento para fechar o jogo");
    printw("\n\n\n\n\n\t///////////////////////////////////////////////////////////////////////////////////////////");
}

void showGameIntroductionStaticStart() {
    clear();
    printw("\n\t/////////////////////////////////\tMinário\t/////////////////////////////////");
    printw("\n\t\tAmanda Luna, David Ferreira, Paulo Feitosa, Renato Henriques, Thomaz Diniz");
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
    printw("\n\n\t\t\t\t\t\tObjetivo:");
    delay(60);
    printw("\n\n\t\tSobreviva o máximo de tempo sem bater nos limites do tabuleiro ou em outros jogadores.");
    delay(100);
    printw("\n\n\t\t\t\t\t\tComandos:");
    printw("\n\n\t\t\t\tUtilize as [Setas] do teclado para se movimentar");
    delay(60);
    printw("\n\n\n\t\t\t\t> Voltar");
    delay(60);
    printw("\n\n\n\n\n\t///////////////////////////////////////////////////////////////////////////////////////////");
}

void showGameDifficultyOptionsEasy() {
    clear();
    printw("\n\t/////////////////////////////////\tDificuldade\t/////////////////////////////////");
    printw("\n\n");
    printw("\n\n\t\t\t\tEscolha uma dificuldade:");
    printw("\n\n\n");
    printw("\t\t\t\t\t\t> Frangote (Fácil)");
    printw("\n\n\t\t\t\t\t\t Ok (Médio)");
    printw("\n\n\t\t\t\t\t\t Hardcore (Difícil)");
    printw("\n\n\n\t\t\t\tPressione [Esc] a qualquer momento para fechar o jogo");
    printw("\n\n\n\n\n\t///////////////////////////////////////////////////////////////////////////////////////////");
}

void showGameDifficultyOptionsMedium() {
    clear();
    printw("\n\t/////////////////////////////////\tDificuldade\t/////////////////////////////////");
    printw("\n\n");
    printw("\n\n\t\t\t\tEscolha uma dificuldade:");
    printw("\n\n\n");
    printw("\t\t\t\t\t\t Frangote (Fácil)");
    printw("\n\n\t\t\t\t\t\t> Ok (Médio)");
    printw("\n\n\t\t\t\t\t\t Hardcore (Difícil)");
    printw("\n\n\n\t\t\t\tPressione [Esc] a qualquer momento para fechar o jogo");
    printw("\n\n\n\n\n\t///////////////////////////////////////////////////////////////////////////////////////////");
}

void showGameDifficultyOptionsHard() {
    clear();
    printw("\n\t/////////////////////////////////\tDificuldade\t/////////////////////////////////");
    printw("\n\n");
    printw("\n\n\t\t\t\tEscolha uma dificuldade:");
    printw("\n\n\n");
    printw("\t\t\t\t\t\t Frangote (Fácil)");
    printw("\n\n\t\t\t\t\t\t Ok (Médio)");
    printw("\n\n\t\t\t\t\t\t> Hardcore (Difícil)");
    printw("\n\n\n\t\t\t\tPressione [Esc] a qualquer momento para fechar o jogo");
    printw("\n\n\n\n\n\t///////////////////////////////////////////////////////////////////////////////////////////");
}

