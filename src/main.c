#include "main.h"

dynarr *a(void);

/**
 * MAIN Function
 */
int
main (int argc, char *argv[])
{
	//obsidian_helloWorld();

	dynarr *i = a();
	printf("%f\n", ((efloat*)i->arr)[0]);
	printf("%f\n", e_sqrtf(((efloat*)i->arr)[0]));
	printf("%f\n", e_sqrtf(((efloat*)i->arr)[1]));
	e_dynarr_deinit(i);

	exit(0);
	return 0;
}


dynarr *a(void)
{
	dynarr *i = e_dynarr_init(sizeof(efloat*), 1);
	efloat four = 4;
	efloat nine = 9;
	e_dynarr_add(i, &four);
	e_dynarr_add(i, &nine);
	return i;
}
