/*
 * Copyright (c) 2004 by the cairo  perl team (see the file README)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include <cairo-perl.h>

MODULE = Cairo::Pattern	PACKAGE = Cairo::Pattern PREFIX = cairo_pattern_

cairo_pattern_t * cairo_pattern_create_for_surface (cairo_surface_t * surface);
    ALIAS:
	Cairo::Pattern::new = 1
    CLEANUP:
	CAIRO_PERL_UNUSED (ix);

cairo_pattern_t * cairo_pattern_create_linear (class, double x0, double y0, double x1, double y1);
    C_ARGS:
	x0, y0, x1, y1

cairo_pattern_t * cairo_pattern_create_radial (class, double cx0, double cy0, double radius0, double cx1, double cy1, double radius1);
    C_ARGS:
	cx0, cy0, radius0, cx1, cy1, radius1

## shouldn't have to deal with references from perl
##void cairo_pattern_reference (cairo_pattern_t * pattern);

## destroy should happen auto-magically
void cairo_pattern_DESTROY (cairo_pattern_t * pattern);
    CODE:
	cairo_pattern_destroy (pattern);
  
cairo_status_t cairo_pattern_add_color_stop (cairo_pattern_t * pattern, double offset, double red, double green, double blue, double alpha);
  
cairo_status_t cairo_pattern_set_matrix (cairo_pattern_t * pattern, cairo_matrix_t * matrix);

cairo_status_t cairo_pattern_get_matrix (cairo_pattern_t * pattern, cairo_matrix_t * matrix);

cairo_status_t cairo_pattern_set_extend (cairo_pattern_t * pattern, cairo_extend_t extend);

cairo_extend_t cairo_pattern_get_extend (cairo_pattern_t * pattern);

cairo_status_t cairo_pattern_set_filter (cairo_pattern_t * pattern, cairo_filter_t filter);

cairo_filter_t cairo_pattern_get_filter (cairo_pattern_t * pattern);

