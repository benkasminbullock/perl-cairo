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
