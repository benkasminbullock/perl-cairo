/*
 * Copyright (c) 2004 by the cairo  perl team (see the file README)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 *
 */

#include <cairo-perl.h>

void
_cairo_perl_call_XS (pTHX_ void (*subaddr) (pTHX_ CV *), CV * cv, SV ** mark)
{
	dSP;
	PUSHMARK (mark);
	(*subaddr) (aTHX_ cv);
	PUTBACK;	/* forget return values */
}

MODULE = Cairo	PACKAGE = Cairo	PREFIX = cairo_

BOOT:
	{
#include "cairo-perl-boot.xsh"
	}

cairo_t * cairo_create (class);
    ALIAS:
	Cairo::new = 1
    C_ARGS:
	/* void */
    CLEANUP:
	CAIRO_PERL_UNUSED (ix);

## shouldn't have to deal with references from perl
##void cairo_reference (cairo_t * cr);

## destroy should happen auto-magically
##void cairo_destroy (cairo_t * cr);
void cairo_DESTROY (cairo_t * cr);
    CODE:
	cairo_destroy (cr);

void cairo_save (cairo_t * cr);

void cairo_restore (cairo_t * cr);

## void cairo_copy (cairo_t * dest, cairo_t * src);
cairo_t * cairo_copy (cairo_t * src)
    CODE:
	RETVAL = cairo_create ();
	cairo_copy (RETVAL, src);
    OUTPUT:
	RETVAL

void cairo_set_target_surface (cairo_t * cr, cairo_surface_t * surface);

void cairo_set_target_image (cairo_t * cr, char * data, cairo_format_t format, int width, int height, int stride);


#ifdef CAIRO_HAS_PS_SURFACE
# include <stdio.h>

void cairo_set_target_ps (cairo_t * cr, FILE * file, double width_inches, double height_inches, double x_pixels_per_inch, double y_pixels_per_inch);

#endif /* CAIRO_HAS_PS_SURFACE */


#ifdef CAIRO_HAS_PNG_SURFACE
# include <stdio.h>

void cairo_set_target_png (cairo_t * cr, FILE * file, cairo_format_t format, int width, int height);

#endif /* CAIRO_HAS_PNG_SURFACE */


#ifdef CAIRO_HAS_XLIB_SURFACE
# include <X11/extensions/Xrender.h>

## XXX: how would you get a Display and Drawable in perl
void cairo_set_target_drawable (cairo_t * cr, Display * dpy, Drawable drawable);

#endif /* CAIRO_HAS_XLIB_SURFACE */


#ifdef CAIRO_HAS_XCB_SURFACE
# include <X11/XCB/xcb.h>
# include <X11/XCB/render.h>

## XXX: how would you get these XCB types in perl
void cairo_set_target_xcb (cairo_t * cr, XCBConnection * dpy, XCBDRAWABLE drawable, XCBVISUALTYPE * visual, cairo_format_t format);

#endif /* CAIRO_HAS_XCB_SURFACE */


#ifdef CAIRO_HAS_GLITZ_SURFACE
# include <glitz.h>

## XXX: how would you get a glitz_surface_t in perl
void cairo_set_target_glitz (cairo_t * cr, glitz_surface_t * surface);

#endif /* CAIRO_HAS_GLITZ_SURFACE */


void cairo_set_operator (cairo_t * cr, cairo_operator_t op);

void cairo_set_rgb_color (cairo_t * cr, double red, double green, double blue);

void cairo_set_pattern (cairo_t * cr, cairo_pattern_t * pattern);

void cairo_set_alpha (cairo_t * cr, double alpha);

void cairo_set_tolerance (cairo_t * cr, double tolerance);

void cairo_set_fill_rule (cairo_t * cr, cairo_fill_rule_t fill_rule);

void cairo_set_line_width (cairo_t * cr, double width);

void cairo_set_line_cap (cairo_t * cr, cairo_line_cap_t line_cap);

void cairo_set_line_join (cairo_t * cr, cairo_line_join_t line_join);

## XXX: double *
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

void cairo_concat_matrix (cairo_t * cr, cairo_matrix_t * matrix);

void cairo_set_matrix (cairo_t * cr, cairo_matrix_t * matrix);

void cairo_default_matrix (cairo_t * cr);

void cairo_identity_matrix (cairo_t * cr);

## XXX: double *
##void cairo_transform_point (cairo_t * cr, double * x, double * y);
void cairo_transform_point (cairo_t * cr, IN_OUTLIST double x, IN_OUTLIST double y);

## XXX: double *
##void cairo_transform_distance (cairo_t * cr, double * dx, double * dy);
void cairo_transform_distance (cairo_t * cr, IN_OUTLIST double dx, IN_OUTLIST double dy);

## XXX: double *
##void cairo_inverse_transform_point (cairo_t * cr, double * x, double * y);
void cairo_inverse_transform_point (cairo_t * cr, IN_OUTLIST double x, IN_OUTLIST double y);

## XXX: double *
##void cairo_inverse_transform_distance (cairo_t * cr, double * dx, double * dy);
void cairo_inverse_transform_distance (cairo_t * cr, IN_OUTLIST double dx, IN_OUTLIST double dy);

void cairo_new_path (cairo_t * cr);

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

void cairo_stroke (cairo_t * cr);

void cairo_fill (cairo_t * cr);

void cairo_copy_page (cairo_t * cr);

void cairo_show_page (cairo_t * cr);

int cairo_in_stroke (cairo_t * cr, double x, double y);

int cairo_in_fill (cairo_t * cr, double x, double y);

## XXX: double *
##void cairo_stroke_extents (cairo_t * cr, double * x1, double * y1, double * x2, double * y2);
void cairo_stroke_extents (cairo_t * cr, OUTLIST double x1, OUTLIST double y1, OUTLIST double x2, OUTLIST double y2);

## XXX: double *
##void cairo_fill_extents (cairo_t * cr, double * x1, double * y1, double * x2, double * y2);
void cairo_fill_extents (cairo_t * cr, OUTLIST double x1, OUTLIST double y1, OUTLIST double x2, OUTLIST double y2);

void cairo_init_clip (cairo_t * cr);

void cairo_clip (cairo_t * cr);

void cairo_select_font (cairo_t * cr, const char * family, cairo_font_slant_t slant, cairo_font_weight_t weight);

void cairo_scale_font (cairo_t * cr, double scale);

void cairo_transform_font (cairo_t * cr, cairo_matrix_t * matrix);

void cairo_show_text (cairo_t * cr, const unsigned char * utf8);

void cairo_show_glyphs (cairo_t * cr, cairo_glyph_t * glyphs, int num_glyphs);

cairo_font_t * cairo_current_font (cairo_t * cr);

void cairo_current_font_extents (cairo_t * cr, cairo_font_extents_t * extents);

void cairo_set_font (cairo_t * cr, cairo_font_t * font);

void cairo_text_extents (cairo_t * cr, const unsigned char * utf8, cairo_text_extents_t * extents);

void cairo_glyph_extents (cairo_t * cr, cairo_glyph_t * glyphs, int num_glyphs, cairo_text_extents_t * extents);

void cairo_text_path  (cairo_t * cr, const unsigned char * utf8);

void cairo_glyph_path (cairo_t * cr, cairo_glyph_t * glyphs, int num_glyphs);

#include <fontconfig/fontconfig.h>
#include <ft2build.h>
#include FT_FREETYPE_H

## XXX: FT...
##cairo_font_t * cairo_ft_font_create (FT_Library ft_library, FcPattern * pattern);

## XXX: FT...
##cairo_font_t * cairo_ft_font_create_for_ft_face (FT_Face face);

## XXX: this symbol is undefined
##void cairo_ft_font_destroy (cairo_font_t * ft_font);

## XXX: FT...
##FT_Face cairo_ft_font_face (cairo_font_t * ft_font);

## XXX: Fc...
##FcPattern * cairo_ft_font_pattern (cairo_font_t  * ft_font);

void cairo_show_surface (cairo_t * cr, cairo_surface_t * surface, int width, int height);

cairo_operator_t cairo_current_operator (cairo_t * cr);

##void cairo_current_rgb_color (cairo_t * cr, double * red, double * green, double * blue);
void cairo_current_rgb_color (cairo_t * cr, OUTLIST double red, OUTLIST double green, OUTLIST double blue);

cairo_pattern_t * cairo_current_pattern (cairo_t * cr);

double cairo_current_alpha (cairo_t * cr);

double cairo_current_tolerance (cairo_t * cr);

##void cairo_current_point (cairo_t * cr, double * x, double * y);
void cairo_current_point (cairo_t * cr, OUTLIST double x, OUTLIST double y);

cairo_fill_rule_t cairo_current_fill_rule (cairo_t * cr);

double cairo_current_line_width (cairo_t * cr);

cairo_line_cap_t cairo_current_line_cap (cairo_t * cr);

cairo_line_join_t cairo_current_line_join (cairo_t * cr);

double cairo_current_miter_limit (cairo_t * cr);

##void cairo_current_matrix (cairo_t * cr, cairo_matrix_t * matrix);
cairo_matrix_t * cairo_current_matrix (cairo_t * cr);
    CODE:
	RETVAL = cairo_matrix_create ();
	cairo_current_matrix (cr, RETVAL);
    OUTPUT:
	RETVAL

cairo_surface_t * cairo_current_target_surface (cairo_t * cr);

## XXX: callbacks
##typedef void (cairo_move_to_func_t) (void * closure, double x, double y);
##
##typedef void (cairo_line_to_func_t) (void * closure, double x, double y);
##
##typedef void (cairo_curve_to_func_t) (void * closure, double x1, double y1, double x2, double y2, double x3, double y3);
##
##typedef void (cairo_close_path_func_t) (void * closure);
##
##extern void cairo_current_path (cairo_t * cr, cairo_move_to_func_t * move_to, cairo_line_to_func_t * line_to, cairo_curve_to_func_t * curve_to, cairo_close_path_func_t * close_path, void * closure);
##
##extern void cairo_current_path_flat (cairo_t * cr, cairo_move_to_func_t * move_to, cairo_line_to_func_t * line_to, cairo_close_path_func_t * close_path, void * closure);

cairo_status_t cairo_status (cairo_t * cr);

const char * cairo_status_string (cairo_t * cr);

## XXX: HAS section, test for capibilities, cairo really needs to dynamically
## register these. and there really ought to be version numbers associated with
## them

void _register_backends (HV * backends);
    CODE:
#ifdef CAIRO_HAS_PS_SURFACE
	hv_store (backends, "ps", 2, newSViv (1), 0);
#endif
#ifdef CAIRO_HAS_PNG_SURFACE
	hv_store (backends, "png", 3, newSViv (1), 0);
#endif
#ifdef CAIRO_HAS_XLIB_SURFACE
	hv_store (backends, "xlib", 4, newSViv (1), 0);
#endif
#ifdef CAIRO_HAS_XCB_SURFACE
	hv_store (backends, "xcb", 3, newSViv (1), 0);
#endif
#ifdef CAIRO_HAS_GLITZ_SURFACE
	hv_store (backends, "glitz", 5, newSViv (1), 0);
#endif
 
