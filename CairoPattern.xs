/*
 * Copyright (c) 2004-2005 by the cairo perl team (see the file README)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include <cairo-perl.h>
#include <cairo-perl-private.h>

static const char *
get_package (cairo_pattern_t *pattern)
{
	cairo_pattern_type_t type;
	const char *package;

	type = cairo_pattern_get_type (pattern);
	switch (type) {
	    case CAIRO_PATTERN_TYPE_SOLID:
		package = "Cairo::SolidPattern";
		break;

	    case CAIRO_PATTERN_TYPE_SURFACE:
		package = "Cairo::SurfacePattern";
		break;

	    case CAIRO_PATTERN_TYPE_LINEAR:
		package = "Cairo::LinearGradient";
		break;

	    case CAIRO_PATTERN_TYPE_RADIAL:
		package = "Cairo::RadialGradient";
		break;

	    default:
		warn ("unknown pattern type %d encountered", type);
		package = "Cairo::Pattern";
		break;
	}

	return package;
}

SV *
cairo_pattern_to_sv (cairo_pattern_t *pattern)
{
	SV *sv = newSV (0);
	sv_setref_pv(sv, get_package (pattern), pattern);
	return sv;
}

MODULE = Cairo::Pattern	PACKAGE = Cairo::Pattern PREFIX = cairo_pattern_

void DESTROY (cairo_pattern_t * pattern);
    CODE:
	cairo_pattern_destroy (pattern);

void cairo_pattern_set_matrix (cairo_pattern_t * pattern, cairo_matrix_t * matrix);

## void cairo_pattern_get_matrix (cairo_pattern_t * pattern, cairo_matrix_t * matrix);
cairo_matrix_t * cairo_pattern_get_matrix (cairo_pattern_t * pattern);
    PREINIT:
	cairo_matrix_t matrix;
    CODE:
	cairo_pattern_get_matrix (pattern, &matrix);
	RETVAL = cairo_perl_copy_matrix (&matrix);
    OUTPUT:
	RETVAL

cairo_status_t cairo_pattern_status (cairo_pattern_t *pattern);

cairo_pattern_type_t cairo_pattern_get_type (cairo_pattern_t *pattern);

# --------------------------------------------------------------------------- #

MODULE = Cairo::Pattern	PACKAGE = Cairo::SolidPattern	PREFIX = cairo_pattern_

# cairo_pattern_t* cairo_pattern_create_rgb (double red, double green, double blue);
cairo_pattern_t_noinc * cairo_pattern_create_rgb (class, double red, double green, double blue)
    C_ARGS:
	red, green, blue

# cairo_pattern_t* cairo_pattern_create_rgba (double red, double green, double blue, double alpha);
cairo_pattern_t_noinc * cairo_pattern_create_rgba (class, double red, double green, double blue, double alpha)
    C_ARGS:
	red, green, blue, alpha

# --------------------------------------------------------------------------- #

MODULE = Cairo::Pattern	PACKAGE = Cairo::SurfacePattern	PREFIX = cairo_pattern_

cairo_pattern_t_noinc * create (class, cairo_surface_t * surface);
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

cairo_pattern_t_noinc * create (class, double x0, double y0, double x1, double y1);
    CODE:
	RETVAL = cairo_pattern_create_linear (x0, y0, x1, y1);
    OUTPUT:
	RETVAL

# --------------------------------------------------------------------------- #

MODULE = Cairo::Pattern	PACKAGE = Cairo::RadialGradient	PREFIX = cairo_pattern_

cairo_pattern_t_noinc * create (class, double cx0, double cy0, double radius0, double cx1, double cy1, double radius1);
    CODE:
	RETVAL = cairo_pattern_create_radial (cx0, cy0, radius0, cx1, cy1, radius1);
    OUTPUT:
	RETVAL
