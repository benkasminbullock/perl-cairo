#!/usr/bin/perl
#
# Copyright (c) 2004-2011 by the cairo perl team (see the file README)
#
# Licensed under the LGPL, see LICENSE file for more information.
#
# $Id$
#

use strict;
use warnings;
use Cairo;

use Test::More tests => 6;

use constant IMG_WIDTH => 256;
use constant IMG_HEIGHT => 256;

my $surf = Cairo::ImageSurface->create ('rgb24', IMG_WIDTH, IMG_HEIGHT);
my $cr = Cairo::Context->create ($surf);

$cr->new_path;
$cr->move_to (1, 2);
$cr->line_to (3, 4);
$cr->curve_to (5, 6, 7, 8, 9, 10);
$cr->close_path;

my $expected_path = [
  { type => "move-to", points => [[1, 2]] },
  { type => "line-to", points => [[3, 4]] },
  { type => "curve-to", points => [[5, 6], [7, 8], [9, 10]] },
  { type => "close-path", points => [] },
  { type => "move-to", points => [[1, 2]] }
];

my $path = $cr->copy_path;
is_deeply ($path, $expected_path);

sub paths_agree {
  my ($cr, $path, $expected_path) = @_;
  $cr->new_path;
  $cr->append_path ($path);
  is_deeply ($cr->copy_path, $expected_path);
}

# Modifying single point values.
foreach ($path, $expected_path) {
  $_->[1]{points}[0][0] = 33;
  $_->[1]{points}[0][1] = 44;

  $_->[2]{points}[2][0] = 99;
  $_->[2]{points}[2][1] = 1010;
}
paths_agree ($cr, $path, $expected_path);

# Modifying single points.
foreach ($path, $expected_path) {
  $_->[1]{points}[0] = [333, 444];
  $_->[2]{points}[2] = [77, 88];
}
paths_agree ($cr, $path, $expected_path);

# Replacing all points.
foreach ($path, $expected_path) {
  $_->[1]{points} = [[3333, 4444]];
  $_->[2]{points} = [[55, 66], [77, 88], [99, 1010]];
}
paths_agree ($cr, $path, $expected_path);

# Replacing and adding path segments.
my @cloned_path = @{$path};
foreach (\@cloned_path, $expected_path) {
  $_->[1] = {
    type => 'curve-to',
    points => [[55, 66], [77, 88], [99, 1010]] };
  $_->[2] = {
    type => 'line-to',
    points => [[3333, 4444]] };
  splice @{$_}, 3, 0, {
    type => 'line-to',
    points => [[23, 42]] };
}
paths_agree ($cr, \@cloned_path, $expected_path);

# Passing bare arrays into Cairo.
$cr->new_path;
$cr->append_path ($expected_path);
is_deeply ($cr->copy_path, $expected_path);
