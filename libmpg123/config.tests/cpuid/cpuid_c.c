#include <cpuid.h>

int main()
{
    unsigned int CPUInfo0;
    unsigned int CPUInfo1;
    unsigned int CPUInfo2;
    unsigned int CPUInfo3;
    unsigned int InfoType;
    __get_cpuid(InfoType, &CPUInfo0, &CPUInfo1, &CPUInfo2, &CPUInfo3);
    return 0;
}
