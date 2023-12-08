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

	printf("%f\n", e_length2(i));
	printf("%f\n", e_sqrtf(9));
	printf("%f\n", sqrt(9));

	free(i);
	exit(0);
	return 0;
}

