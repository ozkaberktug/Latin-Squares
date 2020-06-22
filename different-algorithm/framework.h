#ifndef FRAMEWORK_H
#define FRAMEWORK_H

#include <stdio.h>
#include <stdlib.h>

#define CHECK_NULL(x)                                                            \
    if (x == NULL)                                                               \
    {                                                                            \
        fprintf(stderr, "%s:%d - Null pointer exception\n", __FILE__, __LINE__); \
        exit(EXIT_FAILURE);                                                      \
    }

/* utility functions */
void print_alphabet(int *alphabet, int limit);
int *generate_alphabet(int limit, int* sizeAlphabet);
void print_matrix(int *matrix, int n);

/* computation */
void framework_init(int n);
void createLatinSquares(int *alphabet, int *matrix, int n, int m);
int test_function(int *matrix, int n);

/* iteration count */
extern long int count;


#endif