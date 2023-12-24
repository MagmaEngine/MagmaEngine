#include "main.h"
#include "enigma.h"
#include "phantom.h"
#include <unistd.h>
#include <wchar.h>

/**
 * print_event_type
 *
 * Custom test function for printing window events
 */
void print_event(void)
{
	e_log_message(E_LOG_INFO, L"Main", L"EVENT occured!");
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
	window_request.event_calls.enable_client = false;
	window_request.event_calls.enable_configure = false;
	window_request.event_calls.enable_destroy = false;
	window_request.event_calls.enable_enter = false;
	window_request.event_calls.enable_expose = false;
	window_request.event_calls.enable_focus_in = false;
	window_request.event_calls.enable_focus_out = false;
	window_request.event_calls.enable_leave = false;
	window_request.event_calls.enable_property = false;
	window_request.event_calls.client = print_event;
	window_request.event_calls.configure = print_event;
	window_request.event_calls.destroy = print_event;
	window_request.event_calls.enter = print_event;
	window_request.event_calls.expose = print_event;
	window_request.event_calls.focus_in = print_event;
	window_request.event_calls.focus_out = print_event;
	window_request.event_calls.leave = print_event;
	window_request.event_calls.property = print_event;

	p_window_create(app_instance, window_request);

	//p_window_windowed(((PWindowSettings **)app_instance->window_settings->arr)[0], 401, 200, 1600, 1000);
	sleep(1);
	e_log_message(E_LOG_INFO, L"Main", L"Display Type: %i",
			((PWindowSettings **)app_instance->window_settings->arr)[0]->display_type);

	//p_window_fullscreen(((PWindowSettings **)app_instance->window_settings->arr)[0]);
	//sleep(1);
	//e_log_message(E_LOG_INFO, L"Main", L"Display Type: %i",
	//		((PWindowSettings **)app_instance->window_settings->arr)[0]->display_type);

	//p_window_docked_fullscreen(((PWindowSettings **)app_instance->window_settings->arr)[0]);
	//sleep(1);
	//e_log_message(E_LOG_INFO, L"Main", L"Display Type: %i",
	//		((PWindowSettings **)app_instance->window_settings->arr)[0]->display_type);

	//p_window_windowed(((PWindowSettings **)app_instance->window_settings->arr)[0], 400, 200, 1280, 720);
	//sleep(1);
	//e_log_message(E_LOG_INFO, L"Main", L"Display Type: %i",
	//		((PWindowSettings **)app_instance->window_settings->arr)[0]->display_type);

	while(app_instance->window_settings->num_items)
		usleep(10000);

	p_app_deinit(app_instance);
	sleep(1);

	return 0;
}
