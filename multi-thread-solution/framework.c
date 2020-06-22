#include <time.h>
#include <pthread.h>
#include "framework.h"

int totalLatinSquares = 0;
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

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
    int r, c;
    int retVal = getNextEmptyLocation(matrix, n, &r, &c);
    if (retVal == 1)
    {
        //pthread_mutex_lock(&mutex);
        totalLatinSquares++;
        //pthread_mutex_unlock(&mutex);
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

void *threadRunner(void *_param)
{
    THREAD_PARAM param = *(THREAD_PARAM *)_param;

    int *matrix = (int *)malloc(sizeof(int) * param.n * param.n);

    if (matrix == NULL)
    {
        fprintf(stderr, "Could not allocate memory.\n");
        pthread_exit(NULL);
    }

    for (int i = 0; i < param.n * param.n; i++)
    {
        matrix[i] = 0;
    }
    matrix[0] = param.startVal;

    createLatinSquare(matrix, param.n);

    free(matrix);
}

void init(FILE *inputFile)
{
    int n;

    puts("Setting environment...");

    fscanf(inputFile, "%d", &n);

    puts("Firing threads...");
/*    clock_t start, end;
    double cpu_time_used;
    start = clock();*/

    pthread_t threads[n];
    for (int i = 0; i < n; i++)
    {
        THREAD_PARAM param = {i, n};
        int rc = pthread_create(&threads[i], NULL, threadRunner, (void *)&param);
        if (rc)
        {
            printf("Error:unable to create thread, %d\n", rc);
            exit(EXIT_FAILURE);
        }
    }
    puts("WAITING FOR THREADS...");
    for (int i = 0; i < n; i++)
    {
        pthread_join(threads[i], NULL);
    }

/*    end = clock();
    cpu_time_used = ((double)(end - start)) / CLOCKS_PER_SEC;
    puts("------------------------");
    printf("%d latin squares created.\n", totalLatinSquares);
    printf("This process took %lf seconds to finish.\n", cpu_time_used);*/
}
