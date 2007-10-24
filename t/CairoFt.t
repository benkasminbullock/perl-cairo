#!/usr/bin/perl
#
# Copyright (c) 2007 by the cairo perl team (see the file README)
#
# Licensed under the LGPL, see LICENSE file for more information.
#
# $Header$
#

use strict;
use warnings;

use Test::More;

use Cairo;

unless (Cairo::HAS_FT_FONT && eval 'use Font::FreeType; 1;') {
	plan skip_all => 'need Cairo with FreeType support and Font::FreeType';
}

my $file = '/usr/share/fonts/truetype/ttf-bitstream-vera/Vera.ttf';
unless (-r $file) {
	plan skip_all => 'can\'t find font file';
}

plan tests => 2;

my $ft_face = Font::FreeType->new->face ($file);
my $cr_ft_face = Cairo::FtFontFace->create ($ft_face);
isa_ok ($cr_ft_face, 'Cairo::FontFace');
is ($cr_ft_face->status, 'success');
