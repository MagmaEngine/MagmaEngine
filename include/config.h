#ifndef _ENGINE_CONFIG_H
#define _ENGINE_CONFIG_H

#include <platinum.h>

enum config_section {
	CONFIG_SECTION_ENGINE,
	CONFIG_SECTION_PLATINUM,
	CONFIG_SECTION_MAX
};

typedef struct {
	wchar_t *name;
	wchar_t *version;
	PAppConfig *config_platinum;
} EngineConfig;

typedef struct {
	char *flag;
	char *flag_long;
	char *description;
	bool value;			// whether this arg has a value
	bool enabled;		// if this arg doesn't have a value, whether this is enabled
	char *value_str;
} EngineArg;

// Config
EngineConfig *engine_config_create(const char * const config_path);

// Args
void parse_args(PDynarr *engine_args, int argc, char **argv); // PDynarr contains EngineArg *
void print_help(PDynarr *engine_args); // PDynarr contains EngineArg *

#endif // _ENGINE_CONFIG_H
