#include <arm_neon.h>

int main()
{
    static int32_t IN;
    static int16_t OUT;
    OUT = vqmovns_s32(IN);
    return 0;
}

