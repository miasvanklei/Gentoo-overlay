#ifndef _EXECINFO_H_
#define _EXECINFO_H_

#ifdef __cplusplus
extern "C" {
#endif

#include <stddef.h>

size_t backtrace(void **, size_t);
char **backtrace_symbols(void *const *, size_t);
void backtrace_symbols_fd(void *const *, size_t, int);

#ifdef __cplusplus
}
#endif

#endif /* _EXECINFO_H_ */
