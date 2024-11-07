#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <wchar.h>
#include <malloc.h>
#include <pthread.h>

int __register_atfork(void (*prepare) (void), void (*parent) (void), void (*child) (void), void * __dso_handle)
{
    return pthread_atfork(prepare, parent, child);
}

unsigned long long strtoull_l(const char *nptr, char **endptr, int base, locale_t locale)
{
    return strtoull(nptr, endptr, base);
}

long long strtoll_l(const char *nptr, char **endptr, int base, locale_t locale)
{
    return strtoll(nptr, endptr, base);
}

size_t __mbrlen(const char *__restrict s, size_t n, mbstate_t *__restrict ps)
{
    return mbrlen(s, n, ps);
}

void * __memcpy_chk(void * dest, const void * src, size_t len, size_t destlen)
{
    return memcpy(dest, src, len);
}

int __vsnprintf_chk(char * s, size_t maxlen, int flag, size_t slen, const char * format, va_list args)
{
    return vsnprintf(s, maxlen, format, args);
}

char * __strncat_chk(char * s1, const char * s2, size_t n, size_t s1len)
{
    return strncat(s1, s2, n);
}

extern unsigned long long __udivmodti4(unsigned long long a, unsigned long long b, unsigned long long rem);

unsigned long long __udivti3(unsigned long long a, unsigned long long b)
{
    return __udivmodti4(a, b, 0);
}

void *__libc_stack_end;
