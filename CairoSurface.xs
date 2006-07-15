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

	    case CAIRO_SURFACE_TYPE_SVG:
		package = "Cairo::SvgSurface";
		break;

	    case CAIRO_SURFACE_TYPE_XLIB:
	    case CAIRO_SURFACE_TYPE_XCB:
	    case CAIRO_SURFACE_TYPE_GLITZ:
	    case CAIRO_SURFACE_TYPE_QUARTZ:
	    case CAIRO_SURFACE_TYPE_WIN32:
	    case CAIRO_SURFACE_TYPE_BEOS:
	    case CAIRO_SURFACE_TYPE_DIRECTFB:
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

/* -------------------------------------------------------------------------- */

typedef struct {
	SV *func;
	SV *data;
	void *context;
} CairoPerlCallback;

#ifdef PERL_IMPLICIT_CONTEXT
# define dCAIRO_PERL_CALLBACK_MARSHAL_SP		\
	SV ** sp;
# define CAIRO_PERL_CALLBACK_MARSHAL_INIT(callback)	\
	PERL_SET_CONTEXT (callback->context);		\
	SPAGAIN;
#else
# define dCAIRO_PERL_CALLBACK_MARSHAL_SP		\
	dSP;
# define CAIRO_PERL_CALLBACK_MARSHAL_INIT(callback)	\
	/* nothing to do */
#endif

static CairoPerlCallback *
cairo_perl_callback_new (SV *func, SV *data)
{
	CairoPerlCallback *callback;

	callback = calloc (sizeof (CairoPerlCallback), 1);

	callback->func = newSVsv (func);
	if (data)
		callback->data = newSVsv (data);

#ifdef PERL_IMPLICIT_CONTEXT
	callback->context = aTHX;
#endif

	return callback;
}

static void
cairo_perl_callback_free (CairoPerlCallback *callback)
{
	SvREFCNT_dec (callback->func);
	if (callback->data)
		SvREFCNT_dec (callback->data);
	free (callback);
}

/* -------------------------------------------------------------------------- */

static cairo_status_t
write_func_marshaller (void *closure,
                       const unsigned char *data,
                       unsigned int length)
{
	CairoPerlCallback *callback;
	cairo_status_t status;
	dCAIRO_PERL_CALLBACK_MARSHAL_SP;

	callback = (CairoPerlCallback *) closure;

	CAIRO_PERL_CALLBACK_MARSHAL_INIT (callback);

	ENTER;
	SAVETMPS;
	PUSHMARK (SP);

	EXTEND (SP, 2);
	PUSHs (callback->data ? callback->data : &PL_sv_undef);
	PUSHs (sv_2mortal (newSVpv ((const char *) data, length)));

	PUTBACK;
	call_sv (callback->func, G_DISCARD | G_EVAL);
	SPAGAIN;

	status = SvTRUE (ERRSV) ? SvCairoStatus (ERRSV) : CAIRO_STATUS_SUCCESS;

	PUTBACK;
	FREETMPS;
	LEAVE;

	return status;
}

/* -------------------------------------------------------------------------- */

static cairo_status_t
read_func_marshaller (void *closure,
                      unsigned char *data,
                      unsigned int length)
{
	CairoPerlCallback *callback;
	cairo_status_t status = CAIRO_STATUS_SUCCESS;
	dCAIRO_PERL_CALLBACK_MARSHAL_SP;

	callback = (CairoPerlCallback *) closure;

	CAIRO_PERL_CALLBACK_MARSHAL_INIT (callback);

	ENTER;
	SAVETMPS;
	PUSHMARK (SP);

	EXTEND (SP, 2);
	PUSHs (callback->data ? callback->data : &PL_sv_undef);
	PUSHs (sv_2mortal (newSVuv (length)));

	PUTBACK;
	call_sv (callback->func, G_SCALAR | G_EVAL);
	SPAGAIN;

	if (SvTRUE (ERRSV)) {
		status = SvCairoStatus (ERRSV);
	} else {
		STRLEN n_a;
		char *retval;
		retval = POPpx;
		memcpy (data, retval, n_a);
	}

	PUTBACK;
	FREETMPS;
	LEAVE;

	return status;
}

/* -------------------------------------------------------------------------- */

MODULE = Cairo::Surface	PACKAGE = Cairo::Surface	PREFIX = cairo_surface_

void DESTROY (cairo_surface_t * surface);
    CODE:
	cairo_surface_destroy (surface);

cairo_surface_t_noinc * cairo_surface_create_similar (cairo_surface_t * other, cairo_content_t content, int width, int height);

cairo_status_t cairo_surface_status (cairo_surface_t *surface);

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

void cairo_surface_set_fallback_resolution (cairo_surface_t *surface, double x_pixels_per_inch, double y_pixels_per_inch);

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

cairo_content_t cairo_surface_get_content (cairo_surface_t *surface);

#ifdef CAIRO_HAS_PNG_FUNCTIONS

cairo_status_t cairo_surface_write_to_png (cairo_surface_t *surface, const char *filename);

##cairo_status_t cairo_surface_write_to_png_stream (cairo_surface_t *surface, cairo_write_func_t write_func, void *closure);
cairo_status_t
cairo_surface_write_to_png_stream (cairo_surface_t *surface, SV *func, SV *data=NULL)
    PREINIT:
	CairoPerlCallback *callback;
    CODE:
	callback = cairo_perl_callback_new (func, data);
	RETVAL = cairo_surface_write_to_png_stream (surface,
	                                            write_func_marshaller,
	                                            callback);
	cairo_perl_callback_free (callback);
    OUTPUT:
	RETVAL

#endif

# --------------------------------------------------------------------------- #

MODULE = Cairo::Surface	PACKAGE = Cairo::ImageSurface	PREFIX = cairo_image_surface_

BOOT:
	cair_perl_set_isa ("Cairo::ImageSurface", "Cairo::Surface");

##cairo_surface_t * cairo_image_surface_create (cairo_format_t format, int width, int height);
cairo_surface_t_noinc * cairo_image_surface_create (class, cairo_format_t format, int width, int height)
    C_ARGS:
	format, width, height

##cairo_surface_t * cairo_image_surface_create_for_data (unsigned char *data, cairo_format_t format, int width, int height, int stride);
cairo_surface_t_noinc * cairo_image_surface_create_for_data (class, unsigned char *data, cairo_format_t format, int width, int height, int stride)
    C_ARGS:
	data, format, width, height, stride

# unsigned char * cairo_image_surface_get_data (cairo_surface_t *surface);
SV *
cairo_image_surface_get_data (cairo_surface_t *surface)
    PREINIT:
	unsigned char *data;
    CODE:
	data = cairo_image_surface_get_data (surface);
	RETVAL = data ? newSVpv ((char *) data, 0) : &PL_sv_undef;
    OUTPUT:
	RETVAL

cairo_format_t cairo_image_surface_get_format (cairo_surface_t *surface);

int cairo_image_surface_get_width (cairo_surface_t *surface);

int cairo_image_surface_get_height (cairo_surface_t *surface);

int cairo_image_surface_get_stride (cairo_surface_t *surface);

#ifdef CAIRO_HAS_PNG_FUNCTIONS

##cairo_surface_t * cairo_image_surface_create_from_png (const char *filename);
cairo_surface_t_noinc * cairo_image_surface_create_from_png (class, const char *filename)
    C_ARGS:
	filename

##cairo_surface_t * cairo_image_surface_create_from_png_stream (cairo_read_func_t read_func, void *closure);
cairo_surface_t_noinc *
cairo_image_surface_create_from_png_stream (class, SV *func, SV *data=NULL)
    PREINIT:
	CairoPerlCallback *callback;
    CODE:
	callback = cairo_perl_callback_new (func, data);
	RETVAL = cairo_image_surface_create_from_png_stream (
			read_func_marshaller, callback);
	cairo_perl_callback_free (callback);
    OUTPUT:
	RETVAL

#endif

# --------------------------------------------------------------------------- #

#ifdef CAIRO_HAS_PDF_SURFACE

MODULE = Cairo::Surface	PACKAGE = Cairo::PdfSurface	PREFIX = cairo_pdf_surface_

BOOT:
	cair_perl_set_isa ("Cairo::PdfSurface", "Cairo::Surface");

##cairo_surface_t * cairo_pdf_surface_create (const char *filename, double width_in_points, double height_in_points);
cairo_surface_t_noinc * cairo_pdf_surface_create (class, const char *filename, double width_in_points, double height_in_points)
    C_ARGS:
	filename, width_in_points, height_in_points

##cairo_surface_t * cairo_pdf_surface_create_for_stream (cairo_write_func_t write_func, void *closure, double width_in_points, double height_in_points);
cairo_surface_t_noinc *
cairo_pdf_surface_create_for_stream (class, SV *func, SV *data, double width_in_points, double height_in_points)
    PREINIT:
	CairoPerlCallback *callback;
    CODE:
	callback = cairo_perl_callback_new (func, data);
	RETVAL = cairo_pdf_surface_create_for_stream (write_func_marshaller,
	                                              callback,
	                                              width_in_points,
	                                              height_in_points);
	cairo_surface_set_user_data (
		RETVAL, (const cairo_user_data_key_t *) &callback, callback,
		(cairo_destroy_func_t) cairo_perl_callback_free);
    OUTPUT:
	RETVAL

void cairo_pdf_surface_set_size (cairo_surface_t *surface, double width_in_points, double height_in_points);

#endif

# --------------------------------------------------------------------------- #

#ifdef CAIRO_HAS_PS_SURFACE

MODULE = Cairo::Surface	PACKAGE = Cairo::PsSurface	PREFIX = cairo_ps_surface_

BOOT:
	cair_perl_set_isa ("Cairo::PsSurface", "Cairo::Surface");

##cairo_surface_t * cairo_ps_surface_create (const char *filename, double width_in_points, double height_in_points);
cairo_surface_t_noinc * cairo_ps_surface_create (class, const char *filename, double width_in_points, double height_in_points)
    C_ARGS:
	filename, width_in_points, height_in_points

##cairo_surface_t * cairo_ps_surface_create_for_stream (cairo_write_func_t write_func, void *closure, double width_in_points, double height_in_points);
cairo_surface_t_noinc *
cairo_ps_surface_create_for_stream (class, SV *func, SV *data, double width_in_points, double height_in_points)
    PREINIT:
	CairoPerlCallback *callback;
    CODE:
	callback = cairo_perl_callback_new (func, data);
	RETVAL = cairo_ps_surface_create_for_stream (write_func_marshaller,
	                                             callback,
	                                             width_in_points,
	                                             height_in_points);
	cairo_surface_set_user_data (
		RETVAL, (const cairo_user_data_key_t *) &callback, callback,
		(cairo_destroy_func_t) cairo_perl_callback_free);
    OUTPUT:
	RETVAL

void cairo_ps_surface_set_size (cairo_surface_t	*surface, double width_in_points, double height_in_points);

void cairo_ps_surface_dsc_comment (cairo_surface_t *surface, const char *comment);

void cairo_ps_surface_dsc_begin_setup (cairo_surface_t *surface);

void cairo_ps_surface_dsc_begin_page_setup (cairo_surface_t *surface);

#endif

# --------------------------------------------------------------------------- #

#ifdef CAIRO_HAS_SVG_SURFACE

MODULE = Cairo::Surface	PACKAGE = Cairo::SvgSurface	PREFIX = cairo_svg_surface_

BOOT:
	cair_perl_set_isa ("Cairo::SvgSurface", "Cairo::Surface");

# cairo_surface_t * cairo_svg_surface_create (const char *filename, double width_in_points, double height_in_points);
cairo_surface_t_noinc *
cairo_svg_surface_create (class, const char *filename, double width_in_points, double height_in_points)
    C_ARGS:
	filename, width_in_points, height_in_points

# cairo_surface_t * cairo_svg_surface_create_for_stream (cairo_write_func_t write_func, void *closure, double width_in_points, double height_in_points);
cairo_surface_t_noinc *
cairo_svg_surface_create_for_stream (class, SV *func, SV *data, double width_in_points, double height_in_points)
    PREINIT:
	CairoPerlCallback *callback;
    CODE:
	callback = cairo_perl_callback_new (func, data);
	RETVAL = cairo_svg_surface_create_for_stream (write_func_marshaller,
						      callback,
						      width_in_points,
						      height_in_points);
	cairo_surface_set_user_data (
		RETVAL, (const cairo_user_data_key_t *) &callback, callback,
		(cairo_destroy_func_t) cairo_perl_callback_free);
    OUTPUT:
	RETVAL

void cairo_svg_surface_restrict_to_version (cairo_surface_t *surface, cairo_svg_version_t version);

# void cairo_svg_get_versions (cairo_svg_version_t const **versions, int *num_versions);
void
cairo_svg_surface_get_versions (class=NULL)
    PREINIT:
	cairo_svg_version_t const *versions = NULL;
	int num_versions = 0, i;
    PPCODE:
	PERL_UNUSED_VAR (ax);
	cairo_svg_get_versions (&versions, &num_versions);
	EXTEND (sp, num_versions);
	for (i = 0; i < num_versions; i++)
		PUSHs (sv_2mortal (newSVCairoSvgVersion (versions[i])));

# const char * cairo_svg_version_to_string (cairo_svg_version_t version);
const char *
cairo_svg_surface_version_to_string (...)
    CODE:
	if (items == 1) {
		RETVAL = cairo_svg_version_to_string (SvCairoSvgVersion (ST (0)));
	} else if (items == 2) {
		RETVAL = cairo_svg_version_to_string (SvCairoSvgVersion (ST (1)));
	} else {
		RETVAL = NULL;
		croak ("Usage: Cairo::SvgSurface::version_to_string (version) or Cairo::SvgSurface->version_to_string (version)");
	}
    OUTPUT:
	RETVAL

#endif
