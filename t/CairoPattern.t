#
# Copyright (c) 2004-2005 by the cairo perl team (see the file README)
#
# Licensed under the LGPL, see LICENSE file for more information.
#
# $Header$
#

use strict;
use warnings;

use Test::More tests => 16;

use constant {
	IMG_WIDTH => 256,
	IMG_HEIGHT => 256,
};

use Cairo;

my $pat = Cairo::SolidPattern->create_rgb(1.0, 0.0, 0.0);
isa_ok ($pat, 'Cairo::SolidPattern');
isa_ok ($pat, 'Cairo::Pattern');

$pat = Cairo::SolidPattern->create_rgba(1.0, 0.0, 0.0, 1.0);
isa_ok ($pat, 'Cairo::SolidPattern');
isa_ok ($pat, 'Cairo::Pattern');

my $surf = Cairo::ImageSurface->create ('rgb24', IMG_WIDTH, IMG_HEIGHT);
$pat = Cairo::SurfacePattern->create ($surf);
isa_ok ($pat, 'Cairo::SurfacePattern');
isa_ok ($pat, 'Cairo::Pattern');

$pat->set_extend ('none');
is ($pat->get_extend, 'none', '$pat->set|get_extend');

$pat->set_filter ('fast');
is ($pat->get_filter, 'fast', '$pat->set|get_filter');

$pat = Cairo::LinearGradient->create (1, 2, 3, 4);
isa_ok ($pat, 'Cairo::LinearGradient');
isa_ok ($pat, 'Cairo::Gradient');
isa_ok ($pat, 'Cairo::Pattern');

$pat = Cairo::RadialGradient->create (1, 2, 3, 4, 5, 6);
isa_ok ($pat, 'Cairo::RadialGradient');
isa_ok ($pat, 'Cairo::Gradient');
isa_ok ($pat, 'Cairo::Pattern');

$pat->add_color_stop_rgb (1, 0.5, 0.6, 0.7);
$pat->add_color_stop_rgba (1, 0.5, 0.6, 0.7, 0.8);

my $matrix = Cairo::Matrix->init_identity;
$pat->set_matrix ($matrix);
isa_ok ($pat->get_matrix, 'Cairo::Matrix');

is ($pat->status, 'success');
