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

use Cairo;

isa_ok (my $matrix = Cairo::Matrix->create, 'Cairo::Matrix');

{
	isa_ok ($matrix->copy, 'Cairo::Matrix', '$matrix->copy');
}

eval
{
	$matrix->set_identity;
	$matrix->translate (2, 3);
	$matrix->scale (3, 4);
	$matrix->rotate (3.14);
	$matrix->invert;
};
is ($@, '', 'set_identity, translate, scale, rotate, invert');

$matrix->set_affine (1, 2, 3, 4, 5, 6);
is_deeply ([$matrix->get_affine], [1, 2, 3, 4, 5, 6],
	   '$matrix->set|get_affine');

is_deeply ([$matrix->transform_distance (1, 2)], [7, 10],
	   '$matrix->transform_distance');

is_deeply ([$matrix->transform_point (2, 3)], [16, 22],
	   '$matrix->transform_point');

