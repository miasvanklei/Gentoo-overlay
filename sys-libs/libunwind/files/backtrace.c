#include <sys/types.h>
#include <stdio.h>

#include <execinfo.h>

struct _Unwind_Context;
typedef void *_Unwind_Ptr;

typedef enum {
  _URC_NO_REASON = 0,
  _URC_OK = 0,
  _URC_FOREIGN_EXCEPTION_CAUGHT = 1,
  _URC_FATAL_PHASE2_ERROR = 2,
  _URC_FATAL_PHASE1_ERROR = 3,
  _URC_NORMAL_STOP = 4,
  _URC_END_OF_STACK = 5,
  _URC_HANDLER_FOUND = 6,
  _URC_INSTALL_CONTEXT = 7,
  _URC_CONTINUE_UNWIND = 8,
} _Unwind_Reason_Code;

typedef _Unwind_Reason_Code (*_Unwind_Trace_Fn)(struct _Unwind_Context *, void *);

_Unwind_Ptr _Unwind_GetIP(struct _Unwind_Context *context);
_Unwind_Reason_Code _Unwind_Backtrace(_Unwind_Trace_Fn, void *);

struct tracer_context {
        void **arr;
        size_t len;
        size_t n;
};

static _Unwind_Reason_Code
tracer(struct _Unwind_Context *ctx, void *arg)
{
        struct tracer_context *t = arg;
        if (t->n == (size_t)~0) {
                /* Skip backtrace frame */
                t->n = 0;
                return 0;
        }
        if (t->n < t->len)
                t->arr[t->n++] = _Unwind_GetIP(ctx);
        return 0;
}

size_t backtrace(void **buffer, size_t size)
{
        struct tracer_context ctx;

        ctx.arr = buffer;
        ctx.len = size;
        ctx.n = (size_t)~0;

        _Unwind_Backtrace(tracer, &ctx);
        if (ctx.n != (size_t)~0 && ctx.n > 0)
                ctx.arr[--ctx.n] = NULL;        /* Skip frame below __start */

	return ctx.n != -1 ? ctx.n : 0;
}

