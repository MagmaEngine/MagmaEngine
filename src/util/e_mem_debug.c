#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "util.h"

extern void e_debug_mem_print(uint min_allocs);

#define F_MEMORY_OVER_ALLOC 32
#define F_MEMORY_MAGIC_NUMBER 132
typedef struct{
	uint size;
	void *buf;
}STMemAllocBuf;

typedef struct{
	uint line;
	char file[256];
	STMemAllocBuf *allocs;
	uint alloc_count;
	uint alloc_alocated;
	uint size;
	uint alocated;
	uint freed;
}STMemAllocLine;

STMemAllocLine e_alloc_lines[1024];
uint e_alloc_line_count = 0;
void *e_alloc_mutex = NULL;
void (*e_alloc_mutex_lock)(void *mutex) = NULL;
void (*e_alloc_mutex_unlock)(void *mutex) = NULL;


void e_debug_memory_init(void (*lock)(void *mutex), void (*unlock)(void *mutex), void *mutex)
{
	e_alloc_mutex = mutex;
	e_alloc_mutex_lock = lock;
	e_alloc_mutex_unlock = unlock;
}

bool e_debug_memory(void)
{
	bool output = false;
	uint i, j, k;
	if(e_alloc_mutex != NULL)
		e_alloc_mutex_lock(e_alloc_mutex);
	for(i = 0; i < e_alloc_line_count; i++)
	{
		for(j = 0; j < e_alloc_lines[i].alloc_count; j++)
		{
			uint8_t *buf;
			uint size;
			buf = e_alloc_lines[i].allocs[j].buf;
			size = e_alloc_lines[i].allocs[j].size;
			for(k = 0; k < F_MEMORY_OVER_ALLOC; k++)
				if(buf[size + k] != F_MEMORY_MAGIC_NUMBER)
					break;
			if(k < F_MEMORY_OVER_ALLOC)
			{
				printf("MEM ERROR: Overshoot at line %u in file %s\n", e_alloc_lines[i].line, e_alloc_lines[i].file);
				{
					uint *X = NULL;
					X[0] = 0;
				}
				output = true;
			}
		}
	}
	if(e_alloc_mutex != NULL)
		e_alloc_mutex_unlock(e_alloc_mutex);
	return output;
}

void e_debug_mem_add(void *pointer, uint size, char *file, uint line)
{
	uint i, j;
	for(i = 0; i < F_MEMORY_OVER_ALLOC; i++)
		((uint8_t *)pointer)[size + i] = F_MEMORY_MAGIC_NUMBER;

	for(i = 0; i < e_alloc_line_count; i++)
	{
		if(line == e_alloc_lines[i].line)
		{
			for(j = 0; file[j] != 0 && file[j] == e_alloc_lines[i].file[j] ; j++);
			if(file[j] == e_alloc_lines[i].file[j])
				break;
		}
	}
	if(i < e_alloc_line_count)
	{
		if(e_alloc_lines[i].alloc_alocated == e_alloc_lines[i].alloc_count)
		{
			e_alloc_lines[i].alloc_alocated += 1024;
			e_alloc_lines[i].allocs = (realloc)(e_alloc_lines[i].allocs, (sizeof *e_alloc_lines[i].allocs) * e_alloc_lines[i].alloc_alocated);
		}
		e_alloc_lines[i].allocs[e_alloc_lines[i].alloc_count].size = size;
		e_alloc_lines[i].allocs[e_alloc_lines[i].alloc_count++].buf = pointer;
		e_alloc_lines[i].size += size;
		e_alloc_lines[i].alocated++;
	}else
	{
		if(i < 1024)
		{
			e_alloc_lines[i].line = line;
			for(j = 0; j < 255 && file[j] != 0; j++)
				e_alloc_lines[i].file[j] = file[j];
			e_alloc_lines[i].file[j] = 0;
			e_alloc_lines[i].alloc_alocated = 256;
			e_alloc_lines[i].allocs = (malloc)((sizeof *e_alloc_lines[i].allocs) * e_alloc_lines[i].alloc_alocated);
			e_alloc_lines[i].allocs[0].size = size;
			e_alloc_lines[i].allocs[0].buf = pointer;
			e_alloc_lines[i].alloc_count = 1;
			e_alloc_lines[i].size = size;
			e_alloc_lines[i].freed = 0;
			e_alloc_lines[i].alocated++;
			e_alloc_line_count++;
		}
	}
}

void *e_debug_mem_malloc(size_t size, char *file, uint line)
{
	void *pointer;
	uint i;
	if(e_alloc_mutex != NULL)
		e_alloc_mutex_lock(e_alloc_mutex);
	pointer = (malloc)(size + F_MEMORY_OVER_ALLOC);

	if(pointer == NULL)
	{
		printf("MEM ERROR: Malloc returns NULL when trying to allocate %zu bytes at line %u in file %s\n", size, line, file);
		if(e_alloc_mutex != NULL)
			e_alloc_mutex_unlock(e_alloc_mutex);
		e_debug_mem_print(0);
		exit(0);
	}
	for(i = 0; i < size + F_MEMORY_OVER_ALLOC; i++)
 		((uint8_t *)pointer)[i] = F_MEMORY_MAGIC_NUMBER + 1;
	e_debug_mem_add(pointer, size, file, line);
	if(e_alloc_mutex != NULL)
		e_alloc_mutex_unlock(e_alloc_mutex);
	return pointer;
}

bool e_debug_mem_remove(void *buf)
{
	uint i, j, k;
	for(i = 0; i < e_alloc_line_count; i++)
	{
		for(j = 0; j < e_alloc_lines[i].alloc_count; j++)
		{
			if(e_alloc_lines[i].allocs[j].buf == buf)
			{
				for(k = 0; k < F_MEMORY_OVER_ALLOC; k++)
					if(((uint8_t *)buf)[e_alloc_lines[i].allocs[j].size + k] != F_MEMORY_MAGIC_NUMBER)
						break;
				if(k < F_MEMORY_OVER_ALLOC)
					printf("MEM ERROR: Overshoot at line %u in file %s\n", e_alloc_lines[i].line, e_alloc_lines[i].file);
				e_alloc_lines[i].size -= e_alloc_lines[i].allocs[j].size;
				e_alloc_lines[i].allocs[j] = e_alloc_lines[i].allocs[--e_alloc_lines[i].alloc_count];
				e_alloc_lines[i].freed++;
				return true;
			}
		}
	}
	return false;
}

void e_debug_mem_free(void *buf)
{
	if(e_alloc_mutex != NULL)
		e_alloc_mutex_lock(e_alloc_mutex);
	if(!e_debug_mem_remove(buf))
	{
		uint *X = NULL;
		X[0] = 0;
	}
	(free)(buf);
	if(e_alloc_mutex != NULL)
		e_alloc_mutex_unlock(e_alloc_mutex);
}


void *e_debug_mem_realloc(void *pointer, size_t size, char *file, uint line)
{
	uint i, j, k, move;
	void *pointer2;
	if(pointer == NULL)
		return e_debug_mem_malloc( size, file, line);

	if(e_alloc_mutex != NULL)
		e_alloc_mutex_lock(e_alloc_mutex);
	for(i = 0; i < e_alloc_line_count; i++)
	{
		for(j = 0; j < e_alloc_lines[i].alloc_count; j++)
			if(e_alloc_lines[i].allocs[j].buf == pointer)
				break;
		if(j < e_alloc_lines[i].alloc_count)
			break;
	}
	if(i == e_alloc_line_count)
	{
		printf("FORGE Mem debugger error. Trying to reallocate pointer %p in %s line %u. Pointer has never beein allocated\n", pointer, file, line);
		for(i = 0; i < e_alloc_line_count; i++)
		{
			for(j = 0; j < e_alloc_lines[i].alloc_count; j++)
			{
				uint *buf;
				buf = e_alloc_lines[i].allocs[j].buf;
				for(k = 0; k < e_alloc_lines[i].allocs[j].size; k++)
				{
					if(&buf[k] == pointer)
					{
						printf("Trying to reallocate pointer %u bytes (out of %u) in to allocation made in %s on line %u.\n", k, e_alloc_lines[i].allocs[j].size, e_alloc_lines[i].file, e_alloc_lines[i].line);
					}
				}
			}
		}
		exit(0);
	}
	move = e_alloc_lines[i].allocs[j].size;

	if(move > size)
		move = size;

	pointer2 = (malloc)(size + F_MEMORY_OVER_ALLOC);
	if(pointer2 == NULL)
	{
		printf("MEM ERROR: Realloc returns NULL when trying to allocate %zu bytes at line %u in file %s\n", size, line, file);
		if(e_alloc_mutex != NULL)
			e_alloc_mutex_unlock(e_alloc_mutex);
		e_debug_mem_print(0);
		exit(0);
	}
	for(i = 0; i < size + F_MEMORY_OVER_ALLOC; i++)
 		((uint8_t *)pointer2)[i] = F_MEMORY_MAGIC_NUMBER + 1;
	memcpy(pointer2, pointer, move);

	e_debug_mem_add(pointer2, size, file, line);
	e_debug_mem_remove(pointer);
	(free)(pointer);

	if(e_alloc_mutex != NULL)
		e_alloc_mutex_unlock(e_alloc_mutex);
	return pointer2;
}

void e_debug_mem_print(uint min_allocs)
{
	uint i;
	if(e_alloc_mutex != NULL)
		e_alloc_mutex_lock(e_alloc_mutex);
	printf("Memory repport:\n----------------------------------------------\n");
	for(i = 0; i < e_alloc_line_count; i++)
	{
		if(min_allocs < e_alloc_lines[i].alocated)
		{
			printf("%s line: %u\n",e_alloc_lines[i].file, e_alloc_lines[i].line);
			printf(" - Bytes allocated: %u\n - Allocations: %u\n - Frees: %u\n\n", e_alloc_lines[i].size, e_alloc_lines[i].alocated, e_alloc_lines[i].freed);
		}
	}
	printf("----------------------------------------------\n");
	if(e_alloc_mutex != NULL)
		e_alloc_mutex_unlock(e_alloc_mutex);
}

uint32_t e_debug_mem_consumption(void)
{
	uint i, sum = 0;

	if(e_alloc_mutex != NULL)
		e_alloc_mutex_lock(e_alloc_mutex);
	for(i = 0; i < e_alloc_line_count; i++)
		sum += e_alloc_lines[i].size;
	if(e_alloc_mutex != NULL)
		e_alloc_mutex_unlock(e_alloc_mutex);
	return sum;
}

void e_debug_mem_reset(void)
{
	uint i;
	if(e_alloc_mutex != NULL)
		e_alloc_mutex_lock(e_alloc_mutex);
	for(i = 0; i < e_alloc_line_count; i++)
		(free)(e_alloc_lines[i].allocs);
	e_alloc_line_count = 0;

	if(e_alloc_mutex != NULL)
		e_alloc_mutex_unlock(e_alloc_mutex);
}

void exit_crash(uint i)
{
	uint *a = NULL;
	a[0] = i;
}

