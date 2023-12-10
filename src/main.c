#include "main.h"
#include "enigma.h"
#include "phantom.h"
#include <unistd.h>
#include <stdio.h>

/**
 * MAIN Function
 */
int
main (int argc, char *argv[])
{
	EFloat *i;
	i = malloc(sizeof *i);

	PWindowSettings ws;
	ws.name = "DarkEngine Test";
	ws.x = 400;
	ws.y = 200;
	ws.width = 1280;
	ws.height = 720;
	ws.display_type = P_DISPLAY_FULLSCREEN;
	ws.interact_type = P_INTERACT_INPUT_OUTPUT;

	PDisplayInfo *di = p_window_create(ws);
	p_window_close(di);
	return 0;
}
