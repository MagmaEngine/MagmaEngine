#include "main.h"
#include <enigma.h>
#include <phantom.h>
#include <wchar.h>
#include <string.h>

#ifdef _MSC_VER
#    pragma comment(linker, "/subsystem:windows /ENTRY:mainCRTStartup")
#endif

#ifdef PHANTOM_DISPLAY_X11
#include <vulkan/vulkan_xcb.h>
#elif defined PHANTOM_DISPLAY_WIN32
#include <vulkan/vulkan_win32.h>
#endif // PHANTOM_DISPLAY_XXXXXX

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
	// TODO: make Phantom wrap vulkan
	PAppRequest *app_request = calloc(1, sizeof(PAppRequest));
	app_request->vulkan_app_request = malloc(sizeof(PVulkanAppRequest));

	// extensions
	app_request->vulkan_app_request->required_extensions = e_dynarr_init(sizeof(char *), 3);
	e_dynarr_add(app_request->vulkan_app_request->required_extensions, E_VOID_PTR_FROM_VALUE(char *,
				VK_KHR_SURFACE_EXTENSION_NAME));
#ifdef PHANTOM_DISPLAY_X11
	e_dynarr_add(app_request->vulkan_app_request->required_extensions, E_VOID_PTR_FROM_VALUE(char *,
				VK_KHR_XCB_SURFACE_EXTENSION_NAME));
#endif // PHANTOM_DISPLAY_X11
#ifdef PHANTOM_DISPLAY_WIN32
	e_dynarr_add(app_request.vulkan_app_request->required_extensions, E_VOID_PTR_FROM_VALUE(char *,
				VK_KHR_WIN32_SURFACE_EXTENSION_NAME));
#endif // PHANTOM_DISPLAY_WIN32
#ifdef PHANTOM_DEBUG_VULKAN
	e_dynarr_add(app_request->vulkan_app_request->required_extensions, E_VOID_PTR_FROM_VALUE(char *,
				VK_EXT_DEBUG_UTILS_EXTENSION_NAME));
#endif // PHANTOM_DEBUG_VULKAN

	// layers
	app_request->vulkan_app_request->required_layers = e_dynarr_init(sizeof(char *), 1);
#ifdef PHANTOM_DEBUG_VULKAN
	e_dynarr_add(app_request->vulkan_app_request->required_layers, E_VOID_PTR_FROM_VALUE(char *,
				"VK_LAYER_KHRONOS_validation"));
#endif // PHANTOM_DEBUG_VULKAN
	return app_request;
}

/**
 * app_request_destroy
 *
 * deinits data created as a part of request init
 */
static void app_request_destroy(PAppRequest *app_request)
{
	e_dynarr_deinit(app_request->vulkan_app_request->required_extensions);
	e_dynarr_deinit(app_request->vulkan_app_request->required_layers);
	free(app_request->vulkan_app_request);
	free(app_request);
}


/**
 * window_request_create
 *
 * generates a PVulkanDisplayRequest and returns it as part of request
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

	PVulkanDisplayRequest *vulkan_display_request = &window_request->vulkan_display_request;

	vulkan_display_request->require_present = true;

	// extensions
	vulkan_display_request->required_extensions = e_dynarr_init(sizeof(char *), 3);
	e_dynarr_add(vulkan_display_request->required_extensions, E_VOID_PTR_FROM_VALUE(char *,
				VK_KHR_SWAPCHAIN_EXTENSION_NAME));

	// layers
	vulkan_display_request->required_layers = e_dynarr_init(sizeof(char *), 1);
#ifdef PHANTOM_DEBUG_VULKAN
	e_dynarr_add(vulkan_display_request->required_layers, E_VOID_PTR_FROM_VALUE(char *,
				"VK_LAYER_KHRONOS_validation"));
#endif // PHANTOM_DEBUG_VULKAN
	vulkan_display_request->required_queue_flags = VK_QUEUE_GRAPHICS_BIT;

	vulkan_display_request->required_features.geometryShader = true;
	return window_request;
}

/**
 * window_request_destroy
 *
 * deinits data created as a part of request init
 */
static void window_request_destroy(PWindowRequest *window_request)
{
	e_dynarr_deinit(window_request->vulkan_display_request.required_extensions);
	e_dynarr_deinit(window_request->vulkan_display_request.required_layers);
	free(window_request);
}

/**
 * MAIN Function
 */
int
main (int argc, char *argv[])
{

	PAppRequest *app_request = app_request_create();
	PAppInstance *app_instance = p_app_init(*app_request);
	app_request_destroy(app_request);

	PWindowRequest *window_request = window_request_create();
	p_window_create(app_instance, *window_request);
	window_request_destroy(window_request);

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
