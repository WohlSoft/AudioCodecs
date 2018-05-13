#ifdef _WIN32
#undef  NO_OLDNAMES
#undef _NO_OLDNAMES
#endif

#include <io.h>
#include <sys/utime.h>
#include <stdio.h>
#include <sys/stat.h>
#include <sys/utime.h>
#include <windows.h>

int main()
{
	wchar_t *wname = L"dummy.txt";
	struct __utimbuf64 ut;
	ut.actime = 0;
	ut.modtime = 0;
	return _wutime64(wname, &ut);
}
