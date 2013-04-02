#include "EXTERN.h"
#include "perl.h"
#include "ppport.h"
#include "XSUB.h"

#include <stdlib.h> /* setenv/getenv */
#include <stdio.h>  /* sprintf */

/* configure-less detection of unsetenv for solaris */
#if defined(sun)
# if defined(__EXTENSIONS__) ||\
    (!defined(_STRICT_STDC) && !defined(__XOPEN_OR_POSIX)) || \
	    defined(_XPG6)
#  define HAVE_UNSETENV 1
#  define HAVE_SETENV 1
# endif
#endif

#ifndef HAVE_UNSETENV
# if !defined(sun) && !defined(_AIX)
#  define HAVE_UNSETENV 1
# endif
#endif
#ifndef HAVE_SETENV
# if !defined(WIN32) && !defined(sun)
#  define HAVE_SETENV 1
# endif
#endif

MODULE = Env::C        PACKAGE = Env::C  PREFIX = env_c_

char *
env_c_getenv(key)
    char *key

    CODE:
    RETVAL = getenv(key);

    OUTPUT:
    RETVAL

MODULE = Env::C        PACKAGE = Env::C  PREFIX = env_c_

int
env_c_setenv(key, val, override=1)
    char *key
    char *val
    int override;


    CODE:
#if !HAVE_SETENV
    if (override || getenv(key) == NULL) {
        char *old_env = getenv( key ); 
        char *buff = malloc(strlen(key) + strlen(val) + 2);
        if (buff != NULL) {
            sprintf(buff, "%s=%s", key, val);
#ifdef WIN32
            RETVAL = _putenv(buff);
            free(buff);
#else
            RETVAL = putenv(buff);
            if (old_env == NULL) {
                free(old_env);
            }
#endif
        }
        else {
            RETVAL = -1;
        }
    }
    else {
        RETVAL = -1;
    }
#else
    RETVAL = setenv(key, val, override);
#endif

    OUTPUT:
    RETVAL

MODULE = Env::C        PACKAGE = Env::C  PREFIX = env_c_

void
env_c_unsetenv(key)
    char *key

    PREINIT:
#ifdef WIN32
    char *buff;
#endif
#if defined( sun ) || defined( _AIX )
    int key_len;
    extern char **environ;
    char **envp;
#endif

    CODE:
#ifdef WIN32
    buff = malloc(strlen(key) + 2);
    sprintf(buff, "%s=", key);
    _putenv(buff);
    free(buff);
#else
#if HAVE_UNSETENV
    unsetenv(key);
#else
    key_len = strlen(key);
    for (envp = environ; *envp != NULL; envp++) {
        if (strncmp(key, *envp, key_len) == 0 &&
            (*envp)[key_len] == '=') {
            free(*envp);
            do {
                envp[0] = envp[1];
            } while (*envp++);
            break;
        }
    }
#endif
#endif

MODULE = Env::C        PACKAGE = Env::C  PREFIX = env_c_

AV*
env_c_getallenv()

    PREINIT:
    int i = 0;
    char *p;
    AV *av = Nullav;
#ifndef __BORLANDC__
    extern char **environ;
#endif

    CODE:
    RETVAL = newAV();

    while ((char*)environ[i] != '\0') {
        Perl_av_push(aTHX_ RETVAL, newSVpv((char*)environ[i++], 0));
    }

    OUTPUT:
    RETVAL

