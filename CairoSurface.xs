/*
 * Copyright (c) 2004 by the cairo  perl team (see the file README)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include <cairo-perl.h>

/*
 * TODO:
 *	- the names are bad on these, should be cairo_surface_image_create etc.
 *	  don't want to put them in these pkgs, going to have to mangle somehow.
 */

MODULE = Cairo::Surface	PACKAGE = Cairo::Surface PREFIX = cairo_surface_

cairo_surface_t * image_create (class, cairo_format_t format, int width, int height)
    CODE:
	RETVAL = cairo_image_surface_create (format, width, height);
    OUTPUT:
	RETVAL

cairo_surface_t * image_create_for_data (class, char * data, cairo_format_t format, int width, int height, int stride);
    CODE:
	RETVAL = cairo_image_surface_create_for_data (data, format, width,
						      height, stride);
    OUTPUT:
	RETVAL

## XXX: duplicates the above, no need to bind
##cairo_surface_t * cairo_surface_create_for_image (class, char * data, cairo_format_t format, int width, int height, int stride);

#ifdef CAIRO_HAS_PS_SURFACE

cairo_surface_t * ps_create (class, FILE * file, double width_inches, double height_inches, double x_pixels_per_inch, double y_pixels_per_inch);
   CODE:
	RETVAL = cairo_ps_surface_create (file, width_inches, height_inches,
					  x_pixels_per_inch, y_pixels_per_inch);
    OUTPUT:
	RETVAL

#endif /* CAIRO_HAS_PS_SURFACE */

#ifdef CAIRO_HAS_PNG_SURFACE

cairo_surface_t * png_create (class, FILE * file, cairo_format_t format, int width, int height);
    CODE:
	RETVAL = cairo_png_surface_create (file, format, width, height);
    OUTPUT:
	RETVAL

#endif /* CAIRO_HAS_PNG_SURFACE */

#ifdef CAIRO_HAS_XLIB_SURFACE

## XXX: Display, Drawable ...
cairo_surface_t * xlib_create (class, Display * dpy, Drawable drawable, Visual * visual, cairo_format_t format, Colormap colormap);
    CODE:
	RETVAL = cairo_xlib_surface_create (dpy, drawable, visual, format, colormap);
    OUTPUT:
	RETVAL

#endif /* CAIRO_HAS_XLIB_SURFACE */

#ifdef CAIRO_HAS_GLITZ_SURFACE

## XXX: glitz_surface_t
cairo_surface_t * glitz_create (class, glitz_surface_t * surface);
    CODE:
	RETVAL = cairo_glitz_surface_create (surface);
    OUTPUT:
	RETVAL

#endif /* CAIRO_HAS_GLITZ_SURFACE */

## shouldn't have to deal with references from perl
##void cairo_surface_reference (cairo_surface_t * surface);

## destroy should happen auto-magically
## void cairo_surface_destroy (cairo_surface_t * surface);
void cairo_surface_DESTROY (cairo_surface_t * surface);
    CODE:
	cairo_surface_destroy (surface);

cairo_surface_t * cairo_surface_create_similar (cairo_surface_t * other, cairo_format_t format, int width, int height);

void cairo_surface_destroy (cairo_surface_t * surface);

cairo_status_t cairo_surface_set_repeat (cairo_surface_t * surface, int repeat);

cairo_status_t cairo_surface_set_matrix (cairo_surface_t * surface, cairo_matrix_t * matrix);

## XXX: status return type?
## cairo_status_t cairo_surface_get_matrix (cairo_surface_t * surface, cairo_matrix_t * matrix);
cairo_matrix_t * cairo_surface_get_matrix (cairo_surface_t * surface);
    CODE:
	RETVAL = cairo_matrix_create ();
	cairo_surface_get_matrix (surface, RETVAL);
    OUTPUT:
	RETVAL

cairo_status_t cairo_surface_set_filter (cairo_surface_t * surface, cairo_filter_t filter);

cairo_filter_t cairo_surface_get_filter (cairo_surface_t * surface);

