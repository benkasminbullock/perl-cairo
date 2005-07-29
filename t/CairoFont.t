#
# Copyright (c) 2004-2005 by the cairo perl team (see the file README)
#
# Licensed under the LGPL, see LICENSE file for more information.
#
# $Header$
#

use strict;
use warnings;

use Test::More tests => 13;

use constant {
	IMG_WIDTH => 256,
	IMG_HEIGHT => 256,
};

use Cairo;

my $options = Cairo::FontOptions->create;
isa_ok ($options, 'Cairo::FontOptions');

is ($options->status, 'success');

$options->merge (Cairo::FontOptions->create);

ok ($options->equal ($options));

is ($options->hash, 0);

$options->set_antialias ('subpixel');
is ($options->get_antialias, 'subpixel');

$options->set_subpixel_order ('rgb');
is ($options->get_subpixel_order, 'rgb');

$options->set_hint_style ('full');
is ($options->get_hint_style, 'full');

$options->set_hint_metrics ('on');
is ($options->get_hint_metrics, 'on');

# --------------------------------------------------------------------------- #

my $surf = Cairo::ImageSurface->create ('rgb24', IMG_WIDTH, IMG_HEIGHT);
my $cr = Cairo::Context->create ($surf);
my $face = $cr->get_font_face;

is ($face->status, 'success');

my $matrix = Cairo::Matrix->init_identity;
my $ctm = Cairo::Matrix->init_identity;

my $font = Cairo::ScaledFont->create ($face, $matrix, $ctm, $options);
isa_ok ($font, 'Cairo::ScaledFont');
is ($font->status, 'success');
isa_ok ($font->extents, 'HASH');
isa_ok ($font->glyph_extents ({ index => 1, x => 2, y => 3 }), 'HASH');
