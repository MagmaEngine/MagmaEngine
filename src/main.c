#include "main.h"
#include "enigma.h"
#include "phantom.h"
#include <stdio.h>
#include <unistd.h>
#include <wchar.h>

/**
 * print_event_type
 *
 * Custom test function for printing window events
 */
void print_event_type(void *args)
{
#ifdef _PHANTOM_LINUX
	xcb_generic_event_t *event = (xcb_generic_event_t *)args;
	printf("EVENT: %i\n", event->response_type);
#endif
#ifdef _PHANTOM_WINDOWS
	printf("EVENT occured!\n");
#endif
}

/**
 * MAIN Function
 */
int
main (int argc, char *argv[])
{
	PAppInstance *app_instance = p_app_init();

	PWindowRequest window_request;
	window_request.x = 400;
	window_request.y = 200;
	window_request.width = 1280;
	window_request.height = 720;
	window_request.name = L"DarkEngine Test 😀";
	window_request.display_type = P_DISPLAY_WINDOWED;
	window_request.interact_type = P_INTERACT_INPUT_OUTPUT;
	window_request.event_calls.enable_client = true;
	window_request.event_calls.enable_configure = true;
	window_request.event_calls.enable_destroy = true;
	window_request.event_calls.enable_enter = true;
	window_request.event_calls.enable_expose = true;
	window_request.event_calls.enable_focus_in = true;
	window_request.event_calls.enable_focus_out = true;
	window_request.event_calls.enable_leave = true;
	window_request.event_calls.enable_map = true;
	window_request.event_calls.enable_property = true;
	window_request.event_calls.enable_unmap = true;
	window_request.event_calls.client = print_event_type;
	window_request.event_calls.configure = print_event_type;
	window_request.event_calls.destroy = print_event_type;
	window_request.event_calls.enter = print_event_type;
	window_request.event_calls.expose = print_event_type;
	window_request.event_calls.focus_in = print_event_type;
	window_request.event_calls.focus_out = print_event_type;
	window_request.event_calls.leave = print_event_type;
	window_request.event_calls.map = print_event_type;
	window_request.event_calls.property = print_event_type;
	window_request.event_calls.unmap = print_event_type;

	p_window_create(app_instance, window_request);
	sleep(1);
	printf("%i\n", ((PWindowSettings **)app_instance->window_settings->arr)[0]->display_type);

	//while(app_instance->window_settings->num_items)
	//	usleep(1000);

	p_window_windowed(((PWindowSettings **)app_instance->window_settings->arr)[0], 401, 200, 1600, 1000);
	sleep(1);
	printf("%i\n", ((PWindowSettings **)app_instance->window_settings->arr)[0]->display_type);

	p_window_fullscreen(((PWindowSettings **)app_instance->window_settings->arr)[0]);
	sleep(1);
	printf("%i\n", ((PWindowSettings **)app_instance->window_settings->arr)[0]->display_type);

	p_window_docked_fullscreen(((PWindowSettings **)app_instance->window_settings->arr)[0]);
	sleep(1);
	printf("%i\n", ((PWindowSettings **)app_instance->window_settings->arr)[0]->display_type);

	p_app_deinit(app_instance);
	usleep(1000);

	return 0;
}
