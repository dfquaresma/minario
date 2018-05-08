#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <time.h>
#include <conio.h>
#include <locale.h>
#include <windows.h>

//Macros para reconhecer inputs
#define SETAS -32
#define ESQUERDA 75
#define DIREITA 77
#define CIMA 72
#define BAIXO 80
#define ESC 27
#define ENTER 13

//Macros para reconhecer Estados do jogo
#define ESTADO_IMPRIME_MENU 0
#define ESTADO_MENU 1
#define ESTADO_INICIA_JOGO 2
#define ESTADO_JOGO 3


void limpaTela(){
	system("cls");
}

void imprimeIntroducao(){
	limpaTela();
	printf("\n\t/////////////////////////////////\tMinário\t/////////////////////////////////");
	printf("\n\t\t\tAmanda Luna, David, Paulo Feitosa, Renato Henrique, Thomaz Diniz");
	printf("\n\n");
	Sleep(60);
	printf("\n\n\n");
	Sleep(100);
	printf("\t\t\t\tPressione [Enter] para começar o jogo");
	Sleep(60);
	printf("\n\n\n\n\t\tControles:");
	Sleep(100);
	printf("\tUtilize as [Setas] do teclado para se movimentar");
	Sleep(10);
	printf("\n\t\t\t\tPressione [Esc] a qualquer momento para fechar o jogo");
	Sleep(70);
	printf("\n\n\n\n\n\tObjetivo: Sobreviva o máximo de tempo sem bater nos limites do tabuleiro ou em outros jogadores.");
	Sleep(100);
}




//Variaveis globais para reconhecer quando alguma tecla foi pressionada
bool pressESQ = false;
bool pressDIR = false;
bool pressCIM = false;
bool pressBAI = false;

bool pressESC = false;
bool pressENTER = false;


//Checagem de inputs
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
			case SETAS:
				botao = getch();
				case ESQUERDA:
					pressESQ = true;
				break;
					
				case DIREITA:
					pressDIR = true;
				break;
				
				case CIMA:
					pressCIM = true;
				break;
				
				case BAIXO:
					pressBAI = true;
				break;
			break;
				
			case ESC:
				pressESC = true;
			break;				
			
			case ENTER:
				pressENTER = true;
			break;	

			default:
				return false;
			break;
		}
		return true;
	}	

}



int main(){
	//Muda o jogo para porugues
	setlocale(LC_ALL, "Portuguese");
	int estado = 0;
	while(1){
		atualizaBotoes();
		switch(estado){
			case ESTADO_IMPRIME_MENU:
				imprimeIntroducao();
				estado++;	
			break;
			case ESTADO_MENU:
				if (pressENTER){limpaTela(); estado++;}
			break;
			case ESTADO_INICIA_JOGO:
			break;
			case ESTADO_JOGO:
			break;
		}	
		if (pressESQ){printf("Tecla Esquerda Pressionada");}
		if (pressDIR){printf("Tecla DIREITA Pressionada");}
		if (pressCIM){printf("Tecla CIMA Pressionada");}
		if (pressBAI){printf("Tecla BAIXO Pressionada");}
		if (pressESC){break;}
	}
	printf("Fim de jogo");
	return 0;
}