#include "framework.cuh"

int main(int argc, char **argv)
{

    if (argc != 2)
    {
        fprintf(stderr, "Parameter not specified.\n");
        return EXIT_FAILURE;
    }

    int n;
    sscanf(argv[1], "%d", &n);

    init(n);

    return EXIT_SUCCESS;
}