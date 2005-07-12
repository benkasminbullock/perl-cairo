/*
 * Copyright (c) 2004-2005 by the cairo perl team (see the file README)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include <cairo-perl.h>

MODULE = Cairo::Surface	PACKAGE = Cairo::Surface	PREFIX = cairo_surface_

void DESTROY (cairo_surface_t * surface);
    CODE:
	cairo_surface_destroy (surface);

##cairo_surface_t * cairo_surface_create_similar (cairo_surface_t * other, cairo_content_t content, int width, int height);
SV * cairo_surface_create_similar (SV * other, cairo_content_t content, int width, int height)
    PREINIT:
	char *package;
	IV pointer;
	cairo_surface_t *other_surface, *surface;
    CODE:
	package = sv_reftype (SvRV (other), TRUE);
	pointer = SvIV ((SV *) SvRV (other));
	other_surface = INT2PTR (cairo_surface_t *, pointer);

	surface = cairo_surface_create_similar (other_surface, content, width, height);
	RETVAL = newSV (0);
	sv_setref_pv (RETVAL, package, (void *) surface);
    OUTPUT:
	RETVAL

cairo_status_t cairo_surface_finish (cairo_surface_t *surface);

void cairo_surface_set_device_offset (cairo_surface_t *surface, double x_offset, double y_offset);

#ifdef CAIRO_HAS_PNG_FUNCTIONS

cairo_status_t cairo_surface_write_to_png (cairo_surface_t *surface, const char *filename);

# FIXME?
##cairo_status_t cairo_surface_write_to_png_stream (cairo_surface_t *surface, cairo_write_func_t write_func, void *closure);

#endif

# --------------------------------------------------------------------------- #

MODULE = Cairo::Surface	PACKAGE = Cairo::ImageSurface	PREFIX = cairo_image_surface_

##cairo_surface_t * cairo_image_surface_create (cairo_format_t format, int width, int height);
cairo_image_surface_t_noinc * cairo_image_surface_create (class, cairo_format_t format, int width, int height)
    C_ARGS:
	format, width, height

##cairo_surface_t * cairo_image_surface_create_for_data (unsigned char *data, cairo_format_t format, int width, int height, int stride);
cairo_image_surface_t_noinc * cairo_image_surface_create_for_data (class, unsigned char *data, cairo_format_t format, int width, int height, int stride)
    C_ARGS:
	data, format, width, height, stride

int cairo_image_surface_get_width (cairo_surface_t *surface);

int cairo_image_surface_get_height (cairo_surface_t *surface);

#ifdef CAIRO_HAS_PNG_FUNCTIONS

##cairo_surface_t * cairo_image_surface_create_from_png (const char *filename);
cairo_image_surface_t_noinc * cairo_image_surface_create_from_png (class, const char *filename)
    C_ARGS:
	filename

# FIXME?
##cairo_surface_t * cairo_image_surface_create_from_png_stream (cairo_read_func_t read_func, void *closure);

#endif

# --------------------------------------------------------------------------- #

#ifdef CAIRO_HAS_PDF_SURFACE

MODULE = Cairo::Surface	PACKAGE = Cairo::PdfSurface	PREFIX = cairo_pdf_surface_

##cairo_surface_t * cairo_pdf_surface_create (const char *filename, double width_in_points, double height_in_points);
cairo_pdf_surface_t_noinc * cairo_pdf_surface_create (class, const char *filename, double width_in_points, double height_in_points)
    C_ARGS:
	filename, width_in_points, height_in_points

# FIXME?
##cairo_surface_t * cairo_pdf_surface_create_for_stream (cairo_write_func_t write_func, void *closure, double width_in_points, double height_in_points);

void cairo_pdf_surface_set_dpi (cairo_surface_t *surface, double x_dpi, double y_dpi);

#endif

# --------------------------------------------------------------------------- #

#ifdef CAIRO_HAS_PS_SURFACE

MODULE = Cairo::Surface	PACKAGE = Cairo::PsSurface	PREFIX = cairo_ps_surface_

##cairo_surface_t * cairo_ps_surface_create (const char *filename, double width_in_points, double height_in_points);
cairo_ps_surface_t_noinc * cairo_ps_surface_create (class, const char *filename, double width_in_points, double height_in_points)
    C_ARGS:
	filename, width_in_points, height_in_points

# FIXME?
##cairo_surface_t * cairo_ps_surface_create_for_stream (cairo_write_func_t write_func, void *closure, double width_in_points, double height_in_points);

# FIXME: this is listed in the header but apparently not implemented yet.
##void cairo_ps_surface_set_dpi (cairo_surface_t *surface, double x_dpi, double y_dpi);

#endif
