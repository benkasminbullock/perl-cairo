#
# Copyright (c) 2004-2005 by the cairo perl team (see the file README)
#
# Licensed under the LGPL, see LICENSE file for more information.
#
# $Header$
#

use strict;
use warnings;

use Test::More tests => 3;

use constant {
	IMG_WIDTH => 256,
	IMG_HEIGHT => 256,
};

use Cairo;

my $surf = Cairo::ImageSurface->create ('rgb24', IMG_WIDTH, IMG_HEIGHT);
my $cr = Cairo::Context->create ($surf);
my $face = $cr->get_font_face;

my $matrix = Cairo::Matrix->init_identity;
my $ctm = Cairo::Matrix->init_identity;

my $font = Cairo::ScaledFont->create ($face, $matrix, $ctm);
isa_ok ($font, 'Cairo::ScaledFont');
isa_ok ($font->extents, 'HASH');
isa_ok ($font->glyph_extents ({ index => 1, x => 2, y => 3 }), 'HASH');
