/*
 * Copyright (c) 2004-2005 by the cairo perl team (see the file README)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 *
 */

#include <cairo-perl.h>
#include <cairo-perl-private.h>

/* ------------------------------------------------------------------------- */

static void
call_xs (pTHX_ void (*subaddr) (pTHX_ CV *), CV * cv, SV ** mark)
{
	dSP;
	PUSHMARK (mark);
	(*subaddr) (aTHX_ cv);
	PUTBACK;	/* forget return values */
}

#define CAIRO_PERL_CALL_BOOT(name)				\
	{							\
		extern XS(name);				\
		call_xs (aTHX_ name, cv, mark);	\
	}

/* ------------------------------------------------------------------------- */

/* XXX: these need extensive testing */

#define DOUBLES_DECLARE	\
	int i, n; double * pts;
#define DOUBLES_SLURP_FROM_STACK(first)				\
	n = (items - first);					\
	pts = (double*)malloc (sizeof (double) * n);		\
	if (!pts)						\
		croak ("malloc failure for (%d) elements", n);	\
	for (i = first ; i < items ; i++) {			\
		pts[i-first] = SvIV (ST (i));			\
	}
#define DOUBLES_LEN	n
#define DOUBLES_ARRAY	pts
#define DOUBLES_CLEANUP	\
	free (pts);

/* ------------------------------------------------------------------------- */

void *
cairo_object_from_sv (SV *sv, const char *package)
{
	if (!SvOK (sv) || !SvROK (sv) || !sv_derived_from (sv, package))
		croak("Cannot convert scalar 0x%x to an object of type %s",
		      sv, package);
	return INT2PTR (void *, SvIV ((SV *) SvRV (sv)));
}

SV *
cairo_object_to_sv (void *object, const char *package)
{
	SV *sv = newSV (0);
	sv_setref_pv(sv, package, object);
	return sv;
}

/* ------------------------------------------------------------------------- */

void *
cairo_struct_from_sv (SV *sv, const char *package)
{
	if (!SvOK (sv) || !SvROK (sv) || !sv_derived_from (sv, package))
		croak("Cannot convert scalar 0x%x to a struct of type %s",
		      sv, package);
	return INT2PTR (void *, SvIV ((SV *) SvRV (sv)));
}

SV *
cairo_struct_to_sv (void *object, const char *package)
{
	SV *sv = newSV (0);
	sv_setref_pv(sv, package, object);
	return sv;
}

/* ------------------------------------------------------------------------- */

SV *
newSVCairoFontExtents (cairo_font_extents_t * extents)
{
	HV *hv;
	double value;

	if (!extents)
		return &PL_sv_undef;

	hv = newHV ();

	value = extents->ascent;
	hv_store (hv, "ascent", 6, newSVnv (value), 0);

	value = extents->descent;
	hv_store (hv, "descent", 7, newSVnv (value), 0);

	value = extents->height;
	hv_store (hv, "height", 6, newSVnv (value), 0);

	value = extents->max_x_advance;
	hv_store (hv, "max_x_advance", 13, newSVnv (value), 0);

	value = extents->max_y_advance;
	hv_store (hv, "max_y_advance", 13, newSVnv (value), 0);

	return newRV_noinc ((SV *) hv);
}

/* ------------------------------------------------------------------------- */

SV *
newSVCairoTextExtents (cairo_text_extents_t * extents)
{
	HV *hv;
	double value;

	if (!extents)
		return &PL_sv_undef;

	hv = newHV ();

	value = extents->x_bearing;
	hv_store (hv, "x_bearing", 9, newSVnv (value), 0);

	value = extents->y_bearing;
	hv_store (hv, "y_bearing", 9, newSVnv (value), 0);

	value = extents->width;
	hv_store (hv, "width", 5, newSVnv (value), 0);

	value = extents->height;
	hv_store (hv, "height", 6, newSVnv (value), 0);

	value = extents->x_advance;
	hv_store (hv, "x_advance", 9, newSVnv (value), 0);

	value = extents->y_advance;
	hv_store (hv, "y_advance", 9, newSVnv (value), 0);

	return newRV_noinc ((SV *) hv);
}

/* ------------------------------------------------------------------------- */

/* taken from Glib/Glib.xs */
static void *
alloc_temp (int nbytes)
{
	dTHR;
	SV * s;

	if (nbytes <= 0) return NULL;

	s = sv_2mortal (NEWSV (0, nbytes));
	memset (SvPVX (s), 0, nbytes);
	return SvPVX (s);
}

SV *
newSVCairoGlyph (cairo_glyph_t * glyph)
{
	HV *hv;
	unsigned long index;
	double value;

	if (!glyph)
		return &PL_sv_undef;

	hv = newHV ();

	index = glyph->index;
	hv_store (hv, "index", 5, newSVuv (index), 0);

	value = glyph->x;
	hv_store (hv, "x", 1, newSVnv (value), 0);

	value = glyph->y;
	hv_store (hv, "y", 1, newSVnv (value), 0);

	return newRV_noinc ((SV *) hv);
}

cairo_glyph_t *
SvCairoGlyph (SV * sv)
{
	HV *hv;
	SV **value;
	cairo_glyph_t *glyph;

	if (!SvOK (sv) || !SvRV (sv) || SvTYPE (SvRV (sv)) != SVt_PVHV)
		croak ("cairo_glyph_t must be a hash reference");

	hv = (HV *) SvRV (sv);
	glyph = alloc_temp (sizeof (cairo_glyph_t));

	value = hv_fetch (hv, "index", 5, 0);
	if (value && SvOK (*value))
		glyph->index = SvUV (*value);

	value = hv_fetch (hv, "x", 1, 0);
	if (value && SvOK (*value))
		glyph->x = SvNV (*value);

	value = hv_fetch (hv, "y", 1, 0);
	if (value && SvOK (*value))
		glyph->y = SvNV (*value);

	return glyph;
}

/* ------------------------------------------------------------------------- */

MODULE = Cairo	PACKAGE = Cairo	PREFIX = cairo_

# int cairo_version ();
int cairo_version (class=NULL)
    C_ARGS:
	/* void */

# const char* cairo_version_string ();
const char* cairo_version_string (class=NULL)
    C_ARGS:
	/* void */

# ---------------------------------------------------------------------------- #

MODULE = Cairo	PACKAGE = Cairo::Context	PREFIX = cairo_

BOOT:
#include "cairo-perl-boot.xsh"

cairo_t_noinc * cairo_create (class, cairo_surface_t * target);
    C_ARGS:
	target

void DESTROY (cairo_t * cr);
    CODE:
	cairo_destroy (cr);

void cairo_save (cairo_t * cr);

void cairo_restore (cairo_t * cr);

void cairo_push_group (cairo_t *cr);

void cairo_push_group_with_content (cairo_t *cr, cairo_content_t content);

cairo_pattern_t * cairo_pop_group (cairo_t *cr);

void cairo_pop_group_to_source (cairo_t *cr);

void cairo_set_operator (cairo_t * cr, cairo_operator_t op);

void cairo_set_source_rgb (cairo_t *cr, double red, double green, double blue);

void cairo_set_source_rgba (cairo_t *cr, double red, double green, double blue, double alpha);

void cairo_set_source (cairo_t *cr, cairo_pattern_t *source);

void cairo_set_source_surface (cairo_t *cr, cairo_surface_t *surface, double x, double y);

void cairo_set_tolerance (cairo_t * cr, double tolerance);

void cairo_set_antialias (cairo_t *cr, cairo_antialias_t antialias);

void cairo_set_fill_rule (cairo_t * cr, cairo_fill_rule_t fill_rule);

void cairo_set_line_width (cairo_t * cr, double width);

void cairo_set_line_cap (cairo_t * cr, cairo_line_cap_t line_cap);

void cairo_set_line_join (cairo_t * cr, cairo_line_join_t line_join);

##void cairo_set_dash (cairo_t * cr, double * dashes, int ndash, double offset);
void cairo_set_dash (cairo_t * cr, double offset, dash1, ...)
    PREINIT:
	DOUBLES_DECLARE
    CODE:
	DOUBLES_SLURP_FROM_STACK (2)
	cairo_set_dash (cr, DOUBLES_ARRAY, DOUBLES_LEN, offset);
    CLEANUP:
	DOUBLES_CLEANUP

void cairo_set_miter_limit (cairo_t * cr, double limit);

void cairo_translate (cairo_t * cr, double tx, double ty);

void cairo_scale (cairo_t * cr, double sx, double sy);

void cairo_rotate (cairo_t * cr, double angle);

void cairo_transform (cairo_t *cr, const cairo_matrix_t *matrix);

void cairo_set_matrix (cairo_t * cr, const cairo_matrix_t * matrix);

void cairo_identity_matrix (cairo_t * cr);

void cairo_user_to_device (cairo_t *cr, IN_OUTLIST double x, IN_OUTLIST double y);

void cairo_user_to_device_distance (cairo_t *cr, IN_OUTLIST double dx, IN_OUTLIST double dy);

void cairo_device_to_user (cairo_t *cr, IN_OUTLIST double x, IN_OUTLIST double y);

void cairo_device_to_user_distance (cairo_t *cr, IN_OUTLIST double dx, IN_OUTLIST double dy);

void cairo_new_path (cairo_t * cr);

void cairo_new_sub_path (cairo_t *cr);

void cairo_move_to (cairo_t * cr, double x, double y);

void cairo_line_to (cairo_t * cr, double x, double y);

void cairo_curve_to (cairo_t * cr, double x1, double y1, double x2, double y2, double x3, double y3);

void cairo_arc (cairo_t * cr, double xc, double yc, double radius, double angle1, double angle2);

void cairo_arc_negative (cairo_t * cr, double xc, double yc, double radius, double angle1, double angle2);

void cairo_rel_move_to (cairo_t * cr, double dx, double dy);

void cairo_rel_line_to (cairo_t * cr, double dx, double dy);

void cairo_rel_curve_to (cairo_t * cr, double dx1, double dy1, double dx2, double dy2, double dx3, double dy3);

void cairo_rectangle (cairo_t * cr, double x, double y, double width, double height);

void cairo_close_path (cairo_t * cr);

void cairo_paint (cairo_t *cr);

void cairo_paint_with_alpha (cairo_t *cr, double alpha);

void cairo_mask (cairo_t *cr, cairo_pattern_t *pattern);

void cairo_mask_surface (cairo_t *cr, cairo_surface_t *surface, double surface_x, double surface_y);

void cairo_stroke (cairo_t * cr);

void cairo_stroke_preserve (cairo_t *cr);

void cairo_fill (cairo_t * cr);

void cairo_fill_preserve (cairo_t *cr);

void cairo_copy_page (cairo_t * cr);

void cairo_show_page (cairo_t * cr);

int cairo_in_stroke (cairo_t * cr, double x, double y);

int cairo_in_fill (cairo_t * cr, double x, double y);

void cairo_stroke_extents (cairo_t * cr, OUTLIST double x1, OUTLIST double y1, OUTLIST double x2, OUTLIST double y2);

void cairo_fill_extents (cairo_t * cr, OUTLIST double x1, OUTLIST double y1, OUTLIST double x2, OUTLIST double y2);

void cairo_clip (cairo_t * cr);

void cairo_clip_preserve (cairo_t *cr);

void cairo_reset_clip (cairo_t *cr);

void cairo_select_font_face (cairo_t *cr, const char *family, cairo_font_slant_t slant, cairo_font_weight_t weight);

void cairo_set_font_size (cairo_t *cr, double size);

void cairo_set_font_matrix (cairo_t *cr, const cairo_matrix_t *matrix);

##void cairo_get_font_matrix (cairo_t *cr, cairo_matrix_t *matrix);
cairo_matrix_t * cairo_get_font_matrix (cairo_t *cr)
    PREINIT:
	cairo_matrix_t matrix;
    CODE:
	cairo_get_font_matrix (cr, &matrix);
	RETVAL = cairo_perl_copy_matrix (&matrix);
    OUTPUT:
	RETVAL

void cairo_set_font_options (cairo_t *cr, const cairo_font_options_t *options);

##void cairo_get_font_options (cairo_t *cr, cairo_font_options_t *options);
cairo_font_options_t * cairo_get_font_options (cairo_t *cr)
    CODE:
	RETVAL = cairo_font_options_create ();
	cairo_get_font_options (cr, RETVAL);
    OUTPUT:
	RETVAL

void cairo_set_scaled_font (cairo_t *cr, const cairo_scaled_font_t *scaled_font);

void cairo_show_text (cairo_t * cr, const char * utf8);

##void cairo_show_glyphs (cairo_t * cr, cairo_glyph_t * glyphs, int num_glyphs);
void cairo_show_glyphs (cairo_t * cr, ...)
    PREINIT:
	cairo_glyph_t * glyphs = NULL;
	int num_glyphs, i;
    CODE:
	num_glyphs = items - 1;
	glyphs = calloc (sizeof (cairo_glyph_t), num_glyphs);
	for (i = 1; i < items; i++)
		glyphs[i - 1] = *SvCairoGlyph (ST (i));
	cairo_show_glyphs (cr, glyphs, num_glyphs);
	free (glyphs);

cairo_font_face_t * cairo_get_font_face (cairo_t *cr);

##void cairo_font_extents (cairo_t *cr, cairo_font_extents_t *extents);
cairo_font_extents_t * cairo_font_extents (cairo_t *cr)
    PREINIT:
	cairo_font_extents_t extents;
    CODE:
	cairo_font_extents (cr, &extents);
	RETVAL = &extents;
    OUTPUT:
	RETVAL

void cairo_set_font_face (cairo_t *cr, cairo_font_face_t *font_face);

##void cairo_text_extents (cairo_t * cr, const unsigned char * utf8, cairo_text_extents_t * extents);
cairo_text_extents_t * cairo_text_extents (cairo_t * cr, const char * utf8)
    PREINIT:
	cairo_text_extents_t extents;
    CODE:
	cairo_text_extents (cr, utf8, &extents);
	RETVAL = &extents;
    OUTPUT:
	RETVAL

##void cairo_glyph_extents (cairo_t * cr, cairo_glyph_t * glyphs, int num_glyphs, cairo_text_extents_t * extents);
cairo_text_extents_t * cairo_glyph_extents (cairo_t * cr, ...)
    PREINIT:
	cairo_text_extents_t extents;
	cairo_glyph_t * glyphs = NULL;
	int num_glyphs, i;
    CODE:
	num_glyphs = items - 1;
	glyphs = calloc (sizeof (cairo_glyph_t), num_glyphs);
	for (i = 1; i < items; i++)
		glyphs[i - 1] = *SvCairoGlyph (ST (i));
	cairo_glyph_extents (cr, glyphs, num_glyphs, &extents);
	RETVAL = &extents;
	free (glyphs);
    OUTPUT:
	RETVAL

void cairo_text_path  (cairo_t * cr, const char * utf8);

##void cairo_glyph_path (cairo_t * cr, cairo_glyph_t * glyphs, int num_glyphs);
void cairo_glyph_path (cairo_t * cr, ...)
    PREINIT:
	cairo_glyph_t * glyphs = NULL;
	int num_glyphs, i;
    CODE:
	num_glyphs = items - 1;
	glyphs = calloc (sizeof (cairo_glyph_t), num_glyphs);
	for (i = 1; i < items; i++)
		glyphs[i - 1] = *SvCairoGlyph (ST (i));
	cairo_glyph_path (cr, glyphs, num_glyphs);
	free (glyphs);

cairo_operator_t cairo_get_operator (cairo_t *cr);

cairo_pattern_t * cairo_get_source (cairo_t *cr);

double cairo_get_tolerance (cairo_t *cr);

cairo_antialias_t cairo_get_antialias (cairo_t *cr);

void cairo_get_current_point (cairo_t *cr, OUTLIST double x, OUTLIST double y);

cairo_fill_rule_t cairo_get_fill_rule (cairo_t *cr);

double cairo_get_line_width (cairo_t *cr);

cairo_line_cap_t cairo_get_line_cap (cairo_t *cr);

cairo_line_join_t cairo_get_line_join (cairo_t *cr);

double cairo_get_miter_limit (cairo_t *cr);

##void cairo_get_matrix (cairo_t *cr, cairo_matrix_t *matrix);
cairo_matrix_t * cairo_get_matrix (cairo_t *cr)
    PREINIT:
	cairo_matrix_t matrix;
    CODE:
	cairo_get_matrix (cr, &matrix);
	RETVAL = cairo_perl_copy_matrix (&matrix);
    OUTPUT:
	RETVAL

cairo_surface_t * cairo_get_target (cairo_t *cr);

cairo_surface_t * cairo_get_group_target (cairo_t *cr);

cairo_path_t * cairo_copy_path (cairo_t *cr);

cairo_path_t * cairo_copy_path_flat (cairo_t *cr);

void cairo_append_path (cairo_t *cr, cairo_path_t *path);

cairo_status_t cairo_status (cairo_t *cr);

# --------------------------------------------------------------------------- #

MODULE = Cairo	PACKAGE = Cairo	PREFIX = cairo_

bool
HAS_PS_SURFACE ()
    CODE:
#ifdef CAIRO_HAS_PS_SURFACE
	RETVAL = TRUE;
#else
	RETVAL = FALSE;
#endif
    OUTPUT:
	RETVAL

bool
HAS_PDF_SURFACE ()
    CODE:
#ifdef CAIRO_HAS_PDF_SURFACE
	RETVAL = TRUE;
#else
	RETVAL = FALSE;
#endif
    OUTPUT:
	RETVAL

bool
HAS_XLIB_SURFACE ()
    CODE:
#ifdef CAIRO_HAS_XLIB_SURFACE
	RETVAL = TRUE;
#else
	RETVAL = FALSE;
#endif
    OUTPUT:
	RETVAL

bool
HAS_FT_FONT ()
    CODE:
#ifdef CAIRO_HAS_FT_FONT
	RETVAL = TRUE;
#else
	RETVAL = FALSE;
#endif
    OUTPUT:
	RETVAL

bool
HAS_PNG_FUNCTIONS ()
    CODE:
#ifdef CAIRO_HAS_PNG_FUNCTIONS
	RETVAL = TRUE;
#else
	RETVAL = FALSE;
#endif
    OUTPUT:
	RETVAL
