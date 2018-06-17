#include <alloca.h>

int main()
{
    int foo=10;
    int *array = alloca(foo);
    return 0;
}

