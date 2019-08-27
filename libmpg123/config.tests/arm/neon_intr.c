#include <arm_neon.h>

int main()
{
    static float32x4_t A0, A1, SUMM;
    SUMM = vmlaq_f32(SUMM, A0, A1);
    return (int)vgetq_lane_f32(SUMM, 0);
}

