#include <xmmintrin.h>
#include <time.h>

int main()
{
    __m128i mtest;
    mtest = _mm_set1_epi32((int)time(NULL));
    mtest = _mm_mul_epu32(mtest, mtest);
    return _mm_cvtsi128_si32(mtest);
}
