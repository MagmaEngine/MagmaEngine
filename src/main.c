#include "main.h"
#include "enigma.h"
#include "phantom.h"
#include <unistd.h>
#include <wchar.h>
#include <locale.h>

/**
 * MAIN Function
 */
int
main (int argc, char *argv[])
{
	// Set to same locale as system
	setlocale(LC_ALL, "");

	EFloat *i;
	i = malloc(sizeof *i);
	free(i);

	PWindowRequest window_request;
	window_request.name = L"DarkEngine Test 😀";
	window_request.x = 400;
	window_request.y = 200;
	window_request.width = 1280;
	window_request.height = 720;
	window_request.display_type = P_DISPLAY_WINDOWED;
	window_request.interact_type = P_INTERACT_INPUT_OUTPUT;

	PAppInstance *app_instance = p_app_init(&window_request);
	sleep(1);
	p_app_deinit(app_instance);


	return 0;
}
