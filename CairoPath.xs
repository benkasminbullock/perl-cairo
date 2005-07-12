/*
 * Copyright (c) 2004-2005 by the cairo perl team (see the file README)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include <cairo-perl.h>

SV *
newSVCairoPath (cairo_path_t * path)
{
	AV * av, * dummy;
	SV * tie;
	HV * stash;

	av = newAV ();
	dummy = newAV ();

	tie = newRV_noinc ((SV *) dummy);
	stash = gv_stashpv ("Cairo::Path", TRUE);
	sv_bless (tie, stash);

	/* Both the dummy and the real array need to have the path stored in
	 * the ext slot.  SvCairoPath looks for it in the real array.
	 * FETCHSIZE and FETCH look for it in the dummy. */
	sv_magic ((SV *) dummy, 0, PERL_MAGIC_ext, (const char *) path, 0);
	sv_magic ((SV *) av, 0, PERL_MAGIC_ext, (const char *) path, 0);
	sv_magic ((SV *) av, tie, PERL_MAGIC_tied, "", 0);

	return newRV_noinc ((SV *) av);
}

cairo_path_t *
SvCairoPath (SV * sv)
{
	MAGIC * mg;
	if (!sv || !SvROK (sv) || !(mg = mg_find (SvRV (sv), PERL_MAGIC_ext)))
		return NULL;
	return (cairo_path_t *) mg->mg_ptr;
}

MODULE = Cairo::Path	PACKAGE = Cairo::Path

void DESTROY (cairo_path_t * path)
    CODE:
	cairo_path_destroy (path);

IV FETCHSIZE (cairo_path_t * path, i_do_not_care_what_this_undocumented_second_argument_is)
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
