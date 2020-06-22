#ifndef FRAMEWORK
#define FRAMEWORK

#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>

#define DEVICE_BLOCK_LIMIT 65535    /* limit for sm_20 devices */
#define DEVICE_THREAD_LIMIT 256     /* limit for sm_20 devices */
#define STACK_FRAME_SIZE (1024 * 2) /* 2 KiB stack per thread */

#define N 6                                                         /* degree of latin squares : DO NOT CHANGE*/
#define SAMPLE_CELLS 10                                             /* blocks to fill up !must be lower then N x N */
#define SAMPLE_MAX_LIMIT (DEVICE_BLOCK_LIMIT * DEVICE_THREAD_LIMIT) /* limit for the created instances */

#define CHECK_NULL(x)                                                              \
    if (x == NULL)                                                                 \
    {                                                                              \
        fprintf(stderr, "\n%s:%d - Null pointer exception\n", __FILE__, __LINE__); \
        exit(EXIT_FAILURE);                                                        \
    }
#define CHECK_CUDA(x)                                                                        \
    if (x != cudaSuccess)                                                                    \
    {                                                                                        \
        fprintf(stderr, "\n%s:%d - %s(%d)\n", __FILE__, __LINE__, cudaGetErrorString(x), x); \
        exit(EXIT_FAILURE);                                                                  \
    }

/* utility functions */
void copy_matrix(short *dst, short *src, int n);
void debug_printMatrix(short *matrix, int n);
void debug_printSamples(short *matrix, int n);

/* device functions */
__global__ void bootKernel(short *answer, short *pSamples, int *nSize, int *ss);
__device__ void test_function(short *matrix, short *answer);

/* host functions */
short *samples_init(int *nSize);
void init();

#endif