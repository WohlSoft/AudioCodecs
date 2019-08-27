#include <xmmintrin.h>
#include <time.h>

int main()
{
    __m128 mtest;
    mtest = _mm_set1_ps((float)time(NULL));
    mtest = _mm_mul_ps(mtest, mtest);
    return _mm_cvtss_si32(mtest);
}
