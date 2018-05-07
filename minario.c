#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <time.h>
#include <conio.h>

//#include <windows.h>
//#include <locale.h>
//


//Constantes para reconhecer inputs
#define Setas -32
#define ESQUERDA 75
#define DIREITA 77
#define CIMA 72
#define BAIXO 80
#define ESC 27
#define ENTER 13


//Variaveis globais para reconhecer quando alguma tecla foi pressionada
bool pressESQ = false;
bool pressDIR = false;
bool pressCIM = false;
bool pressBAI = false;

bool pressW = false;
bool pressA = false;
bool pressS = false;
bool pressD = false;

bool pressESC = false;
bool pressENTER = false;


//Checagem de inputs
bool atualizaBotoes(){	
	pressESQ = false;
	pressDIR = false;
	pressCIM = false;
	pressBAI = false;
	
	pressW = false;
	pressA = false;
	pressS = false;
	pressD = false;
	
	pressESC = false;
	pressENTER = false;
	
	int botao = 0;
	if (kbhit() != 0){
		botao = getch();
		switch(botao){
			case Setas:
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
			
			case 'a':case 'A':
				pressA = true;
			break;
			
			case 'w': case 'W':
				pressW = true;
			break;
			
			case 's': case 'S':
				pressS = true;
			break;
			
			case 'd':case 'D':
				pressD = true;
			break;
				
			default:
				return false;
			break;
		}
		return true;
	}	

}



int main(){
	while(1){
		atualizaBotoes();
		if (pressESQ){printf("Tecla Esquerda Pressionada");}
		if (pressDIR){printf("Tecla DIREITA Pressionada");}
		if (pressCIM){printf("Tecla CIMA Pressionada");}
		if (pressBAI){printf("Tecla BAIXO Pressionada");}
		if (pressESC){break;}
	}
	printf("Fim de jogo");
	return 0;
}