#include "main.h"

/**
 * MAIN Function
 */
int
main (int argc, char *argv[])
{
	//obsidian_helloWorld();
	efloat *i;
	i = malloc((sizeof * i) * 5);
	i[0] = 3;
	i[1] = 4;
	printf("%f", e_length2(i));
	free(i);
	exit(0);
	return 0;
}

