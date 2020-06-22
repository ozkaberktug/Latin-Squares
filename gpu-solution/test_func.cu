#include "framework.cuh"

#define INDEX(_col, _row) (_row * n + _col)

__device__ void copyMatrix(int *src, int *dest, int n)
{
    int i;
    for (i = 0; i < n * n; i++)
    {
        dest[i] = src[i];
    }
}

__device__ int test_function(int *matrix, int n, int *answer)
{
    if (matrix[INDEX(0, 0)] + matrix[INDEX(1, 1)] == 9 &&
        matrix[INDEX(1, 0)] + matrix[INDEX(0, 1)] == 9 &&
        matrix[INDEX(0, 4)] + matrix[INDEX(1, 5)] == 8 &&
        matrix[INDEX(1, 4)] + matrix[INDEX(0, 5)] == 8 &&
        (matrix[INDEX(1, 4)] - matrix[INDEX(2, 5)] == 2 || matrix[INDEX(1, 4)] - matrix[INDEX(2, 5)] == -2) &&
        (matrix[INDEX(2, 4)] - matrix[INDEX(1, 5)] == 2 || matrix[INDEX(2, 4)] - matrix[INDEX(1, 5)] == -2) &&
        (matrix[INDEX(4, 4)] - matrix[INDEX(5, 5)] == 2 || matrix[INDEX(4, 4)] - matrix[INDEX(5, 5)] == -2) &&
        (matrix[INDEX(4, 5)] - matrix[INDEX(5, 4)] == 2 || matrix[INDEX(4, 5)] - matrix[INDEX(5, 4)] == -2) &&
        (matrix[INDEX(4, 4)] - matrix[INDEX(3, 3)] == 3 || matrix[INDEX(4, 4)] - matrix[INDEX(3, 3)] == -3) &&
        (matrix[INDEX(4, 3)] - matrix[INDEX(3, 4)] == 3 || matrix[INDEX(4, 3)] - matrix[INDEX(3, 4)] == -3) &&
        (matrix[INDEX(3, 1)] - matrix[INDEX(4, 2)] == 3 || matrix[INDEX(3, 1)] - matrix[INDEX(4, 2)] == -3) &&
        (matrix[INDEX(3, 2)] - matrix[INDEX(4, 1)] == 3 || matrix[INDEX(3, 2)] - matrix[INDEX(4, 1)] == -3) &&
        matrix[INDEX(0, 3)] * matrix[INDEX(1, 4)] == 6 &&
        matrix[INDEX(0, 4)] * matrix[INDEX(1, 3)] == 6)
    {
        copyMatrix(matrix, answer, n);
        return 1;
    }
    return 0;
}
