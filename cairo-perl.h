/*
 * Copyright (c) 2004-2005 by the cairo perl team (see the file README)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 *
 */

#ifndef _CAIRO_PERL_H_
#define _CAIRO_PERL_H_

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <cairo.h>

#ifdef CAIRO_HAS_PNG_SURFACE
# include <cairo-png.h>
#endif

#ifdef CAIRO_HAS_PS_SURFACE
# include <cairo-ps.h>
#endif

#ifdef CAIRO_HAS_PDF_SURFACE
# include <cairo-pdf.h>
#endif

/*
 * standard object and struct handling
 */
void *cairo_object_from_sv (SV *sv, const char *package);
SV *cairo_object_to_sv (void *object, const char *package);

void *cairo_struct_from_sv (SV *sv, const char *package);
SV *cairo_struct_to_sv (void *object, const char *package);

/*
 * custom struct handling
 */
SV * newSVCairoFontExtents (cairo_font_extents_t * extents);

SV * newSVCairoTextExtents (cairo_text_extents_t * extents);

SV * newSVCairoGlyph (cairo_glyph_t * glyph);
cairo_glyph_t * SvCairoGlyph (SV * sv);

SV * newSVCairoPath (cairo_path_t * path);
cairo_path_t * SvCairoPath (SV * sv);

/*
 * support for custom surface types
 */
typedef cairo_surface_t cairo_image_surface_t;
#define cairo_image_surface_reference cairo_surface_reference
#define cairo_image_surface_destroy cairo_surface_destroy
#ifdef CAIRO_HAS_PDF_SURFACE
  typedef cairo_surface_t cairo_pdf_surface_t;
# define cairo_pdf_surface_reference cairo_surface_reference
# define cairo_pdf_surface_destroy cairo_surface_destroy
#endif
#ifdef CAIRO_HAS_PS_SURFACE
  typedef cairo_surface_t cairo_ps_surface_t;
# define cairo_ps_surface_reference cairo_surface_reference
# define cairo_ps_surface_destroy cairo_surface_destroy
#endif

/*
 * support for custom pattern types
 */
typedef cairo_pattern_t cairo_surface_pattern_t;
#define cairo_surface_pattern_reference cairo_pattern_reference
#define cairo_surface_pattern_destroy cairo_pattern_destroy
typedef cairo_pattern_t cairo_gradient_t;
#define cairo_gradient_reference cairo_pattern_reference
#define cairo_gradient_destroy cairo_pattern_destroy
typedef cairo_pattern_t cairo_linear_gradient_t;
#define cairo_linear_gradient_reference cairo_pattern_reference
#define cairo_linear_gradient_destroy cairo_pattern_destroy
typedef cairo_pattern_t cairo_radial_gradient_t;
#define cairo_radial_gradient_reference cairo_pattern_reference
#define cairo_radial_gradient_destroy cairo_pattern_destroy

#include <cairo-perl-auto.h>

/* call the boot code of a module by symbol rather than by name.
 *
 * in a perl extension which uses several xs files but only one pm, you
 * need to bootstrap the other xs files in order to get their functions
 * exported to perl.  if the file has MODULE = Foo::Bar, the boot symbol
 * would be boot_Foo__Bar.
 *
 * copied/borrowed from gtk2-perl.
 */
void _cairo_perl_call_XS (pTHX_ void (*subaddr) (pTHX_ CV *), CV * cv, SV ** mark);
#define CAIRO_PERL_CALL_BOOT(name)				\
	{							\
		extern XS(name);				\
		_cairo_perl_call_XS (aTHX_ name, cv, mark);	\
	}

#define CAIRO_PERL_UNUSED(var) if (0) { (var) = (var); }

#endif /* _CAIRO_PERL_H_ */
