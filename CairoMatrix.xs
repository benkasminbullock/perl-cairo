/*
 * Copyright (c) 2004 by the cairo  perl team (see the file README)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include <cairo-perl.h>

MODULE = Cairo::Matrix	PACKAGE = Cairo::Matrix PREFIX = cairo_matrix_

cairo_matrix_t * cairo_matrix_create (class);
    C_ARGS:
	/* void */

## destroy should happen auto-magically
##void cairo_matrix_destroy (cairo_matrix_t * matrix);
void cairo_matrix_DESTROY (cairo_matrix_t * matrix);
    CODE:
	cairo_matrix_destroy (matrix);

## XXX: status return type?
## XXX: cairo_status_t cairo_matrix_copy (cairo_matrix_t * matrix, const cairo_matrix_t * other);
cairo_matrix_t * cairo_matrix_copy (cairo_matrix_t * matrix);
    CODE:
	RETVAL = cairo_matrix_create ();
	cairo_matrix_copy (matrix, RETVAL);
    OUTPUT:
	RETVAL

cairo_status_t cairo_matrix_set_identity (cairo_matrix_t * matrix);

cairo_status_t cairo_matrix_set_affine (cairo_matrix_t * cr, double a, double b, double c, double d, double tx, double ty);

## XXX: status return type?
##cairo_status_t cairo_matrix_get_affine (cairo_matrix_t * matrix, double * a, double * b, double * c, double * d, double * tx, double * ty);
void cairo_matrix_get_affine (cairo_matrix_t * matrix, OUTLIST double a, OUTLIST double b, OUTLIST double c, OUTLIST double d, OUTLIST double tx, OUTLIST double ty);

cairo_status_t cairo_matrix_translate (cairo_matrix_t * matrix, double tx, double ty);

cairo_status_t cairo_matrix_scale (cairo_matrix_t * matrix, double sx, double sy);

cairo_status_t cairo_matrix_rotate (cairo_matrix_t * matrix, double radians);

cairo_status_t cairo_matrix_invert (cairo_matrix_t * matrix);

## XXX: status return type?
##cairo_status_t cairo_matrix_multiply (cairo_matrix_t * result, cairo_matrix_t * a, const cairo_matrix_t * b);
cairo_matrix_t * cairo_matrix_multiply (cairo_matrix_t * a, cairo_matrix_t * b);
    CODE:
	RETVAL = cairo_matrix_create ();
	cairo_matrix_multiply (RETVAL, a, b);
    OUTPUT:
	RETVAL

## XXX: status return type?
##cairo_status_t cairo_matrix_transform_distance (cairo_matrix_t * matrix, double * dx, double * dy);
void cairo_matrix_transform_distance (cairo_matrix_t * matrix, IN_OUTLIST double dx, IN_OUTLIST double dy);

## XXX: status return type?
##cairo_status_t cairo_matrix_transform_point (cairo_matrix_t * matrix, double * x, double * y);
void cairo_matrix_transform_point (cairo_matrix_t * matrix, IN_OUTLIST double x, IN_OUTLIST double y);
