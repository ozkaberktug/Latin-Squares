#include "framework.cuh"

#define INDEXOF(___block___, ___row___, ___col___) (___block___ * n * n + ___row___ * n + ___col___)
#define TOTAL_HEAP_SIZE (STACK_SIZE * blocks + n * n * blocks * sizeof(int) + 1024)

__device__ int getNextEmptyLocation(int *matrix, int n, int *loc_row, int *loc_col)
{
    int i, j;
    for (i = 0; i < n; i++)
    {
        for (j = 0; j < n; j++)
        {
            if (matrix[i * n + j] == 0)
            {
                *loc_row = i;
                *loc_col = j;
                return 0;
            }
        }
    }
    return 1;
}

__device__ int isOK(int *matrix, int n, int r, int c, int val)
{
    int i;
    for (i = 0; i < n; i++)
    {
        if (matrix[r * n + i] == val)
            return 0;
        if (matrix[i * n + c] == val)
            return 0;
    }
    return 1;
}

__device__ void createLatinSquare(int *matrix, int n, int *ss, int *answer)
{
    // create a stack
    int sp = 0;

    int x, r, c, retVal;

// entry point
start:
    retVal = getNextEmptyLocation(matrix, n, &r, &c);
    if (retVal == 1)
    {
        // call test_function
        /*if (test_function(matrix, n, answer))
            return;*/

        // popup variables in reverse order
        c = ss[--sp];
        r = ss[--sp];
        x = ss[--sp];

        // return to the code
        goto resume;
    }
    for (x = 1; x <= n; x++)
    {
        if (isOK(matrix, n, r, c, x))
        {
            matrix[r * n + c] = x;
            // push all the variables to the stack
            // except n and matrix, they are not changing
            ss[sp++] = x;
            ss[sp++] = r;
            ss[sp++] = c;
            // jump to start
            goto start;
        resume:
            matrix[r * n + c] = 0;
        }
    }
    if (sp != 0)
    {
        // popup variables in reverse order
        c = ss[--sp];
        r = ss[--sp];
        x = ss[--sp];

        // return to the code
        goto resume;
    }

    return;
}

__global__ void runKernel(int *param, int *n, int *blocks, int *ss, int *answer_dev)
{
    if (blockIdx.x < *blocks)
        createLatinSquare(&param[blockIdx.x * (*n) * (*n)], *n, &ss[blockIdx.x * STACK_SIZE], answer_dev);
}

void init(int n)
{
    int i, j;
    cudaError_t err;

    puts("Allocating Host Memory...");

    int *answer = (int *)malloc(sizeof(int) * n * n);
    if (answer == NULL)
    {
        fprintf(stderr, "Could not allocate the memory.");
        exit(EXIT_FAILURE);
    }

    const int blocks = fact(n);
    int *param = (int *)malloc(n * n * blocks * sizeof(int));
    if (param == NULL)
    {
        fprintf(stderr, "Could not allocate the memory.");
        exit(EXIT_FAILURE);
    }
    int *array = (int *)malloc(n * sizeof(int));
    if (array == NULL)
    {
        fprintf(stderr, "Could not allocate the memory.");
        exit(EXIT_FAILURE);
    }
    for (i = 0; i < n; i++)
    {
        array[i] = i + 1;
    }
    for (i = 0; i < blocks; i++)
    {
        for (j = 0; j < n; j++)
        {
            int index = INDEXOF(i, 0, j);
            param[index] = array[j];
        }
        nextpermutation(array, n);
    }
    free(array);

/*
    puts("Configuring device limits...");

    size_t limitStack = 0;
    size_t limitHeap = 0;
    cudaDeviceGetLimit(&limitStack, cudaLimitStackSize);
    printf("    Current stack limit is %lu\n", limitStack);
    cudaDeviceGetLimit(&limitHeap, cudaLimitMallocHeapSize);
    printf("    Previous heap limit was %lu\n", limitHeap);

    err = cudaDeviceSetLimit(cudaLimitMallocHeapSize, TOTAL_HEAP_SIZE);
    if (err != cudaSuccess)
    {
        fprintf(stderr, "%d:%s\n", err, cudaGetErrorString(err));
        exit(EXIT_FAILURE);
    }
    size_t newLimitHeap = 0;
    cudaDeviceGetLimit(&newLimitHeap, cudaLimitMallocHeapSize);
    printf("    Current heap limit is %lu\n", newLimitHeap);
*/
    puts("Allocating Device Memory...");

    int *answer_dev = NULL;
    int *param_dev = NULL;
    int *n_dev = NULL;
    int *blocks_dev = NULL;
    int *ss = NULL;
    cudaMalloc((void **)&ss, STACK_SIZE * blocks);
    cudaMalloc((void **)&n_dev, sizeof(int));
    cudaMalloc((void **)&blocks_dev, sizeof(int));
    cudaMalloc((void **)&param_dev, n * n * blocks * sizeof(int));
    cudaMalloc((void **)&answer_dev, n * n * sizeof(int));
    cudaMemcpy(param_dev, param, n * n * blocks * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(n_dev, &n, sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(blocks_dev, &blocks, sizeof(int), cudaMemcpyHostToDevice);

    // check for errors:
    err = cudaGetLastError();
    if (err != cudaSuccess)
    {
        fprintf(stderr, "%d:%s\n", err, cudaGetErrorString(err));
        exit(EXIT_FAILURE);
    }

    puts("Running Kernel...");

    runKernel<<<1, 1>>>(param_dev, n_dev, blocks_dev, ss, answer_dev);

    free(param);
    cudaDeviceSynchronize();

    puts("Finalizing...");

    cudaMemcpy(answer, answer_dev, sizeof(int) * n * n, cudaMemcpyDeviceToHost);

    cudaFree(answer_dev);
    cudaFree(param_dev);
    cudaFree(n_dev);
    cudaFree(blocks_dev);
    cudaFree(ss);

    // check for errors:
    err = cudaGetLastError();
    if (err != cudaSuccess)
    {
        fprintf(stderr, "%d:%s\n", err, cudaGetErrorString(err));
        exit(EXIT_FAILURE);
    }

    // print results
    puts("Computation done.\n");
    for (i = 0; i < n; i++)
    {
        for (j = 0; j < n; j++)
        {
            printf("%d ", answer[i * n + j]);
        }
        putchar('\n');
    }
    free(answer);
}
