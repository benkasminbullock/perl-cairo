/*
 * Copyright (c) 2004 by the cairo  perl team (see the file README)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 *
 */

#ifndef _CAIRO_PERL_H_
#define _CAIRO_PERL_H_

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <stdio.h>
#include <cairo.h>

#define CAIRO_PERL_UNUSED(var) if (0) { (var) = (var); }

/* XXX: copied/borrowed from gtk2-perl */
void _cairo_perl_call_XS (pTHX_ void (*subaddr) (pTHX_ CV *), CV * cv, SV ** mark);
/* XXX: copied/borrowed from gtk2-perl
 *
 * call the boot code of a module by symbol rather than by name.
 *
 * in a perl extension which uses several xs files but only one pm, you
 * need to bootstrap the other xs files in order to get their functions
 * exported to perl.  if the file has MODULE = Foo::Bar, the boot symbol
 * would be boot_Foo__Bar.
 */

#define CAIRO_PERL_CALL_BOOT(name)				\
	{							\
		extern XS(name);				\
		_cairo_perl_call_XS (aTHX_ name, cv, mark);	\
	}

#include <cairo-perl-enums.h>


#ifdef CAIRO_DEBUG
# define DBG(format, args...)	fprintf (stderr, format , ## args)
#else
# define DBG
#endif

/* XXX: both of these need extensive testing */

#define DOUBLES_DECLARE	\
	int i, n; double * pts;
#define DOUBLES_SLURP_FROM_STACK(first)				\
	n = (items - first);					\
	pts = (double*)malloc (sizeof (double) * n);		\
	if (!pts)						\
		croak ("malloc failure for (%d) elements", n);	\
	for (i = first ; i < items ; i++) {			\
		pts[i-first] = SvIV (ST (i));			\
	}
#define DOUBLES_LEN	n
#define DOUBLES_ARRAY	pts
#define DOUBLES_CLEANUP	\
	free (pts);

#endif /* _CAIRO_PERL_G_ */
