#include "framework.cuh"

int samples_isOK(short *matrix, int r, int c, int val)
{
    for (int i = 0; i < N; i++)
    {
        if (matrix[r * N + i] == val)
            return 0;
        if (matrix[i * N + c] == val)
            return 0;
    }
    return 1;
}
int samples_getEmptyLoc(short *matrix, int *loc_row, int *loc_col)
{
    int c = 0;
    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < N; j++)
        {
            if (matrix[i * N + j] == 0)
            {
                *loc_row = i;
                *loc_col = j;
                return 0;
            }
            else
            {
                c++;
                if (c >= SAMPLE_CELLS)
                    return 1;
            }
        }
    }
    return 1;
}
void samples_generate(short *pSamples, short *matrix, int *pSize)
{
    int r, c;
    int retVal = samples_getEmptyLoc(matrix, &r, &c);
    if (retVal == 1)
    {
        copy_matrix(&pSamples[(*pSize) * N * N], matrix, N);
        (*pSize)++;

        if (*pSize >= SAMPLE_MAX_LIMIT)
        {
            fprintf(stderr, "\nSAMPLE LIMIT reached! Choose lower values than %d!\n", SAMPLE_MAX_LIMIT);
            exit(EXIT_FAILURE);
        }

        return;
    }
    for (int x = 1; x <= N; x++)
    {
        if (samples_isOK(matrix, r, c, x))
        {
            matrix[r * N + c] = x;
            samples_generate(pSamples, matrix, pSize);
            matrix[r * N + c] = 0;
        }
    }
}

short* samples_init(int* nSize)
{
    *nSize = 0;
    short *pMatrix = (short *)calloc(N * N, sizeof(short));
    CHECK_NULL(pMatrix);
    short *pSamplesTmp = (short *)malloc(N * N * SAMPLE_MAX_LIMIT * sizeof(short));
    CHECK_NULL(pSamplesTmp);
    samples_generate(pSamplesTmp, pMatrix, nSize);
    free(pMatrix);

    // resize the container
    short *pSamples = (short *)malloc(N * N * (*nSize) * sizeof(short));
    CHECK_NULL(pSamples);
    for (size_t i = 0; i < N * N * (*nSize); i++)
        pSamples[i] = pSamplesTmp[i];
    free(pSamplesTmp);


    return pSamples;
}