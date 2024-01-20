#include "main.h"
#include <enigma.h>
#include <phantom.h>
#include <wchar.h>
#include <string.h>

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
 * app_request_create
 *
 * generates a PAppRequest and returns it
 */
static PAppRequest *app_request_create(void)
{
	PAppRequest *app_request = calloc(1, sizeof(PAppRequest));

	app_request->graphical_app_request.headless = false;

	return app_request;
}

/**
 * app_request_destroy
 *
 * deinits data created as a part of request init
 */
static void app_request_destroy(PAppRequest *app_request)
{
	free(app_request);
}

/**
 * window_request_create
 *
 * generates a PWindowRequest and returns it
 */
static PWindowRequest *window_request_create(void)
{
	PWindowRequest *window_request = calloc(1, sizeof *window_request);
	window_request->x = 400;
	window_request->y = 200;
	window_request->width = 1280;
	window_request->height = 720;
	window_request->name = L"DarkEngine Test 😀";
	window_request->display_type = P_DISPLAY_WINDOWED;
	window_request->interact_type = P_INTERACT_INPUT_OUTPUT;

	PGraphicalDisplayRequest *graphical_display_request = &window_request->graphical_display_request;

	graphical_display_request->headless = false;
	graphical_display_request->stereoscopic = false;

	return window_request;
}

/**
 * window_request_destroy
 *
 * deinits data created as a part of request init
 */
static void window_request_destroy(PWindowRequest *window_request)
{
	free(window_request);
}

/**
 * MAIN Function
 */
int
main (int argc, char *argv[])
{

	PAppRequest *app_request = app_request_create();
	PAppData *app_data = p_app_init(*app_request);
	app_request_destroy(app_request);

	PWindowRequest *window_request = window_request_create();
	p_window_create(app_data, *window_request);
	window_request_destroy(window_request);

	//p_window_windowed(E_DYNARR_GET(app_data->window_settings, PWindowSettings *, 0), 401, 200, 1600, 1000);
	//sleep(1);
	//e_log_message(E_LOG_INFO, L"Main", L"Display Type: %i",
	//		E_DYNARR_GET(app_data->window_settings, PWindowSettings *, 0)->display_type);

	//p_window_fullscreen(E_DYNARR_GET(app_data->window_settings, PWindowSettings *, 0));
	//sleep(1);
	//e_log_message(E_LOG_INFO, L"Main", L"Display Type: %i",
	//		E_DYNARR_GET(app_data->window_settings, PWindowSettings *, 0)->display_type);

	//p_window_docked_fullscreen(E_DYNARR_GET(app_data->window_settings, PWindowSettings *, 0));
	//sleep(1);
	//e_log_message(E_LOG_INFO, L"Main", L"Display Type: %i",
	//		E_DYNARR_GET(app_data->window_settings, PWindowSettings *, 0)->display_type);

	//p_window_windowed(E_DYNARR_GET(app_data->window_settings, PWindowSettings *, 0), 400, 200, 1280, 720);
	//sleep(1);
	//e_log_message(E_LOG_INFO, L"Main", L"Display Type: %i",
	//		E_DYNARR_GET(app_data->window_settings, PWindowSettings *, 0)->display_type);

	// MAIN LOOP
	while(app_data->window_data->num_items)
		e_sleep_ms(10);

	p_app_deinit(app_data);

	return 0;
}
