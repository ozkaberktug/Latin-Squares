#ifndef FRAMEWORK_H
#define FRAMEWORK_H

#include <stdio.h>
#include <stdlib.h>

typedef struct STRUCT_THREAD_PARAM
{
    int startVal;
    int n;
} THREAD_PARAM;

int test_function(int *, int);
void init(FILE *);

#endif