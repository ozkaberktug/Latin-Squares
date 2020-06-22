#include <framework.cuh>

__device__ int getNextEmptyLocation(short *matrix, int *loc_row, int *loc_col)
{
    int i, j;
    for (i = 0; i < N; i++)
    {
        for (j = 0; j < N; j++)
        {
            if (matrix[i * N + j] == 0)
            {
                *loc_row = i;
                *loc_col = j;
                return 0;
            }
        }
    }
    return 1;
}

__device__ int isOK(short *matrix, int r, int c, int val)
{
    int i;
    for (i = 0; i < N; i++)
    {
        if (matrix[r * N + i] == val)
            return 0;
        if (matrix[i * N + c] == val)
            return 0;
    }
    return 1;
}

__device__ void createLatinSquare(short *matrix, int *ss, short *answer)
{
    size_t sp = 0;
    int x, r, c, retVal;

start:
    retVal = getNextEmptyLocation(matrix, &r, &c);
    if (retVal == 1)
    {
        // call test_function
        //test_function(matrix, answer);

        // popup variables in reverse order
        sp--;
        c = ss[sp];
        sp--;
        r = ss[sp];
        sp--;
        x = ss[sp];

        // return to the code
        goto resume;
    }
    for (x = 1; x <= N; x++)
    {
        if (isOK(matrix, r, c, x))
        {
            matrix[r * N + c] = x;
            // push all the variables to the stack
            // except n and matrix, they are not changing
            ss[sp] = x;
            sp++;
            ss[sp] = r;
            sp++;
            ss[sp] = c;
            sp++;
            // jump to start
            goto start;
        resume:
            matrix[r * N + c] = 0;
        }
    }
    if (sp != 0)
    {
        // popup variables in reverse order
        sp--;
        c = ss[sp];
        sp--;
        r = ss[sp];
        sp--;
        x = ss[sp];

        // return to the code
        goto resume;
    }
}

__global__ void bootKernel(short *answer, short *pSamples, int *nSize, int *ss)
{
    int tid = blockIdx.x * blockDim.x + threadIdx.x;

    if (tid < (*nSize))
        createLatinSquare(&pSamples[tid * N * N], &ss[tid * STACK_FRAME_SIZE], answer);
}
