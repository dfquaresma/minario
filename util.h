#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <stdbool.h>
#include <curses.h>
#include <sys/time.h>

void delay(int milliseconds) {
	usleep(milliseconds*1000);
	refresh();
}

long long getCurrentTimestamp() {
    struct timeval te;
    gettimeofday(&te, NULL); // get current time
    long long milliseconds = te.tv_sec*1000LL + te.tv_usec/1000; // calculate milliseconds
    return milliseconds;
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

bool chance(int i){
	//Returns true if a given chance has happened.
	//A chance is determined by the first parameter, so for exemple chance(2) has a 50% of returning true
	//chance(3) has a 33.3% of returning true and so on.
	return getRandomInteger(i) == i;
}
