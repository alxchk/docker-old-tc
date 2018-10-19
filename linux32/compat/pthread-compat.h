#ifndef __pthread_condattr_setclock__ 
#define __pthread_condattr_setclock__ 
#define _GNU_SOURCE
#include <dlfcn.h>

#ifndef RTLD_NEXT
#define RTLD_NEXT ((void *) -1l)
#endif

static int (*_pthread_condattr_setclock) (pthread_condattr_t *attr, clockid_t clock_id) = NULL;

static inline
int pthread_condattr_setclock(pthread_condattr_t *attr, clockid_t clock_id) {
    if (_pthread_condattr_setclock == -1) return -1;
    if (_pthread_condattr_setclock == NULL) _pthread_condattr_setclock = dlsym(
       RTLD_NEXT, "pthread_condattr_setclock");
    if (_pthread_condattr_setclock == NULL) {
        _pthread_condattr_setclock = -1;
        return -1;
    }

    return _pthread_condattr_setclock(attr, clock_id);
}
#endif
