#include "framework.cuh"

void copy_matrix(short *dst, short *src, int n)
{
    for (unsigned i = 0; i < n * n; i++)
        dst[i] = src[i];
}

void debug_printMatrix(short *matrix, int n)
{
    for (unsigned i = 0; i < n; i++)
    {
        for (unsigned j = 0; j < n; j++)
        {
            printf("%d ", matrix[i * n + j]);
        }
        putchar('\n');
    }
}

void debug_printSamples(short *matrix, int n)
{
    for (unsigned i = 0; i < n; i++)
    {
        debug_printMatrix(&matrix[i * N * N], N);
        getchar();
    }
}