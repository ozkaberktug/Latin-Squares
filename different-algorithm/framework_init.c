#include "framework.h"

long int count = 0;

void framework_init(int n)
{
    // first create all two-by-two squares
    int m = 0;
    int *alphabet = generate_alphabet(n, &m);

    // run backtrace
    int *answer = (int *)calloc(n * n, sizeof(int));
    CHECK_NULL(answer);
    createLatinSquares(alphabet, answer, n, m);

    //print result
    printf("sizeof alhabet: %d\nIterations: %ld\n", m, count);
    print_matrix(answer, n);

    free(alphabet);
    free(answer);
}