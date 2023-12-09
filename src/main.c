#include "main.h"
#include "enigma.h"
#include "phantom.h"
#include <unistd.h>
#include <stdio.h>

edynarr *a(void);

/**
 * MAIN Function
 */
int
main (int argc, char *argv[])
{
	int *i;
	i = malloc(sizeof *i);
	ph_window_create(400, 200, 1280, 720);
	sleep(5);
	ph_window_close();
	return 0;
}
