#include "framework.h"

int getNextEmptyLocation(int *matrix, int n, int *loc_row, int *loc_col)
{
    for (int i = 0; i < n; i += 2)
    {
        for (int j = 0; j < n; j += 2)
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

int isOK(int *matrix, int n, int r, int c, int *alphabet, int index)
{
    for (int i = 0; i < n; i++)
    {
        // check top left cell
        if (matrix[r * n + i] == alphabet[index * 4 + 0])
            return 0;
        if (matrix[i * n + c] == alphabet[index * 4 + 0])
            return 0;
        // check top right cell
        if (matrix[r * n + i] == alphabet[index * 4 + 1])
            return 0;
        if (matrix[i * n + (c + 1)] == alphabet[index * 4 + 1])
            return 0;
        // check bottom left cell
        if (matrix[(r + 1) * n + i] == alphabet[index * 4 + 2])
            return 0;
        if (matrix[i * n + c] == alphabet[index * 4 + 2])
            return 0;
        // check bottom right cell
        if (matrix[(r + 1) * n + i] == alphabet[index * 4 + 3])
            return 0;
        if (matrix[i * n + (c + 1)] == alphabet[index * 4 + 3])
            return 0;
    }
    return 1;
}

void createLatinSquares(int *alphabet, int *matrix, int n, int m)
{
    count++;
    int r, c;
    int retVal = getNextEmptyLocation(matrix, n, &r, &c);
    if (retVal == 1)
    {
        test_function(matrix, n);
        return;
    }
    for (int i = 0; i < m; i++)
    {
        if (isOK(matrix, n, r, c, alphabet, i))
        {
            matrix[r * n + c] = alphabet[i * 4 + 0];
            matrix[r * n + (c + 1)] = alphabet[i * 4 + 1];
            matrix[(r + 1) * n + c] = alphabet[i * 4 + 2];
            matrix[(r + 1) * n + (c + 1)] = alphabet[i * 4 + 3];
            createLatinSquares(alphabet, matrix, n, m);
            matrix[r * n + c] = 0;
            matrix[r * n + (c + 1)] = 0;
            matrix[(r + 1) * n + c] = 0;
            matrix[(r + 1) * n + (c + 1)] = 0;
        }
    }
}