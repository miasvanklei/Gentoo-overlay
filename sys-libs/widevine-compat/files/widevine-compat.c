#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <wchar.h>
#include <malloc.h>
#include <pthread.h>
#include <setjmp.h>
#include <fcntl.h>
#include <stdarg.h>

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

char * __strdup(const char * s)
{
    return strdup(s);
}

int __open64_2(const char *path, int oflag)
{
    return open(path, oflag);
}

int __vfprintf_chk(FILE *stream, int flag, const char *format, va_list ap)
{
    return vfprintf(stream, format, ap);
}

int __vasprintf_chk(char **strp, int flag, const char *format, va_list ap)
{
    return vasprintf(strp, format, ap);
}

char *__fgets_chk(char *s, size_t slen, int n, FILE *stream)
{
    return fgets(s, n, stream);
}

void __longjmp_chk(jmp_buf env, int val)
{
    return longjmp(env, val);
}

void *__memset_chk(void *s, int c, size_t n, size_t buflen)
{
	return memset(s, c, n);
}

int fcntl64(int fd, int cmd, ...) {
	int ret;
	va_list va;

	va_start(va, cmd);
	ret = fcntl(fd, cmd, va);
	va_end(va);

	return ret;
}

void *__libc_stack_end;
