/*
 * Copyright (c) 2004 by the cairo  perl team (see the file README)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include <cairo-perl.h>

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
