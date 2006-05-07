/*
 * Copyright (c) 2004-2005 by the cairo perl team (see the file README)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 *
 */

#ifndef _CAIRO_PERL_PRIVATE_H_
#define _CAIRO_PERL_PRIVATE_H_

#define CAIRO_PERL_UNUSED(var) if (0) { (var) = (var); }

cairo_matrix_t * pcairo_copy_matrix (cairo_matrix_t *matrix);

#endif /* _CAIRO_PERL_PRIVATE_H_ */
