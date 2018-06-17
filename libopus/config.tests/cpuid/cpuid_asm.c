#include <stdio.h>

int main()
{
    unsigned int CPUInfo0;
    unsigned int CPUInfo1;
    unsigned int CPUInfo2;
    unsigned int CPUInfo3;
    unsigned int InfoType;
    __asm__ __volatile__ (
    "cpuid":
    "=a" (CPUInfo0),
    "=b" (CPUInfo1),
    "=c" (CPUInfo2),
    "=d" (CPUInfo3) :
    "a" (InfoType), "c" (0)
    );
    return 0;
}
