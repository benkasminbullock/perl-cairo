/*
 * Copyright (c) 2004 by the cairo  perl team (see the file README)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include <cairo-perl.h>

MODULE = Cairo::Surface	PACKAGE = Cairo::ImageSurface	PREFIX = cairo_image_surface_

## XXX: add format
cairo_surface_t * cairo_image_surface_create (class, cairo_format_t format, int width, int height)
    CODE:
	RETVAL = cairo_image_surface_create (format, width, height);
	DBG ("creating surface %p\n", RETVAL);
    OUTPUT:
	RETVAL

MODULE = Cairo::Surface	PACKAGE = Cairo::Surface PREFIX = cairo_surface_

## manipulate state objects

void cairo_surface_DESTROY (cairo_surface_t * surface);
    CODE:
	DBG ("destroying surface: %p\n", surface);
	cairo_surface_destroy (surface);
