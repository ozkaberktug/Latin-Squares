#include "framework.h"

int main(int argc, char **argv)
{
    if (argc != 2)
    {
        fprintf(stderr, "Parameter not specified.\n");
        return EXIT_FAILURE;
    }

    int n;
    sscanf(argv[1], "%d", &n);

    if (!(n == 4 || n == 6))
    {
        fprintf(stderr, "Unsupported format.\n");
        return EXIT_FAILURE;
    }

    framework_init(n);

    return EXIT_SUCCESS;
}