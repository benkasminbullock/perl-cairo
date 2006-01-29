/*
 * Copyright (c) 2004-2005 by the cairo perl team (see the file README)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include <cairo-perl.h>

MODULE = Cairo::Pattern	PACKAGE = Cairo::Pattern PREFIX = cairo_pattern_

void DESTROY (cairo_pattern_t * pattern);
    CODE:
	cairo_pattern_destroy (pattern);

void cairo_pattern_set_matrix (cairo_pattern_t * pattern, cairo_matrix_t * matrix);

## void cairo_pattern_get_matrix (cairo_pattern_t * pattern, cairo_matrix_t * matrix);
cairo_matrix_t * cairo_pattern_get_matrix (cairo_pattern_t * pattern);
    CODE:
	RETVAL = malloc (sizeof (cairo_matrix_t));
	cairo_pattern_get_matrix (pattern, RETVAL);
    OUTPUT:
	RETVAL

cairo_status_t cairo_pattern_status (cairo_pattern_t *pattern);

# --------------------------------------------------------------------------- #

MODULE = Cairo::Pattern	PACKAGE = Cairo::SolidPattern	PREFIX = cairo_pattern_

# cairo_pattern_t* cairo_pattern_create_rgb (double red, double green, double blue);
cairo_solid_pattern_t_noinc * cairo_pattern_create_rgb (class, double red, double green, double blue)
    C_ARGS:
	red, green, blue

# cairo_pattern_t* cairo_pattern_create_rgba (double red, double green, double blue, double alpha);
cairo_solid_pattern_t_noinc * cairo_pattern_create_rgba (class, double red, double green, double blue, double alpha)
    C_ARGS:
	red, green, blue, alpha

# --------------------------------------------------------------------------- #

MODULE = Cairo::Pattern	PACKAGE = Cairo::SurfacePattern	PREFIX = cairo_pattern_

cairo_surface_pattern_t_noinc * create (class, cairo_surface_t * surface);
    CODE:
	RETVAL = cairo_pattern_create_for_surface (surface);
    OUTPUT:
	RETVAL

void cairo_pattern_set_extend (cairo_pattern_t * pattern, cairo_extend_t extend);

cairo_extend_t cairo_pattern_get_extend (cairo_pattern_t * pattern);

void cairo_pattern_set_filter (cairo_pattern_t * pattern, cairo_filter_t filter);

cairo_filter_t cairo_pattern_get_filter (cairo_pattern_t * pattern);

# --------------------------------------------------------------------------- #

MODULE = Cairo::Pattern	PACKAGE = Cairo::Gradient	PREFIX = cairo_pattern_

void cairo_pattern_add_color_stop_rgb (cairo_pattern_t *pattern, double offset, double red, double green, double blue);

void cairo_pattern_add_color_stop_rgba (cairo_pattern_t *pattern, double offset, double red, double green, double blue, double alpha);

# --------------------------------------------------------------------------- #

MODULE = Cairo::Pattern	PACKAGE = Cairo::LinearGradient	PREFIX = cairo_pattern_

cairo_linear_gradient_t_noinc * create (class, double x0, double y0, double x1, double y1);
    CODE:
	RETVAL = cairo_pattern_create_linear (x0, y0, x1, y1);
    OUTPUT:
	RETVAL

# --------------------------------------------------------------------------- #

MODULE = Cairo::Pattern	PACKAGE = Cairo::RadialGradient	PREFIX = cairo_pattern_

cairo_radial_gradient_t_noinc * create (class, double cx0, double cy0, double radius0, double cx1, double cy1, double radius1);
    CODE:
	RETVAL = cairo_pattern_create_radial (cx0, cy0, radius0, cx1, cy1, radius1);
    OUTPUT:
	RETVAL
