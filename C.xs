#include "EXTERN.h"
#include "perl.h"
#include "ppport.h"
#include "XSUB.h"

#include <unistd.h>


MODULE = Env::C		PACKAGE = Env::C  PREFIX = env_c_

char *
env_c_getenv(key)
    char *key

    CODE:
    RETVAL = getenv(key);

    OUTPUT:
    RETVAL
  

MODULE = Env::C		PACKAGE = Env::C  PREFIX = env_c_

void
env_c_setenv(key, val, override=1)
    char *key
    char *val
    int override

    CODE:
    setenv(key, val, override);

MODULE = Env::C		PACKAGE = Env::C  PREFIX = env_c_

void
env_c_unsetenv(key)
    char *key

    CODE:
    unsetenv(key);

MODULE = Env::C		PACKAGE = Env::C  PREFIX = env_c_

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
    RETVAL = Perl_newAV(aTHX);

    do {
        Perl_av_push(aTHX_ RETVAL, newSVpv((char*)environ[i++], 0));
    } while ((char*)environ[i] != '\0');


    OUTPUT:
    RETVAL




    


    
