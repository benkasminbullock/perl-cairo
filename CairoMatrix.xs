/*
 * Copyright (c) 2004-2005 by the cairo perl team (see the file README)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include <cairo-perl.h>

MODULE = Cairo::Matrix	PACKAGE = Cairo::Matrix PREFIX = cairo_matrix_

##void cairo_matrix_init (cairo_matrix_t *matrix, double xx, double yx, double xy, double yy, double x0, double y0);
cairo_matrix_t * cairo_matrix_init (class, double xx, double yx, double xy, double yy, double x0, double y0)
    CODE:
	RETVAL = malloc (sizeof (cairo_matrix_t));
	cairo_matrix_init (RETVAL, xx, yx, xy, yy, x0, y0);
    OUTPUT:
	RETVAL

##void cairo_matrix_init_identity (cairo_matrix_t *matrix);
cairo_matrix_t * cairo_matrix_init_identity (class)
    CODE:
	RETVAL = malloc (sizeof (cairo_matrix_t));
	cairo_matrix_init_identity (RETVAL);
    OUTPUT:
	RETVAL

##void cairo_matrix_init_translate (cairo_matrix_t *matrix, double tx, double ty);
cairo_matrix_t * cairo_matrix_init_translate (class, double tx, double ty)
    CODE:
	RETVAL = malloc (sizeof (cairo_matrix_t));
	cairo_matrix_init_translate (RETVAL, tx, ty);
    OUTPUT:
	RETVAL

##void cairo_matrix_init_scale (cairo_matrix_t *matrix, double sx, double sy);
cairo_matrix_t * cairo_matrix_init_scale (class, double sx, double sy)
    CODE:
	RETVAL = malloc (sizeof (cairo_matrix_t));
	cairo_matrix_init_scale (RETVAL, sx, sy);
    OUTPUT:
	RETVAL

##void cairo_matrix_init_rotate (cairo_matrix_t *matrix, double radians);
cairo_matrix_t * cairo_matrix_init_rotate (class, double radians)
    CODE:
	RETVAL = malloc (sizeof (cairo_matrix_t));
	cairo_matrix_init_rotate (RETVAL, radians);
    OUTPUT:
	RETVAL

void cairo_matrix_translate (cairo_matrix_t * matrix, double tx, double ty);

void cairo_matrix_scale (cairo_matrix_t * matrix, double sx, double sy);

void cairo_matrix_rotate (cairo_matrix_t * matrix, double radians);

cairo_status_t cairo_matrix_invert (cairo_matrix_t * matrix);

##void cairo_matrix_multiply (cairo_matrix_t * result, const cairo_matrix_t * a, const cairo_matrix_t * b);
cairo_matrix_t * cairo_matrix_multiply (cairo_matrix_t * a, cairo_matrix_t * b);
    CODE:
	RETVAL = malloc (sizeof (cairo_matrix_t));
	cairo_matrix_multiply (RETVAL, a, b);
    OUTPUT:
	RETVAL

##void cairo_matrix_transform_distance (cairo_matrix_t * matrix, double * dx, double * dy);
void cairo_matrix_transform_distance (cairo_matrix_t * matrix, IN_OUTLIST double dx, IN_OUTLIST double dy);

##void cairo_matrix_transform_point (cairo_matrix_t * matrix, double * x, double * y);
void cairo_matrix_transform_point (cairo_matrix_t * matrix, IN_OUTLIST double x, IN_OUTLIST double y);

void DESTROY (cairo_matrix_t * matrix)
    CODE:
	free (matrix);
