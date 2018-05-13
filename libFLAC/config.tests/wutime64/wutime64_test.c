#include <sys/utime.h>

int main()
{
	wchar_t *wname = L"dummy.txt";
	struct __utimbuf64 ut;
	ut.actime = 0;
	ut.modtime = 0;
	return _wutime64(wname, &ut);
}
