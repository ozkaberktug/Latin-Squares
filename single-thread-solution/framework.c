#include <time.h>
#include "framework.h"

int counter= 0;

int getNextEmptyLocation(int *matrix, int n, int *loc_row, int *loc_col)
{
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < n; j++)
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

int isOK(int *matrix, int n, int r, int c, int val)
{
    for (int i = 0; i < n; i++)
    {
        if (matrix[r * n + i] == val)
            return 0;
        if (matrix[i * n + c] == val)
            return 0;
    }
    return 1;
}

void createLatinSquare(int *matrix, int n)
{
    counter++;
    int r, c;
    int retVal = getNextEmptyLocation(matrix, n, &r, &c);
    if (retVal == 1)
    {
        test_function(matrix, n);
        return;
    }
    for (int x = 1; x <= n; x++)
    {
        if (isOK(matrix, n, r, c, x))
        {
            matrix[r * n + c] = x;
            createLatinSquare(matrix, n);
            matrix[r * n + c] = 0;
        }
    }
}

/*void createLatinSquareIterative(int *matrix, int n)
{
    // create a stack
    u_int32_t *ss = (u_int32_t *)malloc(1024 * 128 * sizeof(u_int32_t));
    u_int32_t sp = 0;

    int x, r, c, retVal;

    // "call" main function
    for (;;)
    {
        start:
        retVal = getNextEmptyLocation(matrix, n, &r, &c);
        if (retVal == 1)
        {
            // call test_function
            // TODO
            
            // popup variables in reverse order
            c = ss[--sp];
            r = ss[--sp];
            x = ss[--sp];

            if(sp == 0) 
                break;

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
                // jump to the code
                goto start;
                resume:
                matrix[r * n + c] = 0;
            }
        }
    }
}*/

void init(FILE *inputFile)
{
    int n;
    int *matrix = NULL;

    puts("Setting environment...");

    fscanf(inputFile, "%d", &n);
    matrix = (int *)malloc(sizeof(int) * n * n);

    if (matrix == NULL)
    {
        fprintf(stderr, "Could not allocate memory.\n");
        exit(EXIT_FAILURE);
    }

    for (int i = 0; i < n * n; i++)
    {
        matrix[i] = 0;
    }

    puts("Starting calculation...");
    /*clock_t start, end;
    double cpu_time_used;
    start = clock();*/
    createLatinSquare(matrix, n);
    printf("Iterations: %d\n", counter);

    /*end = clock();
    cpu_time_used = ((double)(end - start)) / CLOCKS_PER_SEC;
    puts("------------------------");
    printf("%d latin squares created.\n", totalLatinSquares);
    printf("This process took %lf seconds to finish.\n", cpu_time_used);*/

    free(matrix);
}
