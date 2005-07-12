/*
 * Copyright (c) 2004-2005 by the cairo perl team (see the file README)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include <cairo-perl.h>

MODULE = Cairo::Font	PACKAGE = Cairo::FontFace

void DESTROY (cairo_font_face_t * font)
    CODE:
	cairo_font_face_destroy (font);

MODULE = Cairo::Font	PACKAGE = Cairo::ScaledFont	PREFIX = cairo_scaled_font_

##cairo_scaled_font_t* cairo_scaled_font_create (cairo_font_face_t *font_face, const cairo_matrix_t *font_matrix, const cairo_matrix_t *ctm);
cairo_scaled_font_t_noinc * cairo_scaled_font_create (class, cairo_font_face_t *font_face, const cairo_matrix_t *font_matrix, const cairo_matrix_t *ctm)
    C_ARGS:
	font_face, font_matrix, ctm

##cairo_status_t cairo_scaled_font_extents (cairo_scaled_font_t *scaled_font, cairo_font_extents_t *extents);
cairo_font_extents_t * cairo_scaled_font_extents (cairo_scaled_font_t *scaled_font)
    PREINIT:
	cairo_font_extents_t extents;
    CODE:
	if (CAIRO_STATUS_SUCCESS !=
	    cairo_scaled_font_extents (scaled_font, &extents))
		RETVAL = NULL;
	else
		RETVAL = &extents;
    OUTPUT:
	RETVAL

##void cairo_scaled_font_glyph_extents (cairo_scaled_font_t *scaled_font, cairo_glyph_t *glyphs, int num_glyphs, cairo_text_extents_t *extents);
cairo_text_extents_t * cairo_scaled_font_glyph_extents (cairo_scaled_font_t *scaled_font, ...)
    PREINIT:
	cairo_glyph_t * glyphs = NULL;
	int num_glyphs, i;
	cairo_text_extents_t extents;
    CODE:
	num_glyphs = items - 1;
	glyphs = calloc (sizeof (cairo_glyph_t), num_glyphs);
	for (i = 1; i < items; i++)
		glyphs[i - 1] = *SvCairoGlyph (ST (i));
	cairo_scaled_font_glyph_extents (scaled_font, glyphs, num_glyphs, &extents);
	RETVAL = &extents;
	free (glyphs);
    OUTPUT:
	RETVAL

void DESTROY (cairo_scaled_font_t * font)
    CODE:
	cairo_scaled_font_destroy (font);
