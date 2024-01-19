#include "main.h"
#include <enigma.h>
#include <phantom.h>
#include <wchar.h>

#ifdef _MSC_VER
#    pragma comment(linker, "/subsystem:windows /ENTRY:mainCRTStartup")
#endif

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

	PWindowRequest window_request = {0};
	window_request.x = 400;
	window_request.y = 200;
	window_request.width = 1280;
	window_request.height = 720;
	window_request.name = L"DarkEngine Test 😀";
	window_request.display_type = P_DISPLAY_WINDOWED;
	window_request.interact_type = P_INTERACT_INPUT_OUTPUT;

	p_window_create(app_instance, window_request);

	//p_window_windowed(E_DYNARR_GET(app_instance->window_settings, PWindowSettings *, 0), 401, 200, 1600, 1000);
	//sleep(1);
	//e_log_message(E_LOG_INFO, L"Main", L"Display Type: %i",
	//		E_DYNARR_GET(app_instance->window_settings, PWindowSettings *, 0)->display_type);

	//p_window_fullscreen(E_DYNARR_GET(app_instance->window_settings, PWindowSettings *, 0));
	//sleep(1);
	//e_log_message(E_LOG_INFO, L"Main", L"Display Type: %i",
	//		E_DYNARR_GET(app_instance->window_settings, PWindowSettings *, 0)->display_type);

	//p_window_docked_fullscreen(E_DYNARR_GET(app_instance->window_settings, PWindowSettings *, 0));
	//sleep(1);
	//e_log_message(E_LOG_INFO, L"Main", L"Display Type: %i",
	//		E_DYNARR_GET(app_instance->window_settings, PWindowSettings *, 0)->display_type);

	//p_window_windowed(E_DYNARR_GET(app_instance->window_settings, PWindowSettings *, 0), 400, 200, 1280, 720);
	//sleep(1);
	//e_log_message(E_LOG_INFO, L"Main", L"Display Type: %i",
	//		E_DYNARR_GET(app_instance->window_settings, PWindowSettings *, 0)->display_type);

	// MAIN LOOP
	while(app_instance->window_data->num_items)
		e_sleep_ms(10);

	p_app_deinit(app_instance);

	return 0;
}
