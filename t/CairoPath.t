#!/usr/bin/perl
#
# Copyright (c) 2004-2005 by the cairo perl team (see the file README)
#
# Licensed under the LGPL, see LICENSE file for more information.
#
# $Id$
#

use strict;
use warnings;
use Cairo;

use Test::More tests => 4;

use constant IMG_WIDTH => 256;
use constant IMG_HEIGHT => 256;

my $surf = Cairo::ImageSurface->create ('rgb24', IMG_WIDTH, IMG_HEIGHT);
my $cr = Cairo::Context->create ($surf);

$cr->new_path;
$cr->move_to (1, 2);
$cr->line_to (3, 4);
$cr->curve_to (5, 6, 7, 8, 9, 10);
$cr->close_path;

my $path = $cr->copy_path;

is_deeply ($path->[0], { type => "move-to", points => [[1, 2]] });
is_deeply ($path->[1], { type => "line-to", points => [[3, 4]] });
is_deeply ($path->[2], { type => "curve-to", points => [[5, 6], [7, 8], [9, 10]] });
is_deeply ($path->[3], { type => "close-path", points => [] });
