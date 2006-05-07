/*
 * Copyright (c) 2004-2005 by the cairo perl team (see the file README)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include <cairo-perl.h>

static const char *
get_package (cairo_surface_t *surface)
{
	cairo_surface_type_t type;
	const char *package;

	type = cairo_surface_get_type (surface);
	switch (type) {
	    case CAIRO_SURFACE_TYPE_IMAGE:
		package = "Cairo::ImageSurface";
		break;

	    case CAIRO_SURFACE_TYPE_PDF:
		package = "Cairo::PdfSurface";
		break;

	    case CAIRO_SURFACE_TYPE_PS:
		package = "Cairo::PsSurface";
		break;

	    case CAIRO_SURFACE_TYPE_XLIB:
	    case CAIRO_SURFACE_TYPE_XCB:
	    case CAIRO_SURFACE_TYPE_GLITZ:
	    case CAIRO_SURFACE_TYPE_QUARTZ:
	    case CAIRO_SURFACE_TYPE_WIN32:
	    case CAIRO_SURFACE_TYPE_BEOS:
	    case CAIRO_SURFACE_TYPE_DIRECTFB:
	    case CAIRO_SURFACE_TYPE_SVG:
		package = "Cairo::Surface";
		break;

	    default:
		warn ("unknown surface type %d encountered", type);
		package = "Cairo::Surface";
		break;
	}
	
	return package;
}

SV *
cairo_surface_to_sv (cairo_surface_t *surface)
{
	SV *sv = newSV (0);
	sv_setref_pv(sv, get_package (surface), surface);
	return sv;
}

MODULE = Cairo::Surface	PACKAGE = Cairo::Surface	PREFIX = cairo_surface_

void DESTROY (cairo_surface_t * surface);
    CODE:
	cairo_surface_destroy (surface);

cairo_surface_t * cairo_surface_create_similar (cairo_surface_t * other, cairo_content_t content, int width, int height);

cairo_status_t cairo_surface_status (cairo_surface_t *surface);

void cairo_surface_finish (cairo_surface_t *surface);

void cairo_surface_set_device_offset (cairo_surface_t *surface, double x_offset, double y_offset);

##void cairo_surface_get_device_offset (cairo_surface_t *surface, double *x_offset, double *y_offset);
void
cairo_surface_get_device_offset (cairo_surface_t *surface)
    PREINIT:
	double x_offset;
	double y_offset;
    PPCODE:
	cairo_surface_get_device_offset (surface, &x_offset, &y_offset);
	EXTEND (sp, 2);
	PUSHs (sv_2mortal (newSVnv (x_offset)));
	PUSHs (sv_2mortal (newSVnv (y_offset)));

##void cairo_surface_get_font_options (cairo_surface_t *surface, cairo_font_options_t *options);
cairo_font_options_t * cairo_surface_get_font_options (cairo_surface_t *surface)
    CODE:
	RETVAL = cairo_font_options_create ();
	cairo_surface_get_font_options (surface, RETVAL);
    OUTPUT:
	RETVAL

void cairo_surface_flush (cairo_surface_t *surface);

void cairo_surface_mark_dirty (cairo_surface_t *surface);

void cairo_surface_mark_dirty_rectangle (cairo_surface_t *surface, int x, int y, int width, int height);

cairo_surface_type_t cairo_surface_get_type (cairo_surface_t *surface);

#ifdef CAIRO_HAS_PNG_FUNCTIONS

cairo_status_t cairo_surface_write_to_png (cairo_surface_t *surface, const char *filename);

# FIXME
##cairo_status_t cairo_surface_write_to_png_stream (cairo_surface_t *surface, cairo_write_func_t write_func, void *closure);

#endif

# --------------------------------------------------------------------------- #

MODULE = Cairo::Surface	PACKAGE = Cairo::ImageSurface	PREFIX = cairo_image_surface_

##cairo_surface_t * cairo_image_surface_create (cairo_format_t format, int width, int height);
cairo_surface_t_noinc * cairo_image_surface_create (class, cairo_format_t format, int width, int height)
    C_ARGS:
	format, width, height

##cairo_surface_t * cairo_image_surface_create_for_data (unsigned char *data, cairo_format_t format, int width, int height, int stride);
cairo_surface_t_noinc * cairo_image_surface_create_for_data (class, unsigned char *data, cairo_format_t format, int width, int height, int stride)
    C_ARGS:
	data, format, width, height, stride

int cairo_image_surface_get_width (cairo_surface_t *surface);

int cairo_image_surface_get_height (cairo_surface_t *surface);

#ifdef CAIRO_HAS_PNG_FUNCTIONS

##cairo_surface_t * cairo_image_surface_create_from_png (const char *filename);
cairo_surface_t_noinc * cairo_image_surface_create_from_png (class, const char *filename)
    C_ARGS:
	filename

# FIXME
##cairo_surface_t * cairo_image_surface_create_from_png_stream (cairo_read_func_t read_func, void *closure);

#endif

# --------------------------------------------------------------------------- #

#ifdef CAIRO_HAS_PDF_SURFACE

MODULE = Cairo::Surface	PACKAGE = Cairo::PdfSurface	PREFIX = cairo_pdf_surface_

##cairo_surface_t * cairo_pdf_surface_create (const char *filename, double width_in_points, double height_in_points);
cairo_surface_t_noinc * cairo_pdf_surface_create (class, const char *filename, double width_in_points, double height_in_points)
    C_ARGS:
	filename, width_in_points, height_in_points

# FIXME
##cairo_surface_t * cairo_pdf_surface_create_for_stream (cairo_write_func_t write_func, void *closure, double width_in_points, double height_in_points);

void cairo_pdf_surface_set_dpi (cairo_surface_t *surface, double x_dpi, double y_dpi);

void cairo_pdf_surface_set_size (cairo_surface_t *surface, double width_in_points, double height_in_points);

#endif

# --------------------------------------------------------------------------- #

#ifdef CAIRO_HAS_PS_SURFACE

MODULE = Cairo::Surface	PACKAGE = Cairo::PsSurface	PREFIX = cairo_ps_surface_

##cairo_surface_t * cairo_ps_surface_create (const char *filename, double width_in_points, double height_in_points);
cairo_surface_t_noinc * cairo_ps_surface_create (class, const char *filename, double width_in_points, double height_in_points)
    C_ARGS:
	filename, width_in_points, height_in_points

# FIXME
##cairo_surface_t * cairo_ps_surface_create_for_stream (cairo_write_func_t write_func, void *closure, double width_in_points, double height_in_points);

void cairo_ps_surface_set_dpi (cairo_surface_t *surface, double x_dpi, double y_dpi);

void cairo_ps_surface_set_size (cairo_surface_t	*surface, double width_in_points, double height_in_points);

void cairo_ps_surface_dsc_comment (cairo_surface_t *surface, const char *comment);

void cairo_ps_surface_dsc_begin_setup (cairo_surface_t *surface);

void cairo_ps_surface_dsc_begin_page_setup (cairo_surface_t *surface);

#endif
