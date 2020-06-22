#include "framework.cuh"

void init()
{
    short *answer_dev = NULL;
    short *pSamples_dev = NULL;
    int *nSize_dev = NULL;
    int *ss = NULL;
    short *answer = NULL;
    int nSize = 0;
    short *pSamples = NULL;
    size_t ss_size;
    size_t sample_size;
    /*size_t prevLimitStack = 0;
    size_t prevLimitHeap = 0;
    size_t newLimitHeap = 0;*/
    cudaError_t err;
    int i, j;

    printf("Generating samples...");
    pSamples = samples_init(&nSize);
    printf("%d samples created.\n", nSize);

    /*
    puts("Configuring device limits...");
    cudaDeviceGetLimit(&prevLimitStack, cudaLimitStackSize);
    printf("    Current stack limit is %lu\n", prevLimitStack);
    cudaDeviceGetLimit(&prevLimitHeap, cudaLimitMallocHeapSize);
    printf("    Previous heap limit was %lu\n", prevLimitHeap);
    if (prevLimitHeap >= DEVICE_HEAP_LIMIT)
    {
        puts("Heap limit is big enough, did not change anything.");
    }
    else
    {
        printf("Setting device limit to %lu\n", DEVICE_HEAP_LIMIT);
        err = cudaDeviceSetLimit(cudaLimitMallocHeapSize, DEVICE_HEAP_LIMIT);
        CHECK_CUDA(err);
        cudaDeviceGetLimit(&newLimitHeap, cudaLimitMallocHeapSize);
        printf("    Current heap limit is %lu\n", newLimitHeap);
    }
*/
    puts("Allocating Device Memory...");
    ss_size = nSize * STACK_FRAME_SIZE * sizeof(int);
    sample_size = N * N * nSize * sizeof(short);
    printf("Total memory required: %lu B\n", sizeof(int) + ss_size + sample_size + N * N * sizeof(short));
    cudaMalloc((void **)&ss, ss_size);
    cudaMalloc((void **)&nSize_dev, sizeof(int));
    cudaMalloc((void **)&pSamples_dev, sample_size);
    cudaMalloc((void **)&answer_dev, N * N * sizeof(short));
    cudaMemcpy(pSamples_dev, pSamples, sample_size, cudaMemcpyHostToDevice);
    cudaMemcpy(nSize_dev, &nSize, sizeof(int), cudaMemcpyHostToDevice);
    free(pSamples);
    err = cudaGetLastError();
    CHECK_CUDA(err);

    puts("Kernel booting...");
    /*cudaStream_t streams[16];
    const int streamLen = 16;
    for (int i = 0; i < streamLen; i++)
    {
        cudaStreamCreate(&streams[i]);
        bootKernel<<<1, 1, 0, streams[i]>>>(answer_dev, &pSamples_dev[i * N * N], nSize_dev, &ss[i * STACK_FRAME_SIZE]);
    }*/
    bootKernel<<<512, 256>>>(answer_dev, pSamples_dev, nSize_dev, ss);
    err = cudaDeviceSynchronize();
    CHECK_CUDA(err);

    puts("Finalizing...");
    answer = (short *)calloc(N * N, sizeof(short));
    CHECK_NULL(answer);
    cudaMemcpy(answer, answer_dev, sizeof(short) * N * N, cudaMemcpyDeviceToHost);
    cudaFree(answer_dev);
    cudaFree(pSamples_dev);
    cudaFree(nSize_dev);
    cudaFree(ss);
    cudaDeviceReset();
    err = cudaGetLastError();
    CHECK_CUDA(err);

    puts("Computation done.\n");
    for (i = 0; i < N; i++)
    {
        for (j = 0; j < N; j++)
        {
            printf("%d ", answer[i * N + j]);
        }
        putchar('\n');
    }
    free(answer);
}
