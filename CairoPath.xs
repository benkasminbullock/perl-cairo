/*
 * Copyright (c) 2004-2005 by the cairo perl team (see the file README)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Id$
 */

#include <cairo-perl.h>

#include "ppport.h"

#define MY_MAGIC_SIG 0xCAFE /* Let's hope this is unique enough */

static MAGIC *
cairo_perl_mg_find (SV *sv, int type)
{
	if (sv) {
		MAGIC *mg;
		for (mg = SvMAGIC (sv); mg; mg = mg->mg_moremagic) {
			if (mg->mg_type == type && mg->mg_private == MY_MAGIC_SIG)
				return mg;
		}
	}
	return 0;
}

SV *
newSVCairoPath (cairo_path_t * path)
{
	AV * av;
	SV * tie;
	HV * stash;
	MAGIC * mg;

	av = newAV ();

	/* Create a tied reference. */
	tie = newRV_noinc ((SV *) av);
	stash = gv_stashpv ("Cairo::Path", TRUE);
	sv_bless (tie, stash);
	sv_magic ((SV *) av, tie, PERL_MAGIC_tied, Nullch, 0);

	/* Associate the array with the original path via magic. */
	sv_magic ((SV *) av, 0, PERL_MAGIC_ext, (const char *) path, 0);

	mg = mg_find ((SV *) av, PERL_MAGIC_ext);

	/* Mark the mg as belonging to us. */
	mg->mg_private = MY_MAGIC_SIG;

#if PERL_REVISION <= 5 && PERL_VERSION <= 6
	/* perl 5.6.x doesn't actually set mg_ptr when namlen == 0, so do it
	 * now. */
	mg->mg_ptr = (char *) path;
#endif /* 5.6.x */

	return tie;
}

cairo_path_t *
SvCairoPath (SV * sv)
{
	MAGIC * mg;
	if (!sv || !SvROK (sv) || !(mg = cairo_perl_mg_find (SvRV (sv), PERL_MAGIC_ext)))
		return NULL;
	return (cairo_path_t *) mg->mg_ptr;
}

MODULE = Cairo::Path	PACKAGE = Cairo::Path

void DESTROY (SV * sv)
    PREINIT:
	cairo_path_t *path;
    CODE:
	path = SvCairoPath (sv);
	if (path) {
#if PERL_REVISION <= 5 && PERL_VERSION <= 6
		/* Unset mg_ptr to prevent perl 5.6.x from trying to free it again. */
		MAGIC *mg = cairo_perl_mg_find (SvRV (sv), PERL_MAGIC_ext);
		mg->mg_ptr = NULL;
#endif /* 5.6.x */
		cairo_path_destroy (path);
	}

IV FETCHSIZE (cairo_path_t * path)
    PREINIT:
	int i;
    CODE:
	RETVAL = 0;
	for (i = 0; i < path->num_data; i += path->data[i].header.length)
		RETVAL++;
    OUTPUT:
	RETVAL

SV * FETCH (cairo_path_t * path, IV index)
    PREINIT:
	int i, counter = 0;
    CODE:
	RETVAL = &PL_sv_undef;
	for (i = 0; i < path->num_data; i += path->data[i].header.length) {
		if (counter++ == index) {
			cairo_path_data_t *data = &path->data[i];
			HV *hash = newHV ();
			AV *points = newAV (), *tmp;

			switch (data->header.type) {
			    case CAIRO_PATH_MOVE_TO:
			    case CAIRO_PATH_LINE_TO:
				tmp = newAV ();
				av_store (tmp, 0, newSVnv (data[1].point.x));
				av_store (tmp, 1, newSVnv (data[1].point.y));
				av_store (points, 0, newRV_noinc ((SV *) tmp));
				break;
			    case CAIRO_PATH_CURVE_TO:
				tmp = newAV ();
				av_store (tmp, 0, newSVnv (data[1].point.x));
				av_store (tmp, 1, newSVnv (data[1].point.y));
				av_store (points, 0, newRV_noinc ((SV *) tmp));

				tmp = newAV ();
				av_store (tmp, 0, newSVnv (data[2].point.x));
				av_store (tmp, 1, newSVnv (data[2].point.y));
				av_store (points, 1, newRV_noinc ((SV *) tmp));

				tmp = newAV ();
				av_store (tmp, 0, newSVnv (data[3].point.x));
				av_store (tmp, 1, newSVnv (data[3].point.y));
				av_store (points, 2, newRV_noinc ((SV *) tmp));
				break;
			    case CAIRO_PATH_CLOSE_PATH:
				break;
			}

			hv_store (hash, "type", 4, cairo_path_data_type_to_sv (data->header.type), 0);
			hv_store (hash, "points", 6, newRV_noinc ((SV *) points), 0);

			RETVAL = newRV_noinc ((SV *) hash);

			break;
		}
	}
    OUTPUT:
	RETVAL
