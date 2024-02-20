#include "config.h"
#include <string.h>

/**
 * print_help
 *
 * automatically generates a help message
 * based on the engine_args and prints it
 */
void print_help(PDynarr *engine_args)
{
	p_log_message(P_LOG_INFO, L"Args", L"USAGE: dark [OPTIONS]");
	p_log_message(P_LOG_INFO, L"Args", L"Options:");
	uint longest_flag_length = 0;
	for (uint i = 0; i < p_dynarr_count(engine_args); i++)
	{
		EngineArg *arg = p_dynarr_get(engine_args, EngineArg *, i);
		if (strlen(arg->flag_long) > longest_flag_length)
			longest_flag_length = strlen(arg->flag_long);
	}

	for (uint i = 0; i < p_dynarr_count(engine_args); i++)
	{
		EngineArg *arg = p_dynarr_get(engine_args, EngineArg *, i);
		p_log_message(P_LOG_INFO, L"Args", L"\t%-5s%-*s%s", arg->flag, longest_flag_length+2, arg->flag_long,
				arg->description);
	}
}

/**
 * parse_args
 *
 * parses the command line arguments
 * modifies the engine_args with the enabled flags
 */
void parse_args(PDynarr *engine_args, int argc, char **argv)
{
	p_log_message(P_LOG_DEBUG, L"Args", L"parsing %d args", argc);
	for (int i = 1; i < argc; i++)
	{
		p_log_message(P_LOG_DEBUG, L"Args", L"arg %d: %s", i, argv[i]);
		bool found_flag = false;
		for (uint j = 0; j < p_dynarr_count(engine_args); j++)
		{
			EngineArg *arg = p_dynarr_get(engine_args, EngineArg *, j);
			char *flag = arg->flag;
			char *flag_long = arg->flag_long;
			if (strncmp(argv[i], flag, strlen(argv[i])) == 0 || strncmp(argv[i], flag_long, strlen(argv[i])) == 0)
			{
				p_log_message(P_LOG_DEBUG, L"Args", L"found flag %s", arg->flag);
				found_flag = true;
				p_dynarr_get(engine_args, EngineArg *, j)->enabled = true;
				if (p_dynarr_get(engine_args, EngineArg *, j)->value)
				{
					if (i+1 >= argc)
					{
						p_log_message(P_LOG_ERROR, L"Args", L"Expected value for flag: %s", argv[i]);
						print_help(engine_args);
						exit(1);
					}
					p_dynarr_get(engine_args, EngineArg *, j)->value_str = argv[++i];
					p_log_message(P_LOG_DEBUG, L"Args", L"found value %s", p_dynarr_get(engine_args, EngineArg *, j)
							->value_str);
				}
			}
		}
		if (!found_flag)
		{
			p_log_message(P_LOG_ERROR, L"Args", L"Unknown flag: %s", argv[i]);
			print_help(engine_args);
			exit(1);
		}
	}
}

