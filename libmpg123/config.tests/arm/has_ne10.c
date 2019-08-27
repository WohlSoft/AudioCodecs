#include <NE10_dsp.h>

int main()
{
    ne10_fft_cfg_float32_t cfg;
    cfg = ne10_fft_alloc_c2c_float32_neon(480);
    return 0;
}

