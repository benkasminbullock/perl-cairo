#
# Copyright (c) 2004 by the cairo  perl team (see the file README)
#
# Licensed under the LGPL, see LICENSE file for more information.
#
# $Header$
#

use strict;
use warnings;
use Data::Dumper;

use Test::More tests => 6;

use constant {
	IMG_WIDTH => 256,
	IMG_HEIGHT => 256,
};

use Cairo;

{
	my $surf = Cairo::Surface->image_create ('RGB24', IMG_WIDTH,
						 IMG_HEIGHT);
	isa_ok (Cairo::Pattern->create_for_surface ($surf), 'Cairo::Pattern',
		'Cairo::Pattern->create_for_surface');
}


isa_ok (Cairo::Pattern->create_linear (1, 2, 3, 4), 'Cairo::Pattern',
	'Cairo::Pattern->create_linear');

isa_ok (my $pat = Cairo::Pattern->create_radial (1, 2, 3, 4, 5, 6),
	'Cairo::Pattern', 'Cairo::Pattern->create_radial');

$pat->add_color_stop (1, 0.5, 0.6, 0.7, 0.8);

{
	my $matrix = Cairo::Matrix->create;
	$pat->set_matrix ($matrix);
	isa_ok ($pat->get_matrix, 'Cairo::Matrix', '$pat->get_matrix');
}

$pat->set_extend ('NONE');
is ($pat->get_extend, 'NONE', '$pat->set|get_extend');

$pat->set_filter ('FAST');
is ($pat->get_filter, 'FAST', '$pat->set|get_filter');
