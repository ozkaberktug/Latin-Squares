#include "framework.h"

int *generate_alphabet(int limit, int *sizeAlphabet)
{
    int *alphabet = (int *)malloc(sizeof(int) * limit * limit * limit * limit * 4);
    CHECK_NULL(alphabet)
    int i = 0;
    for (size_t j = 1; j <= limit; j++)
    {
        for (size_t k = 1; k <= limit; k++)
        {
            for (size_t l = 1; l <= limit; l++)
            {
                for (size_t m = 1; m <= limit; m++)
                {
                    if (j == k || j == l || m == k || m == l)
                        continue;
                    alphabet[i * 4 + 0] = j;
                    alphabet[i * 4 + 1] = k;
                    alphabet[i * 4 + 2] = l;
                    alphabet[i * 4 + 3] = m;
                    i++;
                }
            }
        }
    }
    *sizeAlphabet = i;

    return alphabet;
}

void print_alphabet(int *alphabet, int limit)
{
    for (size_t i = 0; i < limit * limit * limit * limit; i++)
    {
        for (size_t j = 0; j < 2; j++)
        {
            for (size_t k = 0; k < 2; k++)
            {
                printf("%d", alphabet[i * 4 + j * 2 + k]);
            }
            putchar('\n');
        }
        putchar('\n');
    }
}

void print_matrix(int *matrix, int n)
{
    for (size_t i = 0; i < n; i++)
    {
        for (size_t j = 0; j < n; j++)
        {
            printf("%d", matrix[i * n + j]);
        }
        putchar('\n');
    }
}