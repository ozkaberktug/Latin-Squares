#ifndef FRAMEWORK_H
#define FRAMEWORK_H

#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>

#define STACK_SIZE (1024 * 6 * sizeof(int))

__device__ int test_function(int *, int, int*);
void init(int);

void swap(int *a, int *b);
void rev(int *s, int l, int r);
int binary_search(int *s, int l, int r, int key);
int nextpermutation(int *s, int n);
int fact(int n);

#endif
