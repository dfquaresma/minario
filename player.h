
#include <stdbool.h>

typedef struct {
	int x;
	int y;
	int xPrevious;
	int yPrevious;
	int horizontalSpeed;
	int verticalSpeed;
	bool isAlive;
} Player;

#define initPlayer(player) Player player = {.x=0, .y=0, .xPrevious=0,.yPrevious=0,.horizontalSpeed=0,.verticalSpeed=0,.isAlive=true}
