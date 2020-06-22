#include "framework.h"

int main(int argc, char **argv)
{

    if (argc != 2)
    {
        fprintf(stderr, "Parameter not specified.\n");
        return EXIT_FAILURE;
    }

    FILE *inputFile = fopen(argv[1], "r");
    if (inputFile == NULL)
    {
        fprintf(stderr, "%s: File could not open.\n", argv[1]);
        return EXIT_FAILURE;
    }

    init(inputFile);

    fclose(inputFile);

    return EXIT_SUCCESS;
}