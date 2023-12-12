#include "main.h"
#include "enigma.h"
#include "phantom.h"
#include <stdio.h>

/**
 * MAIN Function
 */
int
main (int argc, char *argv[])
{
	e_debug_memory_init(NULL, NULL, NULL);
	EFloat *i;
	i = malloc(sizeof *i);

	PWindowSettings ws;
	ws.name = "DarkEngine Test";
	ws.x = 400;
	ws.y = 200;
	ws.width = 1280;
	ws.height = 720;
	ws.display_type = P_DISPLAY_WINDOWED_FULLSCREEN;
	ws.interact_type = P_INTERACT_INPUT_OUTPUT;
	ws.framerate = 60;

	printf("making windowed fullscreen\n");
	PDisplayInfo *di = p_window_create(&ws);
	sleep(5);
	printf("making windowed\n");
	p_window_windowed(di, &ws);
	sleep(5);
	printf("making fullscreen\n");
	p_window_fullscreen(di, &ws);
	sleep(5);

	p_window_close(di);
	free(i);
	return 0;
}
