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

MODULE = Cairo::Surface	PACKAGE = Cairo::ImageSurface	PREFIX = cairo_image_surface_

cairo_surface_t * cairo_image_surface_create (class, cairo_format_t format, int width, int height)
    ALIAS:
	Cairo::Surface::new = 1
    C_ARGS:
	format, width, height
    CLEANUP:
	CAIRO_PERL_UNUSED (ix);

MODULE = Cairo::Surface	PACKAGE = Cairo::Surface PREFIX = cairo_surface_

## destroy should happen auto-magically
## void cairo_surface_destroy (cairo_surface_t * surface);
void cairo_surface_DESTROY (cairo_surface_t * surface);
    CODE:
	cairo_surface_destroy (surface);

## XXX: this one is kinda odd, image data is the first param
cairo_surface_t * cairo_surface_create_for_image (class, char * data, cairo_format_t format, int width, int height, int stride);
    C_ARGS:
	data, format, width, height, stride

cairo_surface_t * cairo_surface_create_similar (cairo_surface_t * other, cairo_format_t format, int width, int height);

void cairo_surface_reference (cairo_surface_t * surface);

void cairo_surface_destroy (cairo_surface_t * surface);

cairo_status_t cairo_surface_set_repeat (cairo_surface_t * surface, int repeat);

cairo_status_t cairo_surface_set_matrix (cairo_surface_t * surface, cairo_matrix_t * matrix);

cairo_status_t cairo_surface_get_matrix (cairo_surface_t * surface, cairo_matrix_t * matrix);

cairo_status_t cairo_surface_set_filter (cairo_surface_t * surface, cairo_filter_t filter);

cairo_filter_t cairo_surface_get_filter (cairo_surface_t * surface);

cairo_surface_t * cairo_image_surface_create (class, cairo_format_t format, int width, int height);
    C_ARGS:
	format, width, height

cairo_surface_t * cairo_image_surface_create_for_data (class, char * data, cairo_format_t format, int width, int height, int stride);
    C_ARGS:
	data, format, width, height, stride

#ifdef CAIRO_HAS_PS_SURFACE

cairo_surface_t * cairo_ps_surface_create (class, FILE * file, double width_inches, double height_inches, double x_pixels_per_inch, double y_pixels_per_inch);
   C_ARGS:
	file, width_inches, height_inches, x_pixels_per_inch, y_pixels_per_inch

#endif /* CAIRO_HAS_PS_SURFACE */

#ifdef CAIRO_HAS_PNG_SURFACE

cairo_surface_t * cairo_png_surface_create (class, FILE * file, cairo_format_t format, int width, int height);
    C_ARGS:
	file, format, width, height

#endif /* CAIRO_HAS_PNG_SURFACE */

#ifdef CAIRO_HAS_XLIB_SURFACE

## XXX: Display, Drawable ...
cairo_surface_t * cairo_xlib_surface_create (class, Display * dpy, Drawable drawable, Visual * visual, cairo_format_t format, Colormap colormap);
    C_ARGS:
	dpy, drawable, visual, format, colormap

#endif /* CAIRO_HAS_XLIB_SURFACE */

#ifdef CAIRO_HAS_GLITZ_SURFACE

## XXX: glitz_surface_t
cairo_surface_t * cairo_glitz_surface_create (class, glitz_surface_t * surface);
    C_ARGS:
	surface

#endif /* CAIRO_HAS_GLITZ_SURFACE */

