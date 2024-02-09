#include "config.h"
#include <iniparser.h>

/**
 * engine_config_create
 *
 * creates an engine configuration from a config file
 */
EngineConfig *engine_config_create(const char * const config_path)
{
	EngineConfig *config = malloc(sizeof *config);

	if (config_path == NULL)
	{
		p_log_message(P_LOG_DEBUG, L"Config", L"No config file specified, using defaults");
		config->name = L"DarkEngine";
		config->version = L"1.0.0";
		config->config_phantom = malloc(sizeof *config);
		config->config_phantom->shader_path = "build/src/phantom/shaders/";
		return config;
	} else if (p_file_exists(config_path) == false) {
		p_log_message(P_LOG_ERROR, L"Config", L"Config file not found");
		exit(1);
	} else {

		dictionary *config_data = iniparser_load(config_path);
		if (config_data == NULL)
		{
			p_log_message(P_LOG_ERROR, L"Config", L"Could not find or parse config file");
			exit(1);
		}

		const uint max_string_len = 64;

		wchar_t *engine_name = malloc(max_string_len * sizeof(wchar_t));
		mbstowcs(engine_name, iniparser_getstring(config_data, "Engine:name", NULL), max_string_len);
		p_log_message(P_LOG_DEBUG, L"Config", L"Engine name: %ls", engine_name);

		wchar_t *engine_version = malloc(max_string_len * sizeof(wchar_t));
		mbstowcs(engine_version, iniparser_getstring(config_data, "Engine:version", NULL), max_string_len);
		p_log_message(P_LOG_DEBUG, L"Config", L"Engine version: %ls", engine_version);

		char *phantom_shader_path = malloc(max_string_len * sizeof(char));
		strncpy(phantom_shader_path, iniparser_getstring(config_data, "Phantom:shader_path", NULL), max_string_len);
		p_log_message(P_LOG_DEBUG, L"Config", L"Phantom shader path: %s", phantom_shader_path);

		iniparser_freedict(config_data);

		config->name = engine_name;
		config->version = engine_version;
		config->config_phantom = malloc(sizeof *config);
		config->config_phantom->shader_path = phantom_shader_path;
		return config;
	}
}
