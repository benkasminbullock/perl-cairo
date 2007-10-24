/*
 * Copyright (c) 2007 by the cairo perl team (see the file README)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include <cairo-perl.h>

MODULE = Cairo::Ft	PACKAGE = Cairo::FtFontFace PREFIX = cairo_ft_font_face_

# cairo_font_face_t * cairo_ft_font_face_create_for_ft_face (FT_Face face, int load_flags);
cairo_font_face_t_noinc *
cairo_ft_font_face_create (class, FT_Face face, int load_flags=0)
    CODE:
	RETVAL = cairo_ft_font_face_create_for_ft_face (face, load_flags);
    OUTPUT:
	RETVAL
