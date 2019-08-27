#include <immintrin.h>
#include <time.h>

int main()
{
    __m256 mtest;
    mtest = _mm256_set1_ps((float)time(NULL));
    mtest = _mm256_addsub_ps(mtest, mtest);
    return _mm_cvtss_si32(_mm256_extractf128_ps(mtest, 0));
}

